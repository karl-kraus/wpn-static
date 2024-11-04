<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" 
    version="2.0" exclude-result-prefixes="xsl tei xs wpn">
    
    <xsl:template match="tei:seg" mode="detail_view">
      <!--<xsl:result-document href="{@xml:id||'.html'}" method="html">-->
      <xsl:param name="topic_id"/>
      <xsl:variable name="elem_id" select="'details_'||$topic_id||'_'||@xml:id"/>
        
        <div class="d-none p-1 ps-0 pt-0 overflow-visible ls-2" id="{$elem_id}">   
            <div class="comment_signet_background my-0 mw-100 top-18 px-2 ps-3 pt-2 bg-position-detail-view bg-size-detail-view bg-no-repeat">
                <div class="border-0 d-flex flex-column">
                    <div class="d-flex justify-content-between">
                        <h2 class="fs-8_75 text-black-grey fw-normal">Registereintrag</h2>
                        <button class="border-0 bg-transparent close-button">
                            <svg class="align-top" width="10" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 7.778 7.778"><defs><style>.a{fill:none;stroke:#d8d8d8;stroke-width:2px;}</style></defs><g transform="translate(0.707 0.707)"><line class="a" x2="9" transform="translate(0 0) rotate(45)"></line><line class="a" x2="9" transform="translate(0 6.364) rotate(-45)"></line></g></svg>
                        </button>
                    </div>
                    <div class="fs-6 text-dark-grey p-0">
                        <div>
                            <xsl:apply-templates select="."  mode="detail_view_textpage_seg">
                                <xsl:with-param name="register_view" select="true()"/>
                                <xsl:with-param name="elem_id" select="$elem_id"/>
                            </xsl:apply-templates>
                        </div>
                        <xsl:apply-templates select="tei:note" mode="list_sources"/>
                        <xsl:apply-templates select="." mode="list_events"/>
                        <xsl:apply-templates select="." mode="link_list">
                            <xsl:with-param name="elem_id" select="$elem_id"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="." mode="kwic"/>
                    </div>
                </div>
            </div>
        </div>
<!--</xsl:result-document>-->
    </xsl:template>
    <!-- template needed for detail view in edition view -->
    <xsl:template match="tei:seg" mode="detail_view_textpage">
        <xsl:param name="id" select="@xml:id"/>
        <xsl:param name="id_in_text" />
        <xsl:variable name="elem_id" select="'details_'||$id_in_text||'_'||$id"/>
        <xsl:variable name="topic_for_reglink" select="replace(tokenize(@corresp,' ')[1],'#','')"/>
        <xsl:variable name="ancestor_seg_id" select="doc('../../data/indices/Kommentar.xml')//tei:seg[@xml:id = $id]/ancestor::tei:seg/@xml:id"/>
        <div class="d-none p-1 ps-0 pt-0 overflow-visible ls-2"
            id="{$elem_id}">
            <div class="comment_signet_background my-0 mw-100 top-18 px-2 ps-2 pt-1 bg-position-detail-view bg-size-detail-view bg-no-repeat">
                <div class="border-0 flex flex-column">
                    <button class="float-end border-0 bg-transparent close-button">
                    <svg class="align-top" width="10" height="10" xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 7.778 7.778">
                        <defs>
                        <style>.a{fill:none;stroke:#d8d8d8;stroke-width:2px;}</style>
                        </defs>
                        <g transform="translate(0.707 0.707)">
                        <line class="a" x2="9" transform="translate(0 0) rotate(45)"></line>
                        <line class="a" x2="9" transform="translate(0 6.364) rotate(-45)"></line>
                        </g>
                    </svg>
                    </button>
                    <div class="fs-6 text-dark-grey p-0 pt-1">
                        <div class="mb-1">
                            <xsl:apply-templates select="." mode="detail_view_textpage_seg">
                                <xsl:with-param name="elem_id" select="$elem_id"/>
                            </xsl:apply-templates>
                        </div>
                        <div class="py-1 border-bottom border-light-grey">
                            <a data-testid="register_link_{$elem_id}" class="text-decoration-none text-dark-grey"
                            href="{'register_kommentare.html#'||$topic_for_reglink||'_'||(if ($ancestor_seg_id) then $ancestor_seg_id else @xml:id)}" target="_blank">
                            <span>Register</span>
                            <span class="ps-2"><xsl:apply-templates select="." mode="short" />
                            <svg class="ms-2 align-baseline" width="5" height="10"
                                xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                                <path style="fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path>
                            </svg>
                            </span>
                            </a>
                        </div>
                        <xsl:apply-templates select="tei:note" mode="list_sources"/>
                        <xsl:apply-templates select="." mode="list_events"/>
                        <xsl:apply-templates select="." mode="link_list">
                            <xsl:with-param name="elem_id" select="$elem_id"/>
                        </xsl:apply-templates>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:seg" mode="kwic">
    <div>
         <details class="pb-1 mt-1 border-bottom border-light-grey">
            <summary class="d-flex align-items-baseline">Zum Text</summary>
            <div id="{'kwics_'||@xml:id}" class="ff-century-old-style">
                <xsl:for-each select="descendant::tei:ref[@type='comment']">
                    <xsl:variable name="kwic_hit" select="collection('../../data/merged?select=*.html')//span[@id=current()/@xml:id]"/>
                    <xsl:variable name="prev_text" select="string($kwic_hit/string-join(preceding::text()))"/>
                    <xsl:variable name="following_text" select="string($kwic_hit/string-join(following::text()))"/>
                    <xsl:variable name="kwic_left" select="substring($prev_text, string-length($prev_text) - 78)"/>
                    <xsl:variable name="kwic_right" select="substring($following_text, 1, 78)"/>
                    <div class="text-kwic-grey d-flex justify-content-between">
                        <div class="kwic-wrapper">
                            <xsl:if test="string-length($kwic_left) > 0">
                                <span><xsl:copy-of select="'...'||$kwic_left"/></span>
                            </xsl:if>
                            <span><xsl:copy-of select="$kwic_hit"/></span>
                            <xsl:if test="string-length($kwic_right) > 0">
                                <span><xsl:copy-of select="$kwic_right||'...'"/></span>
                            </xsl:if>
                        </div>
                        <div>
                            <p class="ff-ubuntu text-light-grey">
                                <xsl:value-of select="$kwic_hit/ancestor::body/@data-label"/>
                            </p>
                        </div>
                    </div>
                </xsl:for-each>
            </div>
        </details>
    </div>
    </xsl:template>
    <xsl:template match="tei:seg" mode="list_view">
        <xsl:param name="topic_id"/>
    <li id="{$topic_id||'_'||@xml:id}" class="lh-1625 list-unstyled mb-0">
         <a class="text-blacker-grey text-decoration-none fs-9" href="#{$topic_id||'_'||@xml:id}">
                <b><xsl:apply-templates select="." mode="short"/></b>
         </a>
        <xsl:if test="descendant::tei:seg">
            <ul class="list-unstyled fs-9 inline-list-dash-separated ms-2">
                <li><xsl:apply-templates select="." mode="short"/></li>
                <xsl:for-each select="descendant::tei:seg">
                    <li><xsl:apply-templates select="current()" mode="short"/></li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </li>
    </xsl:template>
    <xsl:template match="tei:seg" mode="short">
        <xsl:apply-templates select="tei:label" mode="short"/>
    </xsl:template>
    <xsl:template match="tei:label" mode="short">
        <span><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg" mode="detail_view_textpage_seg">
        <xsl:param name="register_view" select="false()"/>
        <xsl:param name="elem_id"/>
        <p class="text-black-grey lh-0_9">
            <xsl:apply-templates select="tei:label">
                <xsl:with-param name="elem_id" select="$elem_id"/>
            </xsl:apply-templates>
            <br/>
            <xsl:if test="not($register_view)">
                <xsl:apply-templates select="@corresp" mode="detail_view_textpage_seg"/>
            </xsl:if>
        </p>
        <div data-testid="description_long_{$elem_id}">
            <xsl:apply-templates select="tei:note" mode="detail_view_textpage_seg"/>
        </div>
    </xsl:template>
    <xsl:template match="tei:label">
        <xsl:param name="elem_id"/>
       <span class="fs-9"><b data-testid="comment_label_{$elem_id}"><xsl:apply-templates/></b></span>
    </xsl:template>
    <!--<xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>-->
    <xsl:template match="tei:title[ancestor::tei:seg]">
        <i><xsl:value-of select="."/></i>
    </xsl:template>
    <xsl:template match="tei:note[descendant::tei:seg]" mode="detail_view_textpage_seg">
        <xsl:variable name="grouped_notes">
            <xsl:for-each-group select="descendant::node()[normalize-space() or self::tei:ref][not(parent::tei:title)][not(ancestor-or-self::tei:ref[@type=('DW','ext')])][not(ancestor-or-self::tei:label)][not(ancestor-or-self::comment())]" group-adjacent="count(preceding::*:label) + count(ancestor::*:note)">
                <tei:note>
                    <xsl:copy-of select="current-group()"/>
                </tei:note>
            </xsl:for-each-group>     
        </xsl:variable>
        <xsl:for-each select="$grouped_notes/tei:note[not(tei:note)][text()[normalize-space()]]">
            <p class="text-justify fs-8_5 lh-0_86 my-1 text-black-grey">
                <xsl:apply-templates select="(current()/node() except (tei:seg,tei:note))"  mode="comment_note"/>
            </p>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:note[not(descendant::tei:seg)]" mode="detail_view_textpage_seg">
        <p class="text-justify fs-8_5 lh-0_86 my-1 text-black-grey">
            <xsl:apply-templates select="(current()/node() except (tei:seg,tei:note))"  mode="comment_note"/>
        </p>
    </xsl:template>
    <xsl:template match="tei:label|tei:ref[@type='DW']" mode="comment_note"/>
  
    <xsl:template match="tei:ref[@type='source']" mode="comment_note">
    <xsl:variable name="sources">
        <p>
            <xsl:for-each select="tokenize(@target,' ')">
            <xsl:variable name="target_id" select="replace(current(),'#','')"/>
                <xsl:apply-templates select="doc('../../data/indices/SekLit_Kommentar.xml')//(tei:citedRange|tei:bibl)[@xml:id=$target_id]" mode="popover_content"/>
                <xsl:if test="not(position()=last())"><br/></xsl:if>
            </xsl:for-each>
        </p>
    </xsl:variable>
     <span data-bs-toggle="popover" data-highlight="{replace(replace(@target,' ',','),'#','')}" data-bs-content="{serialize($sources, map {'output':'default'})}"  data-bs-html="true"  data-bs-placement="left" data-bs-trigger="hover" data-bs-custom-class="ff-ubuntu">
        <svg width="14" height="14" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 25"><g fill="none" stroke="#d8d8d8" stroke-width="1"><circle cx="12.5" cy="12.5" r="12.5" stroke="none"></circle><circle cx="12.5" cy="12.5" r="12" fill="none"></circle></g><g transform="translate(8.229 8.025)"><path d="M4253.114,129.086v-5.543h3.88" transform="translate(-4253.114 -123.543)" fill="none" stroke="#999" stroke-linejoin="round" stroke-width="1"></path><g transform="translate(2.5 4.5)"><line x2="6.041" fill="none" stroke="#999" stroke-width="1"></line><line x2="6.041" transform="translate(0 2.225)" fill="none" stroke="#999" stroke-width="1"></line><line x2="6.041" transform="translate(0 4.45)" fill="none" stroke="#999" stroke-width="1"></line></g></g></svg>
    </span>
    </xsl:template>
    <xsl:template match="tei:citedRange" mode="popover_content">
        <xsl:value-of select="preceding-sibling::tei:bibl[@type='short']"/><xsl:value-of select="', '||.||'.'"/>
    </xsl:template>
    <xsl:template match="tei:note" mode="list_sources">
        <xsl:if test="descendant::tei:ref[@type='source']">
            <div>
                <details class="py-1 border-bottom border-light-grey">
                    <summary class="d-flex align-items-baseline summary-sources"><span>Quellen</span></summary>
                    <xsl:for-each select="tei:ref[@type='source']/tokenize(@target,' ')">
                        <xsl:sort select="doc('../../data/indices/SekLit_Kommentar.xml')//(tei:citedRange|tei:bibl)[@xml:id=replace(current(),'#','')]/ancestor-or-self::tei:bibl/@sortKey"/>
                        <xsl:variable name="target_id" select="replace(current(),'#','')"/>
                        <xsl:apply-templates select="doc('../../data/indices/SekLit_Kommentar.xml')//(tei:citedRange|tei:bibl)[@xml:id=$target_id]" mode="list_sources"/>
                    </xsl:for-each>
                </details>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:seg" mode="list_events">
        <xsl:if test="tei:ref[@type='event']">
            <div>
                <details class="py-1 border-bottom border-light-grey">
                    <summary class="d-flex align-items-baseline">Ereignisse</summary>
                        <xsl:for-each select="tei:ref[@type='event']">
                            <xsl:apply-templates select="current()" mode="detail_view_textpage_seg"/>
                        </xsl:for-each>
                </details>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:citedRange" mode="list_sources">
        <p class="my-05 lh-0_86">
            <span data-bibl-id="{ancestor::tei:bibl/@xml:id}">
                <xsl:apply-templates select="ancestor::tei:bibl/(text()|tei:ref)" mode="list_sources"/>
            </span>
            <xsl:text>, </xsl:text>
            <span data-cited-range="{@xml:id}">
                <xsl:apply-templates select="./(text()|tei:ref)" mode="list_sources"/>
            </span>
        </p>
    </xsl:template>
     <xsl:template match="tei:ref[@type='event']" mode="detail_view_textpage_seg">
        <xsl:variable name="ref_id" select="replace(@target,'#','')"/>
        <a class="d-block text-decoration-none text-dark-grey text-blacker-grey-hover" href="ereignisse.html{@target}" target="_blank">
            <xsl:apply-templates select="doc('../../data/indices/Events.xml')//tei:event[@xml:id = $ref_id]/tei:label" mode="comment"/>
            <svg class="ms-2 align-baseline" width="5" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                <defs>
                    <style>.b{fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;}</style>
                </defs>
                <path class="b" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path>
            </svg>
        </a>
    </xsl:template>
    <xsl:template match="tei:seg[not(@type='F890')]" mode="short_info">
        <xsl:param name="ref_type"/>
            <span class="fw-bold">
                <xsl:value-of select="(if ($ref_type='comment') then 'Kommentar' else 'Glossar')||': '"/>
                <xsl:apply-templates select="tei:label" mode="comment"/>
            </span>
    </xsl:template>
    <xsl:template match="tei:event" mode="short_info">
    <span class="fw-bold"><xsl:text>Ereignis: </xsl:text><xsl:apply-templates select="tei:label" mode="comment"/></span>
    </xsl:template>
    <xsl:template match="tei:label" mode="comment">
    <xsl:apply-templates mode="comment"/>
    </xsl:template>
    <xsl:template match="tei:title" mode="comment">
    <i><xsl:apply-templates mode="comment"/></i>
    </xsl:template>
    <xsl:template match="tei:title" mode="comment_note">
    <i><xsl:apply-templates mode="comment_note"/></i>
    </xsl:template>
    <xsl:template match="text()" mode="comment">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="text()" mode="comment_note">
        <!--<xsl:if test="preceding-sibling::node() and not(matches(.,'^(\.|,|-|:|\)|;)'))">
           <xsl:text> </xsl:text>
        </xsl:if>-->
        <xsl:value-of select="replace(.,'(\n[ \t]+)',' ')"/>
        <!--<xsl:if test="following-sibling::node()[self::tei:title] and not(matches(.,'(\(|-)$'))">
            <xsl:text> </xsl:text>
        </xsl:if>-->
    </xsl:template>
     <xsl:template match="@corresp" mode="detail_view_textpage_seg">
        <span class="fs-8_5">
            <b>
                <xsl:text>(Zum Thema: </xsl:text>
                <xsl:for-each select="tokenize(.,' ')">
                    <xsl:variable name="topicid" select="replace(current(),'#','')"/>
                    <a class="text-decoration-none link-black-grey" href="{'register_kommentare.html#'||$topicid}">
                        <xsl:value-of select="doc('../../data/indices/Kommentar.xml')//tei:desc[@xml:id=$topicid]"/>
                    </a>
                </xsl:for-each>
                <xsl:text>)</xsl:text>
            </b>
        </span>
    </xsl:template>
    <xsl:template match="comment()"  mode="comment_note"/>
</xsl:stylesheet>