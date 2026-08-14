<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="tei svg xs">

    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0"
        indent="no" omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/seg.xsl"/>
    <xsl:import href="./partials/bibl.xsl"/>
    <xsl:import href="./partials/event.xsl"/>
    <xsl:import href="./partials/scripts.xsl"/>
    <xsl:import href="./partials/shared.xsl"/>

    <xsl:template match="/">
        <xsl:apply-templates select="tei:figure"/>
    </xsl:template>

    <!-- 
         Wurzelelement tei:figure → vollständiges HTML-Dokument
          -->
    <xsl:template match="tei:figure">
        <xsl:variable name="doc_title">
            <xsl:text>Textgenese – Überlieferung</xsl:text>
        </xsl:variable>
        <!-- SVG-Partner wird über den Dateinamen ermittelt (gleicher Basisname, Endung .svg statt .xml),
             nicht mehr über tei:graphic/@url -->
        <xsl:variable name="svg_uri" select="replace(base-uri(/), '\.xml$', '.svg')"/>
        <html lang="{$site_language}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
            </head>
            <body id="witrels-vis" class="d-flex flex-column overflow-visible pe-0">
                <xsl:call-template name="nav_bar">
                    <xsl:with-param name="container" select="'container-fluid px-5'"/>
                    <xsl:with-param name="logo_small" select="true()"/>
                </xsl:call-template>

                <main class="wrapper gv-wrapper">
                    <div class="gv-row">

                        <!-- SVG-Hauptbereich -->
                        <div class="gv-main text-black-grey ls-1">
                            <div class="svg-wrap">
                                <xsl:copy-of select="document($svg_uri)/svg:svg"/>
                            </div>
                        </div>

                        <!-- Sidebar -->
                        <aside class="border-start border-light-grey bg-primary bg-opacity-5 position-relative"
                               id="sidebar-container">
                            <!-- schwebt außerhalb der Aside-Box (wie zuvor der schmale äußere Tab), zählt
                                 daher nicht zur Breite, die die Aside dem svg wegnimmt -->
                            <button class="sidebar-toggle sidebar-toggle-floating" title="Seitenleiste schließen">
                                <img class="sidebar-toggle-icon-open" src="images/plus.svg" alt="Seitenleiste schließen"/>
                                <span class="sidebar-toggle-icon-closed visually-hidden" style="stroke:grey;fill:grey;">
                                    <svg width="18" height="18" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false"><g><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path></g></svg>
                                </span>
                            </button>
                            <nav class="sidebar">
                              <div class="sidebar-header row z-index-1 bg-white text-center m-0 border border-light-grey position-sticky top-nav flex-row">
                                    <div class="col-auto p-0_25 border-end border-light-grey align-content-around sidebar-header-extra">
                                        <button type="button" id="btn-chapters" class="chapters-toggle cursor-pointer" aria-pressed="false" title="Abschnitte ein-/ausblenden">
                                            Abschnitte ein/aus
                                        </button>
                                    </div>
                                    <div class="col border-end border-light-grey sidebar-header-extra" aria-hidden="true"></div>
                                </div>
                                <div class="row m-0 flex-row flex-nowrap sidebar-content-row">
                                    <div class="col p-0 border-start border-light-grey sidebar-content-cell">
                                        <ul class="nav-l1">
                                            <xsl:apply-templates select="tei:figDesc/tei:list[@type='axes']/tei:item"/>
                                        </ul>
                                    </div>
                                </div>
                            </nav>
                        </aside>

                    </div>
                </main>

                <xsl:call-template name="scripts"/>

                <div id="svg-tooltip"></div>

                <script><![CDATA[
document.addEventListener('DOMContentLoaded', function () {

  /* ── Titelgliederung (anchor @type=title) ── */
  var chaptersG = document.getElementById('chapters');
  if (chaptersG) chaptersG.style.display = 'none';
  var btnChapters = document.getElementById('btn-chapters');
  if (btnChapters) {
    btnChapters.addEventListener('click', function () {
      var active = btnChapters.classList.toggle('bg-primary');
      btnChapters.classList.toggle('text-white');
      btnChapters.setAttribute('aria-pressed', active ? 'true' : 'false');
      if (chaptersG) chaptersG.style.display = active ? '' : 'none';
    });
  }

  /* ── Element-Cache ────────────────────────────────────────────────────*/
  var allPassages    = Array.prototype.slice.call(document.querySelectorAll('.passage'));
  var allConnections = Array.prototype.slice.call(document.querySelectorAll('.connection'));

  /* Dokument → Achsen-Index */
  var docAxisIdx = {};
  document.querySelectorAll('.nav-axis').forEach(function(ax) {
    var idx = parseInt(ax.dataset.idx, 10);
    ax.querySelectorAll('.nav-doc').forEach(function(d) { docAxisIdx[d.dataset.doc] = idx; });
  });

  /* ── Zustand ──────────────────────────────────────────────────────────*/
  var hoveredDoc     = null;
  var hoveredPassage = null;
  var pinned         = {};   /* 'doc|||id' → { doc, id } */
  var pinnedCount    = 0;
  var resetTimer     = null;

  function scheduleReset() { resetTimer = setTimeout(doReset, 300); }
  function cancelReset()   { if (resetTimer) { clearTimeout(resetTimer); resetTimer = null; } }
  function doReset() {
    resetTimer = null; hoveredDoc = null; hoveredPassage = null;
    render();
  }

  /* Scrollt ein Element in die Sichtfläche der .sidebar */
  function scrollNavIntoView(el) {
    var nav = el.closest ? el.closest('.sidebar') : null;
    if (!nav) return;
    var navRect = nav.getBoundingClientRect();
    var elRect  = el.getBoundingClientRect();
    if (elRect.top < navRect.top) {
      nav.scrollTop += elRect.top - navRect.top - 4;
    } else if (elRect.bottom > navRect.bottom) {
      nav.scrollTop += elRect.bottom - navRect.bottom + 4;
    }
  }

  function passEl(doc, id) {
    for (var i = 0; i < allPassages.length; i++) {
      if (allPassages[i].dataset.doc === doc && allPassages[i].dataset.id === id) return allPassages[i];
    }
    return null;
  }

  /* ── rAF-Animation für fill-opacity ──────────────────────────────────*/
  var animItems = new Map();
  var rafId     = null;
  var FADE_MS   = 600;

  function animStep(ts) {
    var done = [];
    animItems.forEach(function(item, el) {
      if (item.startTime === null) item.startTime = ts;
      var t = item.duration > 0 ? Math.min(1, (ts - item.startTime) / item.duration) : 1;
      el.style.fillOpacity = item.start + (item.target - item.start) * t;
      if (t >= 1) done.push(el);
    });
    done.forEach(function(el) { animItems.delete(el); });
    rafId = animItems.size > 0 ? requestAnimationFrame(animStep) : null;
  }

  function setOpacity(el, v) {
    var cur = parseFloat(el.style.fillOpacity);
    if (isNaN(cur)) cur = 0;
    var existing = animItems.get(el);
    var targetNow = existing ? existing.target : cur;
    if (Math.abs(targetNow - v) < 0.001) return;
    animItems.set(el, { start: cur, target: v, startTime: null, duration: v < cur ? FADE_MS : 0 });
    if (!rafId) rafId = requestAnimationFrame(animStep);
  }

  /* ── Zentrales Rendering ──────────────────────────────────────────────*/
  function render() {
    var tp = new Map();
    var tc = new Map();

    function markP(p, v) { tp.set(p, Math.max(tp.get(p) || 0, v)); }
    function markC(c, v) { tc.set(c, Math.max(tc.get(c) || 0, v)); }

    if (hoveredDoc) {
      for (var i = 0; i < allPassages.length; i++) {
        if (allPassages[i].dataset.doc === hoveredDoc) markP(allPassages[i], 0.4);
      }
    }

    if (hoveredPassage) {
      for (var i = 0; i < allConnections.length; i++) {
        var c = allConnections[i];
        var isSrc = c.dataset.srcDoc === hoveredPassage.doc && c.dataset.srcId === hoveredPassage.id;
        var isTgt = c.dataset.tgtDoc === hoveredPassage.doc && c.dataset.tgtId === hoveredPassage.id;
        if (isSrc || isTgt) {
          markC(c, 0.25);
          var oDoc = isSrc ? c.dataset.tgtDoc : c.dataset.srcDoc;
          var oId  = isSrc ? c.dataset.tgtId  : c.dataset.srcId;
          var op = passEl(oDoc, oId);
          if (op) markP(op, 0.4);
        }
      }
    }

    for (var key in pinned) {
      if (!pinned.hasOwnProperty(key)) continue;
      var pin = pinned[key];
      var pe = passEl(pin.doc, pin.id);
      if (pe) markP(pe, 1);
      for (var i = 0; i < allConnections.length; i++) {
        var c = allConnections[i];
        var isSrc = c.dataset.srcDoc === pin.doc && c.dataset.srcId === pin.id;
        var isTgt = c.dataset.tgtDoc === pin.doc && c.dataset.tgtId === pin.id;
        if (isSrc || isTgt) {
          markC(c, 0.8);
          var oDoc = isSrc ? c.dataset.tgtDoc : c.dataset.srcDoc;
          var oId  = isSrc ? c.dataset.tgtId  : c.dataset.srcId;
          var op = passEl(oDoc, oId);
          if (op) markP(op, 0.4);
        }
      }
    }

    for (var i = 0; i < allPassages.length; i++) {
      var p = allPassages[i];
      var v = tp.get(p) || 0;
      setOpacity(p, v);
      p.style.pointerEvents = v > 0 ? 'auto' : 'none';
      p.style.stroke        = '';
      p.style.strokeWidth   = '';
    }
    for (var i = 0; i < allConnections.length; i++) {
      var c = allConnections[i];
      var v = tc.get(c) || 0;
      setOpacity(c, v);
      c.style.pointerEvents = v > 0 ? 'auto' : 'none';
    }
  }

  /* ── Dokument-Hover: nur Hervorhebung im SVG, keine Reaktion in der Infospalte ── */
  function enterDoc(docName) {
    cancelReset();
    hoveredDoc = docName;
    render();
  }

  function clearNavPassageSelection() {
    document.querySelectorAll('.nav-passage.open').forEach(function(el) {
      el.classList.remove('open');
      var d = el.querySelector('.pass-detail');
      if (d) d.style.display = 'none';
    });
  }

  /* ── Alles zurücksetzen ───────────────────────────────────────────────*/
  function clearAll() {
    cancelReset();
    pinned = {}; pinnedCount = 0;
    hoveredDoc = null; hoveredPassage = null;
    render();
    clearNavPassageSelection();
  }

  /* ── Event-Listener ───────────────────────────────────────────────────*/

  var visSvg = document.getElementById('vis-svg') || document.querySelector('svg');
  if (visSvg) visSvg.addEventListener('click', clearAll);

  document.querySelectorAll('.doc-rect').forEach(function(rect) {
    rect.addEventListener('mouseenter', function() { enterDoc(rect.dataset.doc); });
    rect.addEventListener('mouseleave', scheduleReset);
    rect.addEventListener('click', function(e) { e.stopPropagation(); });
  });

  document.querySelectorAll('.passage').forEach(function(p) {
    p.addEventListener('mousedown', function(e) { e.stopPropagation(); });
    p.addEventListener('mouseenter', function() {
      cancelReset();
      hoveredDoc     = p.dataset.doc;
      hoveredPassage = { doc: p.dataset.doc, id: p.dataset.id };
      render();
    });
    p.addEventListener('mouseleave', scheduleReset);
    /* Klick verhält sich wie ein Klick auf die zugehörige Sidebar-Passage */
    p.addEventListener('click', function(e) {
      e.stopPropagation();
      var np = document.querySelector('.nav-passage[data-id="' + p.dataset.id + '"]');
      if (np) np.click();
    });
  });

  document.querySelectorAll('.connection').forEach(function(c) {
    c.addEventListener('mouseenter', cancelReset);
    c.addEventListener('mouseleave', scheduleReset);
    c.addEventListener('click', function(e) { e.stopPropagation(); });
  });

  document.querySelectorAll('.nav-axis-label').forEach(function(span) {
    span.addEventListener('click', function(e) { e.stopPropagation(); span.closest('.nav-axis').classList.toggle('open'); });
  });

  document.querySelectorAll('.nav-doc').forEach(function(li) {
    li.addEventListener('mouseenter', function() { enterDoc(li.dataset.doc); });
    li.addEventListener('mouseleave', scheduleReset);
    li.addEventListener('click', function(e) { e.stopPropagation(); li.classList.toggle('open'); });
  });

  document.querySelectorAll('.nav-passage').forEach(function(li) {
    li.addEventListener('mouseenter', function() {
      var docEl = li.closest('.nav-doc');
      var doc = docEl ? docEl.dataset.doc : '';
      cancelReset();
      hoveredDoc     = doc;
      hoveredPassage = { doc: doc, id: li.dataset.id };
      render();
    });
    li.addEventListener('mouseleave', scheduleReset);
    li.addEventListener('click', function(e) {
      e.stopPropagation();
      var docEl = li.closest('.nav-doc');
      var doc = docEl ? docEl.dataset.doc : '';
      var id  = li.dataset.id;
      var key = doc + '|||' + id;
      var det = li.querySelector('.pass-detail');
      if (li.classList.contains('open')) {
        li.classList.remove('open');
        if (det) det.style.display = 'none';
        delete pinned[key]; pinnedCount--;
        render();
      } else {
        var axisEl = li.closest('.nav-axis');
        if (axisEl && !axisEl.classList.contains('open')) axisEl.classList.add('open');
        if (docEl && !docEl.classList.contains('open')) docEl.classList.add('open');
        li.classList.add('open');
        if (det) det.style.display = 'block';
        scrollNavIntoView(li);
        pinned[key] = {doc: doc, id: id}; pinnedCount++;
        render();
      }
    });
  });

  /* ── Tooltip ─────────────────────────────────────────────────────────*/
  var tooltip = document.getElementById('svg-tooltip');
  function positionTooltip(e) {
    var x = e.clientX + 14, y = e.clientY + 14;
    if (x + tooltip.offsetWidth  > window.innerWidth  - 8) x = e.clientX - tooltip.offsetWidth  - 14;
    if (y + tooltip.offsetHeight > window.innerHeight - 8) y = e.clientY - tooltip.offsetHeight - 14;
    tooltip.style.left = x + 'px';
    tooltip.style.top  = y + 'px';
  }
  if (tooltip) {
    document.querySelectorAll('.passage').forEach(function(p) {
      p.addEventListener('mouseenter', function(e) {
        var inc = p.dataset.incipit || '';
        if (!inc) return;
        tooltip.textContent = '„' + inc + '“';
        tooltip.style.display = 'block';
        positionTooltip(e);
      });
      p.addEventListener('mousemove', positionTooltip);
      p.addEventListener('mouseleave', function() { tooltip.style.display = 'none'; });
    });
  }

  /* ── Textträger-Details nicht mit dem Passagen-Toggle kollidieren lassen ── */
  document.querySelectorAll('.pass-conn > summary').forEach(function(s) {
    s.addEventListener('click', function(e) { e.stopPropagation(); });
  });

  /* ── Klick auf Label einer verbundenen Passage ────────────────────────*/
  document.querySelectorAll('.pass-conn-incipit[data-target]').forEach(function(el) {
    el.style.cursor = 'pointer';
    el.addEventListener('click', function(e) {
      e.stopPropagation();
      var id = (el.dataset.target || '').replace(/^#/, '');
      if (!id) return;
      var np = document.querySelector('.nav-passage[data-id="' + id + '"]');
      if (!np) return;
      var nd = np.closest('.nav-doc');
      var na = np.closest('.nav-axis');
      if (na && !na.classList.contains('open')) na.classList.add('open');
      if (nd && !nd.classList.contains('open')) nd.classList.add('open');
      if (!np.classList.contains('open')) {
        np.classList.add('open');
        var det = np.querySelector('.pass-detail');
        if (det) det.style.display = 'block';
        var docEl = nd;
        var doc = docEl ? docEl.dataset.doc : '';
        var key = doc + '|||' + id;
        if (!pinned[key]) { pinned[key] = {doc: doc, id: id}; pinnedCount++; }
        render();
      }
      scrollNavIntoView(np);
    });
  });

  /* ── Sidebar-Toggle (zwei Buttons, dieselbe Funktion) ───────────────────*/
  var sidebarContainer = document.getElementById('sidebar-container');
  var sidebarToggles   = document.querySelectorAll('.sidebar-toggle');
  if (sidebarContainer && sidebarToggles.length) {
    var setSidebarToggleIcons = function(collapsed) {
      sidebarToggles.forEach(function(btn) {
        btn.title = collapsed ? 'Seitenleiste öffnen' : 'Seitenleiste schließen';
        btn.querySelectorAll('.sidebar-toggle-icon-open').forEach(function(el) {
          el.classList.toggle('visually-hidden', collapsed);
        });
        btn.querySelectorAll('.sidebar-toggle-icon-closed').forEach(function(el) {
          el.classList.toggle('visually-hidden', !collapsed);
        });
      });
    };
    sidebarToggles.forEach(function(btn) {
      btn.addEventListener('click', function() {
        var collapsed = sidebarContainer.classList.toggle('collapsed');
        setSidebarToggleIcons(collapsed);
      });
    });
  }

});
                ]]></script>
            </body>
        </html>
    </xsl:template>


    <!-- Nav Level 1: Achse -->
    <xsl:template match="tei:list[@type='axes']/tei:item">
        <li class="nav-axis" data-idx="{count(preceding-sibling::tei:item)}">
            <h5 class="nav-axis-label text-dropdown-toggle mb-0"><xsl:value-of select="tei:label"/></h5>
            <ul class="nav-l2">
                <xsl:apply-templates select="tei:list[@type='documents']/tei:item"/>
            </ul>
        </li>
    </xsl:template>


    <!-- Nav Level 2: Dokument -->
    <xsl:template match="tei:list[@type='documents']/tei:item">
        <li class="nav-doc" data-doc="{tei:label}">
            <h6 class="nav-doc-label text-dropdown-toggle mb-0"><xsl:value-of select="tei:label"/></h6>
            <xsl:if test="tei:list[@type='passages']/tei:item">
                <ul class="nav-l3">
                    <xsl:apply-templates select="tei:list[@type='passages']/tei:item"/>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>


    <!-- Nav Level 3: Passage -->
    <xsl:template match="tei:list[@type='passages']/tei:item">
        <li class="nav-passage fs-6 text-dark-grey" data-id="{@xml:id}">
            <span class="pass-incipit">&#8222;<xsl:value-of select="tei:label"/>&#8220;</span>
            <xsl:if test="tei:ref[@type='page'] or tei:ref[@type='url']">
                <span class="pass-meta">
                    <xsl:if test="tei:ref[@type='page']">
                        <xsl:text>S.&#160;</xsl:text>
                        <xsl:value-of select="tei:ref[@type='page']"/>
                    </xsl:if>
                    <xsl:if test="tei:ref[@type='url']">
                        <a href="{tei:ref[@type='url']/@target}" target="_blank" class="ps-2 text-decoration-none text-dark-grey">
                            <xsl:text>Link</xsl:text>
                            <svg class="ms-2 align-middle" width="5" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                                <path style="fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path>
                            </svg>
                        </a>
                    </xsl:if>
                </span>
            </xsl:if>
            <xsl:if test="tei:ref[@type='otherDoc']">
                <div class="pass-detail" style="display:none">
                    <xsl:apply-templates select="tei:ref[@type='otherDoc']"/>
                </div>
            </xsl:if>
        </li>
    </xsl:template>


    <!-- Verbundene Passage (otherDoc-ref) -->
    <xsl:template match="tei:ref[@type='otherDoc']">
        <details class="pass-conn py-1 border-bottom border-bottom border-light-grey">
            <summary class="d-flex align-items-baseline pass-conn-heading">
                <xsl:choose>
                    <xsl:when test="@subtype='later'">Entsprechung auf späterem Textträger</xsl:when>
                    <xsl:otherwise>Entsprechung auf früherem Textträger</xsl:otherwise>
                </xsl:choose>
            </summary>
            <div class="pass-conn-incipit" data-target="{@target}">&#8222;<xsl:value-of select="tei:label"/>&#8220;</div>
            <div class="pd-conn-meta">
                <xsl:value-of select="tei:ref[@type='doc']"/>
                <xsl:if test="tei:ref[@type='page']">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="tei:ref[@type='page']"/>
                </xsl:if>
                <xsl:if test="tei:ref[@type='url']">
                    <a href="{tei:ref[@type='url']/@target}" target="_blank" class="ps-2 text-decoration-none text-dark-grey">
                        <xsl:text>Link</xsl:text>
                        <svg class="ms-2 align-middle" width="5" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                            <path style="fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path>
                        </svg>
                    </a>
                </xsl:if>
            </div>
        </details>
    </xsl:template>


    <!-- Nicht zugeordnete tei:item-Elemente ignorieren -->
    <xsl:template match="tei:item"/>

</xsl:stylesheet>
