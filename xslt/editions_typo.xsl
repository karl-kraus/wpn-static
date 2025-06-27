<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="3.0" exclude-result-prefixes="#all">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="no" omit-xml-declaration="yes"/>
    
    <xsl:preserve-space elements="*"/>
    <!-- <xsl:strip-space elements="tei:note"/> -->
    <!-- <xsl:preserve-space elements="tei:p tei:mod tei:seg"/> -->

    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/short-infos.xsl"/>
    <xsl:import href="./partials/typo-add.xsl"/>
    <xsl:import href="./partials/typo-del.xsl"/>
    <xsl:import href="./partials/typo-mod.xsl"/>
    <xsl:import href="./partials/typo-seg.xsl"/>
    <xsl:import href="./partials/typo-metamark.xsl"/>
    <xsl:import href="./partials/typo-info-3rd-column.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/scripts.xsl"/>

    <xsl:variable name="prev">
        <xsl:choose>
            <xsl:when test="contains(tei:TEI/@prev, 'idPb-000') or 
                            contains(tei:TEI/@prev, 'idPbF')">
                <!-- notWitness document, do not create a link -->
            </xsl:when>
            <xsl:when test="contains(tei:TEI/@prev, 'idPb0266_a')">
                <xsl:text>idPb0266.xml</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring-after(data(tei:TEI/@prev), 'https://id.acdh.oeaw.ac.at/')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:choose>
            <xsl:when test="contains(tei:TEI/@next, 'idPb-000') or 
                            contains(tei:TEI/@next, 'idPbF')">
                <!-- notWitness document, do not create a link -->
            </xsl:when>
            <xsl:when test="contains(tei:TEI/@next, 'idPb0266_a')">
                <xsl:text>idPb0267.xml</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring-after(data(tei:TEI/@next), 'https://id.acdh.oeaw.ac.at/')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
     <xsl:variable name="id">
        <xsl:value-of select="tei:TEI/@id"/>
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>
    <xsl:variable name="facsimile">
        <xsl:value-of select="//tei:facsimile/tei:surface[1]/tei:graphic[1]/@url"/>
    </xsl:variable>


    <xsl:template match="/">

    
        <html id="edition-view">
    
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            <body id="main_grid">
                <xsl:call-template name="nav_bar">
                    <xsl:with-param name="logo_small" select="true()"/>
                    <xsl:with-param name="container" select="'container-fluid mx-1 edition-header'"/>
                </xsl:call-template>
                <main class="flex-shrink-0 mt-18">
                    <div class="container-fluid px-0">
                        <div class="d-flex flex-column mb-4">
                            <div class="mx-auto">
                                <div class="p-0 d-flex flex-column align-items-center">
                                    <div class="dropdown ff-ubuntu">
                                        <xsl:variable name="currentPage" select="replace(replace(tokenize(base-uri(current()),'/')[last()], '.xml', ''), 'idPb', '')"/>
                                        <xsl:variable name="currentPageString" select="if(contains($currentPage, '_') ) 
                                                                                       then(xs:integer(replace( tokenize( $currentPage, '_' )[1], 'F', '' ) )||'/'||tokenize( $currentPage, '_' )[2] ) 
                                                                                       else(xs:integer(replace($currentPage, 'F', '')))"/>
                                        <xsl:if test="string-length($prev) > 0">
                                            <a href="{replace($prev, '.xml', '.html')}" title="zu seite {replace($prev, '.xml', '.html')} gehen">
                                                <svg width="24" height="24" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false"><g><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path></g></svg>
                                            </a>
                                        </xsl:if>
                                        <button class="btn btn-secondary dropdown-toggle fs-9_38 border-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                            <xsl:value-of select="'Seite: '||$currentPageString"/>
                                        </button>
                                        <ul class="dropdown-menu z-3 rounded-0 overflow-scroll" style="height: 400px;">
                                            <xsl:for-each select="collection('../data/editions?select=idPb*.xml')">
                                                <xsl:sort select=".//tei:pb/@xml:id[1]"/>
                                                <xsl:variable name="page" select="replace(replace(tokenize(base-uri(current()),'/')[last()], '.xml', ''), 'idPb', '')"/>
                                                <xsl:variable name="pageString" select="if(contains($page, '_'))then(xs:integer(replace(tokenize($page, '_')[1], 'F', ''))||'/'||tokenize($page, '_')[2])else(xs:integer(replace($page, 'F', '')))"/>
                                                <xsl:if test="not(.//tei:pb[@type='nonWitness'])">
                                                <li>
                                                    <a class="dropdown-item fs-9_38 py-0" href="{replace(tokenize(base-uri(current()),'/')[last()], '.xml', '.html')}">
                                                        <xsl:value-of select="'Seite: '||$pageString"/>
                                                    </a>
                                                </li>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </ul>
                                        <xsl:if test="string-length($next) > 0">
                                            <a href="{replace($next, '.xml', '.html')}" title="zu seite {replace($next, '.xml', '.html')} gehen">
                                                <svg width="24" height="24" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false"><g><path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"></path></g></svg>
                                            </a>
                                        </xsl:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <wpn-page-view annotation-selectors=".entity" id="sub_grid_pb">
                            <div id="facscolumn" class="mx-auto ff-crimson-text">
                                <div id="facscontent" wpn-data="{$facsimile}" wpn-type="{.//tei:pb[1]/@type}">
                                    <!-- osd viewer container -->
                                </div>                                
                            </div>
                            <div id="textcolumn-pb" class="mx-auto ff-crimson-text">
                                <div id="textcontent-pb">
                                    <xsl:apply-templates select="//tei:text" />
                                </div>
                            </div>
                            <xsl:call-template name="info-3rd-column"/>
                        </wpn-page-view>
                    </div>
                </main>
                <xsl:call-template name="html_footer">
                    <xsl:with-param name="include_scroll_script" select="false()"/>
                </xsl:call-template>
                <xsl:call-template name="scripts"/>
                
            </body>
        </html>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:choose>
            <xsl:when test="following-sibling::*[1]/local-name() = ('note', 'pb')">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="following-sibling::*[1][@n='lb-dash']">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="following-sibling::*[1][@n='first']">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:body">
        <xsl:variable name="printType">
            <xsl:value-of select=".//tei:pb[1]/@type"/>
        </xsl:variable>
        <div class="print-page {$printType} position-relative">
            <div class="print-header {$printType} zindex-99">
                <!-- <xsl:apply-templates select="//tei:fw" mode="render"/> -->
                <!-- <xsl:apply-templates select="//tei:note[contains(@place, 'top')]" mode="render"/> -->
            </div>
            <div class="print-body {$printType}">
                <div class="body-left">
                    <xsl:apply-templates select="//tei:add[@rend|parent::tei:subst[@rend]|ancestor::tei:subst[@rend]
                                                    and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(parent::tei:span[ancestor::tei:subst[@rend]])then(ancestor::tei:subst/@rend)else(@rend)), 'Left')]
                        | //tei:del[not(parent::tei:subst) and contains(@rend, 'Left')]
                        | //tei:metamark[@function='progress' and contains(@rend, 'Left')]
                        | //tei:metamark[@function='transposition' and contains(@rend, 'Left')]
                        | //tei:metamark[@function='printInstruction' and contains(@rend, 'Left')]
                        | //tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'Left')]
                        | //tei:metamark[@function='insertion' and contains(@rend, 'Left')]
                        | //tei:mod[@rendition='#longQuote' and not(@continued) and contains(@rend, 'Left')]
                        | //tei:mod[@rendition='#longQuoteEndCenter' and not(@continued) and contains(@rend, 'Left')]
                        | //tei:mod[@rendition='#runningText1' and not(@continued) and contains(@rend, 'Left')]
                        | //tei:mod[not(@rendition) and @style='noIndent' and not(@continued) and contains(@rend, 'Left')]" mode="render"/>
                </div>
                <div class="body-main">
                    <xsl:apply-templates/>
                </div>
                <div class="body-right">
                    <xsl:apply-templates select="//tei:add[@rend|parent::tei:subst[@rend]|ancestor::tei:subst[@rend]
                                                    and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(parent::tei:span[ancestor::tei:subst[@rend]])then(ancestor::tei:subst/@rend)else(@rend)), 'Right')]
                        | //tei:del[not(parent::tei:subst) and contains(@rend, 'Right')]
                        | //tei:metamark[@function='progress' and contains(@rend, 'Right')]
                        | //tei:metamark[@function='transposition' and contains(@rend, 'Right')]
                        | //tei:metamark[@function='printInstruction' and contains(@rend, 'Right')]
                        | //tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'Right')]
                        | //tei:metamark[@function='insertion' and contains(@rend, 'Right')]
                        | //tei:mod[@rendition='#longQuote' and not(@continued) and contains(@rend, 'Right')]
                        | //tei:mod[@rendition='#longQuoteEndCenter' and not(@continued) and contains(@rend, 'Right')]
                        | //tei:mod[@rendition='#runningText1' and not(@continued) and contains(@rend, 'Right')]
                        | //tei:mod[not(@rendition) and @style='noIndent' and not(@continued) and contains(@rend, 'Right')]" mode="render"/>
                </div>
            </div>
            <div class="print-footer {$printType} zindex-99">
                <!-- <xsl:apply-templates select="//tei:note[contains(@place, 'bottom')]" mode="render"/> -->
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:p[@n]|tei:mod[@n]">
        <div id="{local:makeId(.)}" class="yes-index {if(self::tei:p)then(replace(@rendition,'#',''))else()}{if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{local:makeId(.)}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <!-- <xsl:template match="tei:pb">
        <span class="pagebreaks entity" id="{'pb'||@n}"  style="display:none;">||</span>
    </xsl:template> -->
    <xsl:template match="tei:pb"/>
    <xsl:template match="tei:ref[@type=('comment','glossary','event')]">
        <span class="comments" id="{@xml:id}"></span>
    </xsl:template>
    <xsl:template match="tei:fw">
        <span class="fw {replace(@change,'#','')} {replace(@rendition,'#','')} {@place}">
            <span><xsl:apply-templates/></span>
        </span>
    </xsl:template>
    <xsl:template match="tei:app">
        <span class="hidden"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:lg">
        <span class="d-block lg {replace(@rendition,'#','')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:l">
        <span class="d-block l {@style}"><span class="inline-text"><xsl:apply-templates/></span></span>
	</xsl:template>
    <xsl:template match="tei:quote">
        <span class="quotes {substring-after(@rendition, '#')} {substring-after(@change, '#')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:rs[@type=('person','personGroup')]">
        <span class="persons {substring-after(@rendition, '#')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:rdg[@source='F890']"/>
    <xsl:template match="tei:rdg[@source='DW']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:hi[@rendition='#inkOnProof_KK_spc' or @rendition='#typescriptSpc' or @style='letterSpacing']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="spacing underline {replace(@change, '#', '')}">
                    <span class="underline-crossed-out"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="spacing {replace(@change, '#', '')}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:hi[@style='underline']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="underline {replace(@change, '#', '')}">
                    <span class="underline-wavy"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="underline {replace(@change, '#', '')}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:choice[child::tei:corr[@type='comment']]">
        <xsl:apply-templates select="tei:sic" mode="render"/>
    </xsl:template>
    <xsl:template match="tei:choice[not(child::tei:corr[@type='comment'])]">
        <span><xsl:apply-templates select="tei:sic"/></span>
    </xsl:template>
     <xsl:template match="tei:p[not(@n)]">
        <!-- <xsl:variable name="string" select="count(tokenize(string-join(.//text(), ''), '.'))"/> -->
        <!-- <span style="color:red;display:block;"><xsl:value-of select="$string"/></span> -->
        <!-- <xsl:variable name="spacing-string" select="count(tokenize(string-join(./tei:hi[@style='letterSpacing']/text(), ''), '.'))"/> -->
        <!-- <span style="color:blue;display:block;"><xsl:value-of select="$spacing-string"/></span> -->
        <!-- <xsl:variable name="max" select="if($spacing-string gt 44)then(54)else(71)"/> -->
        <!-- <span style="display:block;"><xsl:value-of select="string($max)"/></span> -->
        <!-- {if(parent::tei:quote and $string lt $max)then('text-align-left')else('')} -->
        <span class="d-block {replace(@rendition,'#','')} {if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}">
            <span class="inline-text"><xsl:apply-templates/></span>
        </span>
    </xsl:template>
    <xsl:template match="tei:c[@resp='#edACE']"/>
    <xsl:template match="tei:c[not(@resp='#edACE')]">
        <xsl:value-of select="'&#x2060;&#x2009;&#x2060;'"/>
    </xsl:template>
    <xsl:template match="tei:corr"/>
    <xsl:template match="tei:sic">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:sic" mode="render">
        <xsl:apply-templates/>
    </xsl:template>
     <xsl:template match="tei:anchor[@type='metamark']">
        <span class="anchor {replace((@change)[1], '#', '')}" id="{@xml:id}"></span>
     </xsl:template>
    <xsl:template match="tei:restore">
        <span class="restore {replace((@change)[1], '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:subst">
        <span class="subst {replace((@change)[1], '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
    </xsl:template>
    
    <!-- <xsl:template match="tei:ptr[parent::tei:transpose]">
    <xsl:variable name="target" select="replace(@target,'#','')"/>
    <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//tei:seg[@xml:id=$target]" mode="render"/>
    </xsl:template> -->
    <xsl:template match="tei:note">
        <span class="note d-block text-align-left {if(@place)then(concat(@place, ' position-absolute'))else()} {replace(@change,'#','')}" id="{@xml:id}"><xsl:apply-templates/></span>
    </xsl:template>
    <!-- <xsl:template match="tei:lb[@type='req']">
        <br/>
    </xsl:template> -->
    <xsl:template match="tei:lb[@n='first']"/>
    <xsl:template match="tei:lb[@n='firstLast']"/>
    <xsl:template match="tei:lb[@n='last' or not(@n)]">
    <xsl:if test="@break"><xsl:text>-</xsl:text></xsl:if><br/>
    </xsl:template>
    <xsl:template match="tei:span[@n='last']">
        <xsl:choose>
            <xsl:when test="ancestor::tei:del or parent::tei:del or preceding-sibling::*[1]/local-name() = ('del', 'add')">
                <span class="d-table-row {if(ancestor::tei:p[contains(@rendition, 'Center') or contains(@rendition, 'center')])then()else('text-align-left')} no-indent">&#160;<xsl:apply-templates/></span>
            </xsl:when>
            <!-- <xsl:when test="preceding-sibling::*[1][@n='last']/local-name() = 'span'">
                <span class="d-table-row text-align-left no-indent">&#160;<xsl:apply-templates/></span>
            </xsl:when> -->
            <xsl:otherwise>
                <span class="d-block {if(ancestor::tei:p[contains(@rendition, 'Center') or contains(@rendition, 'center')])then()else('text-align-left')} no-indent"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:span[@n='firstLast']">
        <xsl:choose>
            <xsl:when test="ancestor::tei:del or parent::tei:del or preceding-sibling::*[1]/local-name() = ('del', 'add')">
                <span class="d-table-row {if(ancestor::tei:p[contains(@rendition, 'Center') or contains(@rendition, 'center')])then()else('text-align-left')}">&#160;<xsl:apply-templates/></span>
            </xsl:when>
            <!-- <xsl:when test="preceding-sibling::*[1][@n='last']/local-name() = 'span'">
                <span class="d-table-row text-align-left no-indent">&#160;<xsl:apply-templates/></span>
            </xsl:when> -->
            <xsl:otherwise>
                <span class="d-block {if(ancestor::tei:p[contains(@rendition, 'Center') or contains(@rendition, 'center')])then()else('text-align-left')}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:span[not(@n)]">
        <span class="{@style}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:listTranspose"/>
    <xsl:template match="tei:gap">
        <xsl:choose>
        <xsl:when test="@extent">
            <xsl:value-of select="string-join((for $i in 1 to @extent return '&#191;'),'')"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>&#9618;</xsl:text>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <span class="unclear"><xsl:apply-templates/></span>
    </xsl:template>
</xsl:stylesheet>
