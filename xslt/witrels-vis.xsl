<?xml version="1.0" encoding="UTF-8"?>
<!--
  witrels-vis.xsl  –  Witness-Relations-Visualisierung, Web-App-Integration
  Eingabe : vis_figure.xml  (tei:figure als Wurzelelement)
  Ausgabe : witnessRelations.html
  Produktionsweg: Ant + Saxon 9 HE (build.xml)
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="tei svg xs">

    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0"
        indent="no" omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/seg.xsl"/>
    <xsl:import href="./partials/bibl.xsl"/>
    <xsl:import href="./partials/event.xsl"/>
    <xsl:import href="./partials/scripts.xsl"/>
    <xsl:import href="./partials/shared.xsl"/>

    <xsl:template match="/">
        <xsl:apply-templates select="tei:figure"/>
    </xsl:template>

    <!-- ===================================================================
         Wurzelelement tei:figure → vollständiges HTML-Dokument
         =================================================================== -->
    <xsl:template match="tei:figure">
        <xsl:variable name="doc_title">
            <xsl:text>Textgenese – Überlieferung</xsl:text>
        </xsl:variable>
        <html lang="{$site_language}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <style>
                    *, *::before, *::after { box-sizing: border-box; }

                    /* ── Vollbild-Layout ──────────────────────────────── */
                    body {
                        height: 100vh !important;
                        overflow: hidden !important;
                    }
                    .gv-wrapper {
                        display: flex;
                        flex-direction: column;
                        flex: 1 1 auto;
                        min-height: 0;
                        overflow: hidden;
                    }
                    .gv-row {
                        display: flex;
                        flex: 1 1 auto;
                        min-height: 0;
                        overflow: hidden;
                    }

                    /* ── SVG-Hauptbereich ─────────────────────────────── */
                    .gv-main {
                        flex: 1 1 auto;
                        display: flex;
                        flex-direction: column;
                        overflow: hidden;
                        min-height: 0;
                    }

                    .svg-wrap {
                        flex: 1 1 auto;
                        position: relative;
                        overflow: hidden;
                    }
                    .svg-wrap svg {
                        width: 100%;
                        height: 100%;
                        display: block;
                    }

                    /* ── Passagen-Detail in Sidebar ──────────────────── */
                    .nav-passage.open {
                        background: #eff6ff;
                        border-left-color: #2563eb;
                        color: #1e40af;
                        white-space: normal;
                    }
                    .pass-detail {
                        margin-top: 0.35rem;
                        padding-top: 0.35rem;
                        border-top: 1px solid #bfdbfe;
                    }
                    .pass-conn {
                        margin-top: 0.4rem;
                        padding: 0.3rem 0.4rem;
                        background: #f8fafc;
                        border-radius: 3px;
                        border: 1px solid #e2e8f0;
                    }
                    .pass-conn-heading { font-size: 0.65rem; color: #94a3b8; margin-bottom: 0.25rem; }
                    .pass-conn-incipit {
                        font-size: 0.72rem; font-weight: 600;
                        cursor: pointer; color: #1e40af;
                    }
                    .pass-conn-incipit:hover { text-decoration: underline; }
                    .pd-conn-meta { color: #64748b; font-size: 0.65rem; margin-top: 0.15rem; }
                    .pd-conn-meta a { color: #2563eb; }

                    /* ── Sidebar ──────────────────────────────────────── */
                    aside#sidebar-container {
                        flex-shrink: 0;
                        display: flex;
                        flex-direction: column;
                        transition: width 0.25s ease;
                        overflow: hidden;
                    }
                    aside#sidebar-container.collapsed { width: 0 !important; }
                    aside#sidebar-container.collapsed .sidebar { overflow: hidden; }

                    #sidebar-toggle {
                        position: absolute;
                        top: 6px;
                        left: -22px;
                        width: 22px;
                        height: 28px;
                        padding: 0;
                        background: #f1f5f9;
                        border: 1px solid #ddd;
                        border-right: none;
                        border-radius: 4px 0 0 4px;
                        cursor: pointer;
                        font-size: 0.7rem;
                        line-height: 1;
                        z-index: 10;
                    }
                    #sidebar-toggle:hover { background: #e2e8f0; }

                    .sidebar {
                        width: 100%;
                        flex: 1 1 auto;
                        min-height: 0;
                        border-left: 1px solid #ddd;
                        background: #fff;
                        overflow-y: auto;
                        padding: 0 0 1rem;
                    }
                    .sidebar-controls {
                        padding: 0.45rem 0.75rem;
                        border-bottom: 1px solid #e5e7eb;
                        background: #f9fafb;
                    }
                    .sidebar-controls label {
                        display: flex;
                        align-items: center;
                        gap: 0.35rem;
                        font-size: 0.72rem;
                        color: #6b7280;
                        cursor: pointer;
                        user-select: none;
                    }
                    .sidebar-controls input[type=checkbox] { cursor: pointer; }

                    /* Level 1: Achsen */
                    .nav-l1 { list-style: none; margin: 0; padding: 0; }
                    .nav-axis { border-bottom: 1px solid #e5e7eb; }
                    .nav-axis-label {
                        display: block;
                        padding: 0.45rem 0.75rem 0.3rem;
                        font-size: 0.72rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        color: #6b7280;
                        cursor: pointer;
                        user-select: none;
                    }
                    .nav-axis-label::before { content: '&#x25B6; '; font-size: 0.55rem; vertical-align: middle; }
                    .nav-axis.open > .nav-axis-label::before { content: '&#x25BC; '; }
                    .nav-axis-label:hover { color: #374151; }
                    .nav-axis.hovered > .nav-axis-label { color: #1e293b; background: #f1f5f9; }

                    /* Level 2: Dokumente */
                    .nav-l2 { display: none; list-style: none; margin: 0; padding: 0 0 0.25rem; }
                    .nav-axis.open > .nav-l2 { display: block; }
                    .nav-doc { cursor: pointer; user-select: none; }
                    .nav-doc-label {
                        display: block;
                        padding: 0.25rem 0.75rem 0.25rem 1.2rem;
                        font-size: 0.78rem;
                        color: #1e293b;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }
                    .nav-doc-label::before { content: '&#x25B6; '; font-size: 0.55rem; color: #9ca3af; vertical-align: middle; }
                    .nav-doc.open   > .nav-doc-label::before { content: '&#x25BC; '; }
                    .nav-doc:hover  > .nav-doc-label { background: #f1f5f9; }
                    .nav-doc.hovered > .nav-doc-label { background: #dbeafe; color: #1e40af; }

                    /* Level 3: Passagen */
                    .nav-l3 { display: none; list-style: none; margin: 0; padding: 0 0 0.2rem 1.5rem; }
                    .nav-doc.open > .nav-l3 { display: block; }
                    .nav-passage {
                        padding: 0.2rem 0.5rem;
                        font-size: 0.73rem;
                        color: #374151;
                        border-left: 2px solid #e2e8f0;
                        margin-bottom: 0.15rem;
                        cursor: pointer;
                    }
                    .nav-passage:hover { background: #f8fafc; }
                    .nav-passage.nav-hovered { background: #dbeafe; border-left-color: #3b82f6; color: #1e40af; }
                    .nav-passage .pass-incipit {
                        display: block;
                        white-space: normal;
                    }
                    .nav-passage .pass-meta { color: #9ca3af; font-size: 0.68rem; }
                    .nav-passage a { color: #2563eb; font-size: 0.68rem; }

                    /* ── Tooltip ─────────────────────────────────────── */
                    #svg-tooltip {
                        position: fixed;
                        display: none;
                        background: #1e293b;
                        color: #f8fafc;
                        font-size: 0.72rem;
                        padding: 0.3rem 0.55rem;
                        border-radius: 4px;
                        pointer-events: none;
                        max-width: 240px;
                        white-space: normal;
                        z-index: 200;
                        box-shadow: 0 2px 8px rgba(0,0,0,0.3);
                    }
                </style>
            </head>
            <body class="d-flex flex-column overflow-visible pe-0">
                <xsl:call-template name="nav_bar">
                    <xsl:with-param name="container" select="'container-fluid px-5'"/>
                    <xsl:with-param name="logo_small" select="true()"/>
                </xsl:call-template>

                <main class="wrapper gv-wrapper">
                    <div class="gv-row">

                        <!-- SVG-Hauptbereich -->
                        <div class="gv-main text-black-grey ls-1 w-75">
                            <div class="svg-wrap">
                                <xsl:copy-of select="document(tei:graphic/@url)/svg:svg"/>
                            </div>
                        </div>

                        <!-- Sidebar -->
                        <aside class="w-25 border-start border-light-grey bg-primary bg-opacity-5 position-relative"
                               id="sidebar-container">
                            <button id="sidebar-toggle" title="Seitenleiste ein-/ausblenden">&#9664;</button>
                            <nav class="sidebar">
                                <div class="sidebar-controls">
                                    <label>
                                        <input type="checkbox" id="cb-chapters"/>
                                        Titelgliederung
                                    </label>
                                </div>
                                <ul class="nav-l1">
                                    <xsl:apply-templates select="tei:figDesc/tei:list[@type='axes']/tei:item"/>
                                </ul>
                            </nav>
                        </aside>

                    </div>
                    <xsl:call-template name="html_footer">
                        <xsl:with-param name="additional_clases" select="'z-1'"/>
                    </xsl:call-template>
                </main>

                <xsl:call-template name="scripts"/>

                <div id="svg-tooltip"></div>

                <script><![CDATA[
document.addEventListener('DOMContentLoaded', function () {

  /* ── Titelgliederung (anchor @type=title) ── */
  var chaptersG = document.getElementById('chapters');
  if (chaptersG) chaptersG.style.display = 'none';
  var cbChapters = document.getElementById('cb-chapters');
  if (cbChapters) {
    cbChapters.addEventListener('change', function () {
      if (chaptersG) chaptersG.style.display = this.checked ? '' : 'none';
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
  var autoOpenedAxes = [];
  var autoOpenedDocs = [];

  function scheduleReset() { resetTimer = setTimeout(doReset, 300); }
  function cancelReset()   { if (resetTimer) { clearTimeout(resetTimer); resetTimer = null; } }
  function doReset() {
    resetTimer = null; hoveredDoc = null; hoveredPassage = null;
    render();
    document.querySelectorAll('.nav-axis.hovered').forEach(function(el) { el.classList.remove('hovered'); });
    document.querySelectorAll('.nav-doc.hovered').forEach(function(el)  { el.classList.remove('hovered'); });
    var keepDocs = [], keepAxes = [];
    autoOpenedDocs.forEach(function(el) {
      if (el.querySelector('.nav-passage.open')) keepDocs.push(el);
      else el.classList.remove('open');
    });
    autoOpenedAxes.forEach(function(el) {
      if (el.querySelector('.nav-passage.open')) keepAxes.push(el);
      else el.classList.remove('open');
    });
    autoOpenedDocs = keepDocs; autoOpenedAxes = keepAxes;
    clearNavPassageHighlight();
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

  /* ── Dokument-Hover ───────────────────────────────────────────────────*/
  function enterDoc(docName) {
    cancelReset();
    hoveredDoc = docName;
    render();
    var navDoc = document.querySelector('.nav-doc[data-doc="'+docName+'"]');
    if (navDoc && !navDoc.classList.contains('hovered')) {
      navDoc.classList.add('hovered');
      if (!navDoc.classList.contains('open')) { navDoc.classList.add('open'); autoOpenedDocs.push(navDoc); }
      var navAxis = navDoc.closest('.nav-axis');
      if (navAxis && !navAxis.classList.contains('open')) { navAxis.classList.add('open'); autoOpenedAxes.push(navAxis); }
    }
  }

  /* ── Nav-Passage-Highlighting ─────────────────────────────────────────*/
  function highlightNavPassage(doc, id) {
    var nd = document.querySelector('.nav-doc[data-doc="'+doc+'"]');
    if (!nd) return;
    var np = nd.querySelector('.nav-passage[data-id="'+id+'"]');
    if (np) { np.classList.add('nav-hovered'); scrollNavIntoView(np); }
  }
  function clearNavPassageHighlight() {
    document.querySelectorAll('.nav-passage.nav-hovered').forEach(function(el) { el.classList.remove('nav-hovered'); });
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
    clearNavPassageHighlight();
    autoOpenedDocs.forEach(function(el) { el.classList.remove('open'); });
    autoOpenedAxes.forEach(function(el) { el.classList.remove('open'); });
    autoOpenedDocs = []; autoOpenedAxes = [];
  }

  /* ── Event-Listener ───────────────────────────────────────────────────*/

  var visSvg = document.getElementById('vis-svg') || document.querySelector('svg');
  if (visSvg) visSvg.addEventListener('click', clearAll);

  document.querySelectorAll('.axis-bg').forEach(function(bg) {
    var idx = bg.dataset.axisIdx;
    bg.addEventListener('mouseenter', function() {
      var el = document.querySelector('.nav-axis[data-idx="'+idx+'"]');
      if (el) el.classList.add('hovered');
    });
    bg.addEventListener('mouseleave', function() {
      document.querySelectorAll('.nav-axis.hovered').forEach(function(el) { el.classList.remove('hovered'); });
    });
  });

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
      if (pinnedCount === 0) highlightNavPassage(p.dataset.doc, p.dataset.id);
    });
    p.addEventListener('mouseleave', function() {
      if (pinnedCount === 0) clearNavPassageHighlight();
      scheduleReset();
    });
    p.addEventListener('click', function(e) {
      e.stopPropagation();
      var doc = p.dataset.doc;
      var id  = p.dataset.id;
      var key = doc + '|||' + id;
      if (pinned[key]) {
        delete pinned[key]; pinnedCount--;
        render();
        if (pinnedCount === 0) clearNavPassageSelection();
        var np = document.querySelector('.nav-passage[data-id="' + id + '"]');
        if (np && np.classList.contains('open')) {
          np.classList.remove('open');
          var det = np.querySelector('.pass-detail');
          if (det) det.style.display = 'none';
        }
      } else {
        pinned[key] = {doc: doc, id: id}; pinnedCount++;
        render();
        var np = document.querySelector('.nav-passage[data-id="' + id + '"]');
        if (np) {
          var nd = np.closest('.nav-doc');
          var na = np.closest('.nav-axis');
          if (na && !na.classList.contains('open')) na.classList.add('open');
          if (nd && !nd.classList.contains('open')) nd.classList.add('open');
          if (!np.classList.contains('open')) {
            np.classList.add('open');
            var det = np.querySelector('.pass-detail');
            if (det) det.style.display = 'block';
          }
          scrollNavIntoView(np);
        }
      }
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
        tooltip.textContent = '&#x201E;' + inc + '&#x201C;';
        tooltip.style.display = 'block';
        positionTooltip(e);
      });
      p.addEventListener('mousemove', positionTooltip);
      p.addEventListener('mouseleave', function() { tooltip.style.display = 'none'; });
    });
  }

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

  /* ── Sidebar-Toggle ───────────────────────────────────────────────────*/
  var sidebarContainer = document.getElementById('sidebar-container');
  var sidebarToggle    = document.getElementById('sidebar-toggle');
  if (sidebarContainer && sidebarToggle) {
    sidebarToggle.addEventListener('click', function() {
      var collapsed = sidebarContainer.classList.toggle('collapsed');
      sidebarToggle.textContent = collapsed ? '►' : '◄';
    });
  }

});
                ]]></script>
            </body>
        </html>
    </xsl:template>


    <!-- ===================================================================
         Nav Level 1: Achse
         =================================================================== -->
    <xsl:template match="tei:list[@type='axes']/tei:item">
        <li class="nav-axis" data-idx="{count(preceding-sibling::tei:item)}">
            <span class="nav-axis-label"><xsl:value-of select="tei:label"/></span>
            <ul class="nav-l2">
                <xsl:apply-templates select="tei:list[@type='documents']/tei:item"/>
            </ul>
        </li>
    </xsl:template>


    <!-- ===================================================================
         Nav Level 2: Dokument
         =================================================================== -->
    <xsl:template match="tei:list[@type='documents']/tei:item">
        <li class="nav-doc" data-doc="{tei:label}">
            <span class="nav-doc-label"><xsl:value-of select="tei:label"/></span>
            <xsl:if test="tei:list[@type='passages']/tei:item">
                <ul class="nav-l3">
                    <xsl:apply-templates select="tei:list[@type='passages']/tei:item"/>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>


    <!-- ===================================================================
         Nav Level 3: Passage
         =================================================================== -->
    <xsl:template match="tei:list[@type='passages']/tei:item">
        <li class="nav-passage" data-id="{@xml:id}">
            <span class="pass-incipit">&#8222;<xsl:value-of select="tei:label"/>&#8220;</span>
            <xsl:if test="tei:ref[@type='page'] or tei:ref[@type='url']">
                <span class="pass-meta">
                    <xsl:if test="tei:ref[@type='page']">
                        <xsl:text>S.&#160;</xsl:text>
                        <xsl:value-of select="tei:ref[@type='page']"/>
                    </xsl:if>
                    <xsl:if test="tei:ref[@type='url']">
                        <xsl:if test="tei:ref[@type='page']"><xsl:text> · </xsl:text></xsl:if>
                        <a href="{tei:ref[@type='url']/@target}" target="_blank">Link</a>
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


    <!-- ===================================================================
         Verbundene Passage (otherDoc-ref)
         =================================================================== -->
    <xsl:template match="tei:ref[@type='otherDoc']">
        <div class="pass-conn">
            <div class="pass-conn-heading">
                <xsl:choose>
                    <xsl:when test="@subtype='later'">Auf späterem Textträger:</xsl:when>
                    <xsl:otherwise>Auf früherem Textträger:</xsl:otherwise>
                </xsl:choose>
            </div>
            <div class="pass-conn-incipit" data-target="{@target}">&#8222;<xsl:value-of select="tei:label"/>&#8220;</div>
            <div class="pd-conn-meta">
                <xsl:value-of select="tei:ref[@type='doc']"/>
                <xsl:if test="tei:ref[@type='page']">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="tei:ref[@type='page']"/>
                </xsl:if>
                <xsl:if test="tei:ref[@type='url']">
                    <xsl:text> </xsl:text>
                    <a href="{tei:ref[@type='url']/@target}" target="_blank">Link</a>
                </xsl:if>
            </div>
        </div>
    </xsl:template>


    <!-- Nicht zugeordnete tei:item-Elemente ignorieren -->
    <xsl:template match="tei:item"/>

</xsl:stylesheet>
