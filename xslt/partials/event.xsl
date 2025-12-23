<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" 
    version="2.0" exclude-result-prefixes="xsl tei xs wpn">
    <xsl:import href="./wpn_utils.xsl"/>
    <xsl:template match="tei:event" mode="detail_view">
      <!--<xsl:result-document href="{@xml:id||'.html'}" method="html">-->
        <div class="d-none p-1 ps-0 pt-0 overflow-visible ls-2" id="{'details_'||@xml:id}">   
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
                           <xsl:apply-templates select=".">
                                <xsl:with-param name="elem_id" select="@xml:id"/>
                                <xsl:with-param name="render_categories" select="true()"/>
                            </xsl:apply-templates>
                        </div>
                         <xsl:apply-templates select="tei:desc[descendant::tei:ref[@type='source']]" mode="list_sources">
                            <xsl:with-param name="elem_id" select="@xml:id"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="tei:desc[descendant::tei:ref[@type='int']]" mode="list_intertexts">
                            <xsl:with-param name="elem_id" select="@xml:id"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="tei:desc" mode="list_comments">
                            <xsl:with-param name="elem_id" select="@xml:id"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="." mode="link_list">
                            <xsl:with-param name="elem_id" select="@xml:id"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="." mode="kwic"/>
                    </div>
                </div>
            </div>
        </div>
<!--</xsl:result-document>-->
    </xsl:template>
           <xsl:template match="tei:event" mode="detail_view_textpage">
        <xsl:param name="id" />
        <xsl:param name="id_in_text" />
        <xsl:variable name="elem_id" select="'details_'||$id_in_text||'_'||(if ($id) then $id else @xml:id)"/>
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
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="elem_id" select="$elem_id"/>
                            </xsl:apply-templates>
                        </div>
                        <div class="py-1 border-bottom border-light-grey">
                            <span>Zeitleiste</span>
                            <a class="text-decoration-none text-dark-grey ps-2"
                            href="{'ereignisse.html#'||@xml:id}" target="_blank">
                            <xsl:apply-templates select="." mode="short" />
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates select="." mode="detail_view_textpage_event_date">
                                <xsl:with-param name="fs" select="fs-6"/>
                            </xsl:apply-templates>
                            <svg class="ms-2 align-baseline" width="5" height="10"
                                xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                                <defs>
                                <style>
                                    .b{fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;}</style>
                                </defs>
                                <path class="b" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path>
                            </svg>
                            </a>
                        </div>
                        <xsl:apply-templates select="tei:desc[descendant::tei:ref[@type='source']]" mode="list_sources">
                            <xsl:with-param name="elem_id" select="$elem_id"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="tei:desc[descendant::tei:ref[@type='int']]" mode="list_intertexts">
                            <xsl:with-param name="elem_id" select="$elem_id"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="tei:desc" mode="list_comments">
                            <xsl:with-param name="elem_id" select="$elem_id"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="." mode="link_list">
                            <xsl:with-param name="elem_id" select="$elem_id"/>
                        </xsl:apply-templates>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:event" mode="kwic">
    <div>
         <details class="pb-1 mt-1 border-bottom border-light-grey">
            <summary class="d-flex align-items-baseline">Zum Text</summary>
            <div id="{'kwics_'||@xml:id}" class="ff-crimson-text">
                <xsl:for-each select="descendant::tei:ref[@type=('event','comment')][not(ancestor::tei:desc)]">
                    <xsl:variable name="kwic_hit" select="collection('../../data/merged?select=*.html')//span[@id=current()/@xml:id]"/>
                    <xsl:variable name="prev_text" select="string($kwic_hit/string-join(preceding::text()))"/>
                    <xsl:variable name="following_text" select="string($kwic_hit/string-join(following::text()))"/>
                    <xsl:variable name="kwic_left" select="substring($prev_text, string-length($prev_text) - 78)"/>
                    <xsl:variable name="kwic_right" select="substring($following_text, 1, 78)"/>
                    <div class="text-kwic-grey d-flex justify-content-between gap-4">
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
                            <a href="{$kwic_hit/ancestor::body/@data-teiid||'.html?cmts=on#'||current()/@xml:id}" class="text-decoration-none link-dark-grey stretched-link ff-ubuntu m-0 p-08">
                                <xsl:value-of select="$kwic_hit/ancestor::body/@data-label"/>
                            </a>
                        </div>
                    </div>
                </xsl:for-each>
            </div>
        </details>
    </div>
    </xsl:template>
    <xsl:template match="tei:seg" mode="list_view">
    <div  id="{@xml:id}" class="lh-1625">
         <a class="text-blacker-grey text-decoration-none fs-9" href="{'#'||@xml:id}">
                <b><xsl:apply-templates select="." mode="short"/></b>
         </a>
    </div>
    </xsl:template>
    <xsl:template match="tei:event" mode="short">
        <xsl:apply-templates select="tei:label" mode="short"/>
    </xsl:template>
    <xsl:template match="tei:label" mode="short">
        <span><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:event">
        <xsl:param name="elem_id"/>
        <xsl:param name="render_categories" select="false()"/>
         <p class="text-black-grey mb-0">
            <xsl:apply-templates select="tei:label" mode="detail_view_textpage_event">
                <xsl:with-param name="elem_id" select="$elem_id"/>
            </xsl:apply-templates>
        </p>
        <div>
            <xsl:apply-templates select="." mode="detail_view_textpage_event_date">
                <xsl:with-param name="render_categories" select="$render_categories"/>
                <xsl:with-param name="fs" select="fs-7"/>
            </xsl:apply-templates>
        </div>
        <xsl:apply-templates select="tei:desc">
            <xsl:with-param name="elem_id" select="$elem_id"/>
        </xsl:apply-templates>
        <xsl:if test="tei:ref[@type='ext']">
            <div>
                <details class="py-1 border-bottom border-light-grey">
                    <summary class="d-flex align-items-baseline">Links</summary>
                        <xsl:for-each select="tei:ref[@type='ext']">
                            <xsl:apply-templates select="current()"/>
                        </xsl:for-each>
                </details>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:label" mode="detail_view_textpage_event">
        <xsl:param name="elem_id"/>
        <span class="fs-9"><b data-testid="comment_label_{$elem_id}">Ereignis: <xsl:apply-templates mode="label"/></b></span>
    </xsl:template>
    <!--<xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>-->
    <xsl:template match="tei:title[ancestor::tei:desc]">
        <i><xsl:value-of select="."/></i>
    </xsl:template>
    <xsl:template match="tei:desc">
        <xsl:param name="elem_id"/>
        <p data-testid="description_long_{$elem_id}" class="text-justify fs-8_5 lh-0_86 my-1 text-dark-grey"><xsl:apply-templates select="*[not(self::tei:ref[@type=('ext','int')])]|text()"/></p>
    </xsl:template>
    <xsl:template match="tei:event" mode="detail_view_textpage_event_date">
        <xsl:param name="render_categories" select="false()"/>
        <div class="fs-7 text-dark-grey {if (not($render_categories)) then 'd-inline' else ()}">
            <span><xsl:text>(</xsl:text></span>
            <xsl:choose>
                <xsl:when test="@when">
                    <span data-testid="event_date_{@xml:id}"><xsl:value-of select="wpn:date_full('[D]. [M]. [Y]', @when)"/></span>
                </xsl:when>
                <xsl:otherwise>
                    <span data-testid="event_date_{@xml:id}"><xsl:value-of select="wpn:date_full('[D]. [M]. [Y]', @notBefore)"/><xsl:text> – </xsl:text><xsl:value-of select="wpn:date_full('[D]. [M]. [Y]', @notAfter)"/></span>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$render_categories">
                <span><xsl:text>, </xsl:text></span>
                <xsl:call-template name="category_list"/>
            </xsl:if>
            <span><xsl:text>)</xsl:text></span>
        </div>
    </xsl:template>
    <xsl:template match="tei:ref[@type='source']">
    <xsl:variable name="sources">
        <p>
            <xsl:for-each select="tokenize(@target,' ')">
                <xsl:variable name="target_id" select="replace(current(),'#','')"/>
                <xsl:apply-templates select="doc('../../data/indices/SekLit_Kommentar.xml')//(tei:citedRange|tei:bibl)[@xml:id=$target_id]" mode="popover_content"/>
                <xsl:if test="not(position()=last())"><br/></xsl:if>
            </xsl:for-each>
        </p>
    </xsl:variable>
     <span data-bs-toggle="popover" data-bs-content="{serialize($sources, map {'output':'default'})}"  data-bs-html="true" data-highlight="{replace(replace(@target,' ',','),'#','')}"  data-bs-placement="left" data-bs-trigger="hover" data-bs-custom-class="ff-ubuntu">

        <svg width="14" height="14" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 25"><g fill="none" stroke="#d8d8d8" stroke-width="1"><circle cx="12.5" cy="12.5" r="12.5" stroke="none"></circle><circle cx="12.5" cy="12.5" r="12" fill="none"></circle></g><g transform="translate(8.229 8.025)"><path d="M4253.114,129.086v-5.543h3.88" transform="translate(-4253.114 -123.543)" fill="none" stroke="#999" stroke-linejoin="round" stroke-width="1"></path><g transform="translate(2.5 4.5)"><line x2="6.041" fill="none" stroke="#999" stroke-width="1"></line><line x2="6.041" transform="translate(0 2.225)" fill="none" stroke="#999" stroke-width="1"></line><line x2="6.041" transform="translate(0 4.45)" fill="none" stroke="#999" stroke-width="1"></line></g></g></svg>
    </span>
    </xsl:template>
    <xsl:template match="tei:citedRange" mode="popover_content">
        <xsl:value-of select="preceding-sibling::tei:bibl[@type='short']"/><xsl:value-of select="', '||.||'.'"/>
    </xsl:template>
    <xsl:template match="tei:desc" mode="list_sources">
        <xsl:param name="elem_id"/>
        <xsl:call-template name="list_bibliographic_data">
            <xsl:with-param name="elem_id" select="$elem_id"/>
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="type" select="'source'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="tei:desc" mode="list_intertexts">
        <xsl:param name="elem_id"/>
        <xsl:call-template name="list_bibliographic_data">
            <xsl:with-param name="elem_id" select="$elem_id"/>
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="type" select="'int'"/>
        </xsl:call-template>
    </xsl:template>
     <xsl:template match="tei:desc" mode="list_comments">
        <xsl:param name="elem_id"/>
        <xsl:if test="descendant::tei:ref[@type='event']">
            <div>
                <details class="py-1 border-bottom border-light-grey">
                    <summary class="d-flex align-items-baseline">Weitere Ereignisse</summary>
                    <ul class="list-unstyled mb-0" data-testid="event_links_{$elem_id}">
                        <xsl:for-each select="tei:ref[@type='event']">
                            <li><xsl:apply-templates select="current()" mode="detail_view_textpage_event"/></li>
                        </xsl:for-each>
                    </ul>
                </details>
            </div>
        </xsl:if>
        <xsl:if test="descendant::tei:ref[@type='comment']">
            <div>
                <details class="py-1 border-bottom border-light-grey">
                    <summary class="d-flex align-items-baseline">Kommentar</summary>
                    <ul class="list-unstyled mb-0" data-testid="comment_links_{$elem_id}">
                        <xsl:for-each select="tei:ref[@type='comment']">
                            <li><xsl:apply-templates select="current()" mode="detail_view_textpage_event"/></li>
                        </xsl:for-each>
                    </ul>
                </details>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:citedRange" mode="list_intertexts">
        <p class="my-05 lh-0_86">
            <span data-bibl-id="{ancestor::tei:bibl/@xml:id}">
                <xsl:apply-templates select="ancestor::tei:bibl"/>
            </span>
            <xsl:text>, </xsl:text>
            <span data-cited-range="{@xml:id}">
                <xsl:apply-templates select="."/>
            </span>
        </p>
    </xsl:template>
    <xsl:template match="tei:ref[@type='comment']" mode="detail_view_textpage_event">
        <xsl:variable name="ref_id" select="replace(@target,'#','')"/>
        <xsl:variable name="ref_node" select="doc('../../data/indices/Kommentar.xml')//tei:seg[@xml:id = $ref_id]"/>
        <xsl:variable name="ref_node_topic_id" select="replace(tokenize($ref_node/@corresp,' ')[1],'#','')"/>
        <a class="d-block text-decoration-none text-dark-grey text-blacker-grey-hover" href="{'register_kommentare.html#'||$ref_node_topic_id||'_'||replace(@target,'#','')}" target="_blank">
            <xsl:apply-templates select="$ref_node/tei:label" mode="comment"/>
            <svg class="ms-2 align-baseline" width="5" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                <path style="fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path>
            </svg>
        </a>
    </xsl:template>
    <xsl:template match="tei:ref[@type='event']" mode="detail_view_textpage_event">
        <xsl:variable name="ref_id" select="replace(@target,'#','')"/>
        <xsl:variable name="ref_node" select="doc('../../data/indices/Events.xml')//tei:event[@xml:id = $ref_id]"/>
        <xsl:variable name="ref_node_topic_id" select="replace(tokenize($ref_node/@corresp,' ')[1],'#','')"/>
        <a class="d-block text-decoration-none text-dark-grey text-blacker-grey-hover" href="{'ereignisse.html#'||replace(@target,'#','')}" target="_blank">
            <xsl:apply-templates select="$ref_node/tei:label" mode="comment"/>
            <svg class="ms-2 align-baseline" width="5" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                <path style="fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path>
            </svg>
        </a>
    </xsl:template>
    <xsl:template match="tei:title" mode="label">
        <i><xsl:apply-templates/></i>
    </xsl:template>
</xsl:stylesheet>