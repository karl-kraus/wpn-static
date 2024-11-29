<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="3.0" exclude-result-prefixes="#all">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="no" omit-xml-declaration="yes"/>
    
    <!-- <xsl:strip-space elements="*"/> -->
    <!-- <xsl:preserve-space elements="tei:p tei:mod tei:seg"/> -->
    <xsl:preserve-space elements="*"/>

    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/short-infos.xsl"/>
    <xsl:import href="./partials/scripts.xsl"/>

    <xsl:variable name="prev">
        <xsl:value-of select="substring-after(data(tei:TEI/@prev), 'https://id.acdh.oeaw.ac.at/')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="substring-after(data(tei:TEI/@next), 'https://id.acdh.oeaw.ac.at/')"/>
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
                                        <a href="{replace($prev, '.xml', '.html')}" title="zu seite {replace($prev, '.xml', '.html')} gehen">
                                            <svg width="24" height="24" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false"><g><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path></g></svg>
                                        </a>
                                        <button class="btn btn-secondary dropdown-toggle fs-9_38 border-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                            <xsl:value-of select="'Seite: '||$currentPageString"/>
                                        </button>
                                        <ul class="dropdown-menu z-3 rounded-0 overflow-scroll" style="height: 400px;">
                                            <xsl:for-each select="collection('../data/editions?select=idPb*.xml')">
                                                <xsl:sort select=".//tei:pb/@xml:id[1]"/>
                                                <xsl:variable name="page" select="replace(replace(tokenize(base-uri(current()),'/')[last()], '.xml', ''), 'idPb', '')"/>
                                                <xsl:variable name="pageString" select="if(contains($page, '_'))then(xs:integer(replace(tokenize($page, '_')[1], 'F', ''))||'/'||tokenize($page, '_')[2])else(xs:integer(replace($page, 'F', '')))"/>
                                                <xsl:if test="not(contains(tokenize(base-uri(current()),'/')[last()], '-'))"><!-- verify first and remove first (motti) two pages -->
                                                <li>
                                                    <a class="dropdown-item fs-9_38 py-0" href="{replace(tokenize(base-uri(current()),'/')[last()], '.xml', '.html')}">
                                                        <xsl:value-of select="'Seite: '||$pageString"/>
                                                    </a>
                                                </li>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </ul>
                                        <a href="{replace($next, '.xml', '.html')}" title="zu seite {replace($next, '.xml', '.html')} gehen">
                                            <svg width="24" height="24" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false"><g><path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"></path></g></svg>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <wpn-page-view annotation-selectors=".entity" id="sub_grid_pb">
                            <div id="facscolumn" class="mx-auto ff-century-old-style">
                                <div id="facscontent" wpn-data="{$facsimile}" wpn-type="{.//tei:pb[1]/@type}">
                                    <!-- osd viewer container -->
                                </div>                                
                            </div>
                            <div id="textcolumn-pb" class="mx-auto ff-century-old-style">
                                <div id="textcontent-pb">
                                    <xsl:apply-templates select="//tei:text" />
                                </div>
                            </div>
                            <div id="infocolumn" class="bg-white px-0 border-start border-light-grey">
                                <div id="infocontent-pb">
                                <xsl:for-each select="//tei:TEI/tei:facsimile[@corresp='#DWkonJer']/tei:surface">
                                    <xsl:variable name="corresp" select="replace(@corresp, '#', '')"/>
                                    <div class="note m-2 {$corresp}">
                                        <h5><xsl:text>Jerusalemer Konvolut, fol. [</xsl:text><xsl:value-of select="@n"/><xsl:text>] recto</xsl:text></h5>
                                        <xsl:for-each select="./tei:note[@type='pagination']">
                                        <p><xsl:value-of select="concat('Pagination ', ./text(), ' (', replace(@corresp, '#', ''), ')')"/></p>
                                        </xsl:for-each>

                                        <h6 class="mt-2">Textträger</h6>
                                        <p><xsl:text>Standort, Signatur: </xsl:text></p>
                                        <p><xsl:text>Grundschicht, Material: </xsl:text><xsl:value-of select="ancestor::tei:TEI/tei:teiHeader//tei:item[@xml:id=$corresp]/text()"/></p>
                                        
                                        <h6 class="mt-2">Zustand</h6>
                                        <p><xsl:value-of select="./tei:note[@type='stamp']/text()"/></p>

                                        <xsl:if test="./tei:note[@type=('change', 'printInstruction')]">
                                        <h6 class="mt-2">Weitere Textschichten
                                        <a id="btn_more_text_layers" class="cursor-pointer" role="button" aria-expanded="false" aria-controls="#list_more_text_layers">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="stroke-black-grey stroke-wpn-red-hover align-baseline ms-2" width="10" height="10" viewBox="0 0 8 8">
                                                <g transform="translate(0.53 0.75)">
                                                    <path style="fill:none;stroke-width:1.5px;stroke-linejoin:round;" d="M0,6V0H6" transform="translate(6) rotate(90)"></path>
                                                    <line style="fill:none;stroke-width:1.5px;" y1="6" x2="6"></line>
                                                </g>
                                            </svg>
                                        </a>
                                        </h6>
                                        
                                        <ul id="list_more_text_layers" class="d-none list-unstyled ms-2">
                                        <xsl:for-each select="./tei:note[@type='change'][not(@corresp='#edACE')]">
                                            <li class="cursor-pointer my-1" data-link="{@corresp}"><xsl:value-of select="replace(@corresp, '#', '')"/></li>
                                        </xsl:for-each>
                                        <xsl:for-each select="./tei:note[@type='printInstruction']">
                                            <li class="cursor-pointer my-1" data-link="{@corresp}">Markierung für den Druck der Fackel Nr. 890: <xsl:value-of select="./text()"/></li>
                                        </xsl:for-each>
                                        </ul>
                                        </xsl:if>

                                        <xsl:if test="./tei:note[@type='tpqBase']">
                                        <h6 class="mt-2">Datierung (terminus post quem)</h6>
                                        <xsl:for-each select="./tei:note[@type='tpqBase']">
                                        <p class="tpq cursor-pointer" data-link="{@corresp}"><xsl:value-of select="concat('Grundschicht: ', ./text(), ' (zitierter Text)')"/></p>
                                        </xsl:for-each>
                                        </xsl:if>
                                        <xsl:if test="./tei:note[@type='tpqAdd']">
                                        <xsl:for-each select="./tei:note[@type='tpqAdd']">
                                        <p class="tpq cursor-pointer" data-link="{@corresp}"><xsl:value-of select="concat('Hs. Ergänzung: ', ./text(), ' (zitierter Text)')"/></p>
                                        </xsl:for-each>
                                        </xsl:if>

                                        <xsl:if test="./tei:note[@type=('delQuote', 'delPers')]">
                                        <h6 class="mt-2">Anmerkung</h6>
                                        <xsl:for-each select="./tei:note[@type=('delQuote', 'delPers')]">
                                        <div class="delQP cursor-pointer" data-link="{@target}" data-register="{@corresp}">
                                        <p>Eliminierter Verweis auf</p>
                                        
                                        <xsl:variable name="regrefs">
                                            <xsl:value-of select="tokenize(@target, ' ')"/>
                                        </xsl:variable>
                                        <xsl:for-each select="$regrefs">
                                            <xsl:variable name="target" select="replace(current(), '#', '')"/>
                                            <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//*[@xml:id=$target]" mode="short_info"/>
                                            <!-- <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//*[@xml:id=$target]" mode="detail_view_textpage" /> -->
                                        </xsl:for-each>
                                        </div>

                                        </xsl:for-each>
                                        </xsl:if>
                                    </div>
                                </xsl:for-each>
                                </div>
                            </div>
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

    <xsl:template match="tei:body">
        <xsl:variable name="printType">
            <xsl:value-of select=".//tei:pb[1]/@type"/>
        </xsl:variable>
        <div class="print-page {$printType} position-relative">
            <div class="print-header {$printType}">
                <!-- <xsl:apply-templates select="//tei:fw" mode="render"/> -->
                <!-- <xsl:apply-templates select="//tei:note[contains(@place, 'top')]" mode="render"/> -->
            </div>
            <div class="print-body {$printType}">
                <div class="body-left">
                    <xsl:apply-templates select="//tei:add[@rend|parent::tei:subst[@rend]
                                                    and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)), 'Left')]
                        | //tei:del[not(parent::tei:subst) and contains(@rend, 'Left')]
                        | //tei:metamark[@function='progress' and contains(@rend, 'Left')]
                        | //tei:metamark[@function='transposition' and contains(@rend, 'Left')]
                        | //tei:metamark[@function='printInstruction' and contains(@rend, 'Left')]
                        | //tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'Left')]
                        | //tei:metamark[@function='insertion' and contains(@rend, 'Left')]
                        | //tei:mod[@rendition='#longQuote' and contains(@rend, 'Left')]
                        | //tei:mod[@rendition='#runningText1' and contains(@rend, 'Left')]" mode="render"/>
                </div>
                <div class="body-main">
                    <xsl:apply-templates/>
                </div>
                <div class="body-right">
                    <xsl:apply-templates select="//tei:add[@rend|parent::tei:subst[@rend]
                                                    and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)), 'Right')]
                        | //tei:del[not(parent::tei:subst) and contains(@rend, 'Right')]
                        | //tei:metamark[@function='progress' and contains(@rend, 'Right')]
                        | //tei:metamark[@function='transposition' and contains(@rend, 'Right')]
                        | //tei:metamark[@function='printInstruction' and contains(@rend, 'Right')]
                        | //tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'Right')]
                        | //tei:metamark[@function='insertion' and contains(@rend, 'Right')]
                        | //tei:mod[@rendition='#longQuote' and contains(@rend, 'Right')]
                        | //tei:mod[@rendition='#runningText1' and contains(@rend, 'Right')]" mode="render"/>
                </div>
            </div>
            <div class="print-footer {$printType}">
                <!-- <xsl:apply-templates select="//tei:note[contains(@place, 'bottom')]" mode="render"/> -->
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:p[@n]|tei:mod[@n]">
        <div id="{local:makeId(.)}" class="yes-index {replace(@rendition,'#','')}  {if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}">
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
        <div class="fw {replace(@change,'#','')} {replace(@rendition,'#','')} {@place}">
            <span><xsl:apply-templates/></span>
        </div>
    </xsl:template>
    <!-- <xsl:template match="tei:mod[@change='#pencilOnProof_KK'][not(@rendition='#pencilOnProof_rightAlignSmall')]"/> -->
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
    <!-- <xsl:template match="tei:del[ancestor::tei:restore[ancestor::tei:restore[child::tei:seg]]]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[ancestor::tei:restore[child::tei:seg]]"/>
    <xsl:template match="tei:del[ancestor::tei:restore[not(child::tei:seg)]]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[not(ancestor::tei:restore)][not(ancestor::tei:restore[ancestor::tei:restore[child::tei:seg]])]"/> -->
    <xsl:template match="tei:hi[@rendition='#inkOnProof_KK_spc' or @rendition='#typescriptSpc' or @style='letterSpacing']">
        <span class="spacing"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:hi[@style='underline']">
        <span class="underline"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:choice[child::tei:corr[@type='comment']]">
        <xsl:apply-templates select="tei:sic" mode="render"/>
    </xsl:template>
    <xsl:template match="tei:choice[not(child::tei:corr[@type='comment'])]">
        <span><xsl:apply-templates select="tei:sic"/></span>
    </xsl:template>
     <xsl:template match="tei:p[not(@n)]">
        <xsl:variable name="string" select="count(tokenize(string-join(.//text(), ''), '.'))"/>
        <!-- <span style="color:red;display:block;"><xsl:value-of select="$string"/></span> -->
        <xsl:variable name="spacing-string" select="count(tokenize(string-join(./tei:hi[@style='letterSpacing']/text(), ''), '.'))"/>
        <!-- <span style="color:blue;display:block;"><xsl:value-of select="$spacing-string"/></span> -->
        <xsl:variable name="max" select="if($spacing-string gt 44)then(54)else(71)"/>
        <!-- <span style="display:block;"><xsl:value-of select="string($max)"/></span> -->
        <span class="d-block {replace(@rendition,'#','')} {if(parent::tei:quote and $string lt $max)then('text-align-left')else('')} {if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}">
            <span class="inline-text "><xsl:apply-templates/></span>
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
    <!-- <xsl:template match="tei:add[@rend|parent::tei:subst[@rend] and contains((@rend|parent::tei:subst/@rend), 'Right')]">
    <wpn-entity class="add entity" id="{@xml:id}"></wpn-entity>
    </xsl:template>
    <xsl:template match="tei:add[@rend|parent::tei:subst[@rend] and contains((@rend|parent::tei:subst/@rend), 'Left')]">
    <wpn-entity class="add entity" id="{@xml:id}"></wpn-entity>
    </xsl:template> -->
    <xsl:template match="tei:del[parent::tei:subst[@rend='overwritten']]">
        <span class="del text-black-grey {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:subst[parent::tei:restore]]">
        <del>
            <span class="del text-decoration-underline-dotted {replace(@change, '#', '')}"><xsl:apply-templates/></span>
        </del>
    </xsl:template>
    <xsl:template match="tei:del[@rend=('below', 'above') or parent::tei:subst/@rend=('below', 'above')]">
        <span class="position-relative">
            <span class="del {@rend} {replace(@change,'#','')}"><xsl:apply-templates/></span>
        </span>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:add]">
        <del id="{@xml:id}" class="{replace(@change, '#', '')}"><xsl:apply-templates/></del>
    </xsl:template>

    <xsl:template match="tei:del[parent::tei:restore]">
        <del>
            <span id="{@xml:id}" class="del connect entity text-decoration-underline-dotted {replace(@change, '#', '')}"><xsl:apply-templates/></span>
        </del>
    </xsl:template>
    <xsl:template match="tei:del[not(parent::tei:subst[@rend='overwritten']) and not(parent::tei:restore)]">
        <xsl:choose>
            <xsl:when test="child::tei:*">
                <del class="del connect entity {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></del>
            </xsl:when>
            <xsl:otherwise>
                <span class="del connect entity {replace(@change, '#', '')}" id="{@xml:id}">
                    <xsl:choose>
                        <xsl:when test="starts-with(., ' ')">
                            <xsl:text>&#x20;</xsl:text><del><xsl:value-of select="normalize-space(.)"/></del>
                        </xsl:when>
                        <xsl:when test="ends-with(., ' ')">
                            <del><xsl:value-of select="normalize-space(.)"/></del><xsl:text>&#x20;</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <del><xsl:value-of select="normalize-space(.)"/></del>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- margin container elements -->
    <xsl:template match="tei:del[not(parent::tei:subst) and contains(@rend, 'Left')]" mode="render">
        <div data-xmlid="{@xml:id}" class="d-flex ms-1">
            <xsl:if test="not(@xml:rend)">
            <div id="container-{@xml:id}" class="del connect {replace(@change,'#','')} w-100">
                <div class="position-relative">
                    <span class="{@rend}" style="font-size:1.25em;">&#124;&#x20B0;</span>
                </div>
            </div>
            </xsl:if>
            <xsl:if test="contains(@rend, 'marginInner')">
                <div id="container-{@xml:id}" class="del connect {replace(@change,'#','')}">
                    <div class="position-relative">
                        <span class="{@rend}" style="font-size:1.25em;">&#124;&#x20B0;</span>
                    </div>
                </div>
                <xsl:variable name="xmldata" select="tokenize(@xml:data, '/')"/>
                <xsl:variable name="tei" select="ancestor::tei:TEI"/>
                <xsl:iterate select="$xmldata">
                    <xsl:if test="string-length(current()) != 0">
                    <xsl:variable name="next" select="$tei//tei:*[@xml:id=current()]" as="element()"/>
                    <xsl:variable name="subornot" select="if(contains($next/@xml:id, '-sub-'))then($next/tei:add/@xml:id)else($next/@xml:id)"/>
                    <div id="container-{$subornot}" class="ms-1 del connect {replace($next/@change,'#','')}">
                        <div class="position-relative">
                            <xsl:choose>
                                <xsl:when test="contains($next/@xml:id, 'add')">
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'del')">
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}" style="font-size:1.25em;">
                                        &#124;&#x20B0;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'sub')">
                                    <span class="{$next/@rend}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next/tei:add"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'metam')">
                                    <span class="{$next/@rend}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                            </xsl:choose>
                        </div>
                    </div>
                    </xsl:if>
                </xsl:iterate>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="tei:del[not(parent::tei:subst) and contains(@rend, 'Right')]" mode="render">
        <div data-xmlid="{@xml:id}" class="d-flex ms-1">
            <xsl:if test="not(@xml:rend)">
                <div id="container-{@xml:id}" class="del connect {replace(@change,'#','')} w-100">
                    <div class="position-relative">
                        <span class="{@rend}" style="font-size:1.25em;">&#124;&#x20B0;</span>
                    </div>
                </div>
            </xsl:if>
            <xsl:if test="contains(@rend, 'marginInner')">
                <div id="container-{@xml:id}" class="del connect {replace(@change,'#','')}">
                    <div class="position-relative">
                        <span class="{@rend}" style="font-size:1.25em;">&#124;&#x20B0;</span>
                    </div>
                </div>
                <xsl:variable name="xmldata" select="tokenize(@xml:data, '/')"/>
                <xsl:variable name="tei" select="ancestor::tei:TEI"/>
                <xsl:iterate select="$xmldata">
                    <xsl:if test="string-length(current()) != 0">
                    <xsl:variable name="next" select="$tei//tei:*[@xml:id=current()]" as="element()"/>
                    <xsl:variable name="subornot" select="if(contains($next/@xml:id, '-sub-'))then($next/tei:add/@xml:id)else($next/@xml:id)"/>
                    <div id="container-{$subornot}" class="ms-1 del connect {replace($next/@change,'#','')}">
                        <div class="position-relative">
                            <xsl:choose>
                                <xsl:when test="contains($next/@xml:id, 'add')">
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'del')">
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}" style="font-size:1.25em;">
                                        &#124;&#x20B0;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, '-sub-')">
                                    <span class="{$next/@rend}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next/tei:add"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'metam')">
                                    <span class="{$next/@rend}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                            </xsl:choose>
                        </div>
                    </div>
                    </xsl:if>
                </xsl:iterate>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="tei:add[parent::tei:subst[parent::tei:restore]]">
        <del class="add connect entity {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></del>
    </xsl:template>
    <xsl:template match="tei:add[not(@rendition) and not(parent::tei:subst[@rend='overwritten']) and not(parent::tei:restore)]">
        <span class="add connect entity {replace(@change, '#', '')}" id="{@xml:id}"></span>
    </xsl:template>
    <xsl:template match="tei:add[parent::tei:restore]">
        <del class="add connect entity {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></del><span style="font-size:1.25em;" class="text-decoration-underline-dotted">&#124;</span>
    </xsl:template>
    <xsl:template match="tei:add[parent::tei:subst[@rend='overwritten']]">
        <span class="add connect overwrite ms-n08 {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:add[not(parent::tei:subst)]">
        <span class="add connect entity {replace(@change, '#', '')}" id="{@xml:id}"><span style="font-size:1.25em;">&#124;</span></span>
    </xsl:template>
    <xsl:template match="tei:add[@rend='inline' or parent::tei:subst/@rend = 'inline']">
        <span class="add {replace(@change,'#','')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:add[@rend=('below', 'above') or parent::tei:subst/@rend=('below', 'above')]">
        <span class="position-relative">
            <span class="add {@rend} {replace(@change,'#','')}"><xsl:apply-templates/></span>
        </span>
    </xsl:template>
    <!-- margin container elements -->
    <xsl:template match="tei:add[@rend|parent::tei:subst[@rend] and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)), 'Right')]" mode="render">
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)"/>
        <xsl:variable name="xmlrend" select="if(parent::tei:subst[@xml:rend])then(parent::tei:subst/@xml:rend)else(@xml:rend)"/>
        <xsl:variable name="containerID" select="if(parent::tei:subst)then(preceding-sibling::tei:del[1]/@xml:id)else(@xml:id)"/>
        <div data-xmlid="{@xml:id}" class="d-flex ms-1 entity">
            <xsl:if test="not($xmlrend)">
                <div id="container-{$containerID}" class="add connect {replace(@change,'#','')} w-100">
                    <div class="position-relative">
                        <span class="{$rend}" style="font-size:1.25em;">&#124;<xsl:apply-templates/></span>
                    </div>
                </div>
            </xsl:if>
            <xsl:if test="contains($rend, 'marginInner')">
                <div id="container-{$containerID}" class="add connect {replace(@change,'#','')}">
                    <div class="position-relative">
                        <span class="{$rend}" style="font-size:1.25em;">&#124;<xsl:apply-templates/></span>
                    </div>
                </div>
                <xsl:variable name="xmldata" select="tokenize(@xml:data, '/')"/>
                <xsl:variable name="tei" select="ancestor::tei:TEI"/>
                <xsl:iterate select="$xmldata">
                    <xsl:if test="string-length(current()) != 0">
                    <xsl:variable name="next" select="$tei//tei:*[@xml:id=current()]" as="element()"/>
                    <xsl:variable name="subornot" select="if(contains($next/@xml:id, '-sub-'))then($next/tei:add/@xml:id)else($next/@xml:id)"/>
                    <div id="container-{$subornot}" class="ms-1 add connect {replace($next/@change,'#','')}">
                        <div class="position-relative">
                            <xsl:choose>
                                <xsl:when test="contains($next/@xml:id, 'add')">
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'del')">
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}" style="font-size:1.25em;">
                                        &#124;&#x20B0;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'sub')">
                                    <span class="{$next/tei:add/@rend}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next/tei:add"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'metam')">
                                    <span class="{$next/@rend}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                            </xsl:choose>
                        </div>
                    </div>
                    </xsl:if>
                </xsl:iterate>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="tei:add[@rend|parent::tei:subst[@rend] and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)), 'Left')]" mode="render">
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)"/>
        <xsl:variable name="xmlrend" select="if(parent::tei:subst[@xml:rend])then(parent::tei:subst/@xml:rend)else(@xml:rend)"/>
        <xsl:variable name="containerID" select="if(parent::tei:subst)then(preceding-sibling::tei:del[1]/@xml:id)else(@xml:id)"/>
        <div data-xmlid="{@xml:id}" class="d-flex ms-1">
            <xsl:if test="not($xmlrend)">
                <div id="container-{$containerID}" class="add connect {replace(@change,'#','')} w-100">
                    <div class="position-relative">
                        <span class="{$rend}" style="font-size:1.25em;">&#124;<xsl:apply-templates/></span>
                    </div>
                </div>
            </xsl:if>
            <xsl:if test="contains($rend, 'marginInner')">
                <div id="container-{$containerID}" class="add connect {replace(@change,'#','')}">
                    <div class="position-relative">
                        <span class="{$rend}" style="font-size:1.25em;">&#124;<xsl:apply-templates/></span>
                    </div>
                </div>
                <xsl:variable name="xmldata" select="tokenize(@xml:data, '/')"/>
                <xsl:variable name="tei" select="ancestor::tei:TEI"/>
                <xsl:iterate select="$xmldata">
                    <xsl:if test="string-length(current()) != 0">
                    <xsl:variable name="next" select="$tei//tei:*[@xml:id=current()]" as="element()"/>
                    <xsl:variable name="subornot" select="if(contains($next/@xml:id, '-sub-'))then($next/tei:add/@xml:id)else($next/@xml:id)"/>
                    <div id="container-{$subornot}" class="ms-1 add connect {replace($next/@change,'#','')}">
                        <div class="position-relative">
                            <xsl:choose>
                                <xsl:when test="contains($next/@xml:id, 'add')">
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'del')">
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}" style="font-size:1.25em;">
                                        &#124;&#x20B0;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'sub')">
                                    <span class="{$next/tei:add/@rend}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next/tei:add"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'metam')">
                                    <span class="{$next/@rend}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                            </xsl:choose>
                        </div>
                    </div>
                    </xsl:if>
                </xsl:iterate>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="tei:add[@rendition]">
        <span class="add rendition {replace(@rendition,'#','')} {replace(@change,'#','')}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:metamark[@function='progress'][@place]">
        <span class="metamark {replace(@change,'#','')} {@place} {@style}" id="{@xml:id}"><xsl:apply-templates/></span>
     </xsl:template>
    <xsl:template match="tei:metamark[@function='progress'][@rend]">
        <span class="metamark connect entity {replace(@change,'#','')}" id="{@xml:id}">
            <xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if>
        </span>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='progress' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}"><xsl:apply-templates/></span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='progress' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {replace(@change,'#','')} ms-1" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}"><xsl:apply-templates/></span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='relocation'][@change='#edACE']"/>
     <xsl:template match="tei:metamark[@function='relocation'][not(@change='#edACE')][@place]">
        <span class="metamark {@place} {@style} {replace(@change, '#', '')}" id="{@xml:id}">&#124;</span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='relocation'][not(@change='#edACE')][@rend]">
        <span class="metamark connect entity {replace(@change, '#', '')}" id="{@xml:id}">&#124;<xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if></span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='relocation'][not(@change='#edACE')][not(@rend) and not(@place)]">
        <span class="metamark mm-inline connect {if(@target)then('target')else()} {replace(@change, '#', '')}" id="{@xml:id}">
            <span>
                <xsl:if test="@target">
                    <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                    <xsl:attribute name="data-target">
                        <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                    </xsl:attribute>
                </xsl:if>
                &#124;<xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if>
            </span>
        </span>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {if(@target)then('target')else()} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#124;<xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {if(@target)then('target')else()} {replace(@change,'#','')} ms-1" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#124;<xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='printInstruction'][@place]">
        <span class="metamark position-absolute {replace(@rendition,'#','')} {replace(@change,'#','')} {@place} {@style}" id="{@xml:id}"><xsl:apply-templates/></span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='printInstruction'][@rend]">
        <span class="metamark connect entity {replace(@change,'#','')}" id="{@xml:id}">
            <xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if>
        </span>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='printInstruction' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="metamark {if(@spanTo)then('spanto')else()} connect {replace(@change,'#','')} {replace(@rendition,'#','')}" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend} {@style}">
                    <xsl:if test="@spanTo">
                        <xsl:variable name="spanToList" select="tokenize(@spanTo, ' ')"/>
                        <xsl:attribute name="data-spanto">
                            <xsl:value-of select="for $i in $spanToList return concat('spanto-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    <span class="fade">&#124;</span><xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='printInstruction' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="metamark {if(@spanTo)then('spanto')else()} connect {replace(@change,'#','')} {replace(@rendition,'#','')} ms-1" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend} {@style}">
                    <xsl:if test="@spanTo">
                        <xsl:variable name="spanToList" select="tokenize(@spanTo, ' ')"/>
                        <xsl:attribute name="data-spanto">
                            <xsl:value-of select="for $i in $spanToList return concat('spanto-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    <span class="fade">&#124;</span><xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='printInstruction'][@rendition]">
        <span class="metamark {replace(@rendition,'#','')} {replace(@change,'#','')}" id="{@xml:id}"><xsl:apply-templates/></span>
     </xsl:template>
     <xsl:template match="tei:anchor[@type='metamark']">
        <span class="anchor {replace(@change, '#', '')}" id="{@xml:id}"></span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='transposition'][@place]">
        <span class="metamark {replace(@change,'#','')} {@place} {@style}" id="{@xml:id}"><xsl:apply-templates/></span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='transposition'][@rend]">
        <span class="metamark entity connect {replace(@change,'#','')}" id="{@xml:id}"><xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if></span>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='transposition' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {if(@target)then('target')else()} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}" style="font-size:1.25em;">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#423;
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='transposition' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {if(@target)then('target')else()} {replace(@change,'#','')} ms-1" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}" style="font-size:1.25em;">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#423;
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='insertion'][@place]">
        <span class="metamark {@style} {@place} {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='insertion'][@rend]">
        <span class="metamark connect entity {replace(@change, '#', '')}" id="{@xml:id}">&#124;</span>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='insertion' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {if(@target)then('target')else()} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#124;<xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='insertion' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {if(@target)then('target')else()} {replace(@change,'#','')} ms-1" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#124;<xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
    <!-- <xsl:template match="tei:add[ancestor::tei:restore[not(child::tei:seg)]]"/>
    <xsl:template match="tei:add[ancestor::tei:restore[child::tei:seg]]">
    <xsl:apply-templates/>
    </xsl:template> -->
    <xsl:template match="tei:restore">
    <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:subst">
        <span class="{replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg">
    <xsl:apply-templates/>
    </xsl:template>
    <!-- <xsl:template match="tei:ptr[parent::tei:transpose]">
    <xsl:variable name="target" select="replace(@target,'#','')"/>
    <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//tei:seg[@xml:id=$target]" mode="render"/>
    </xsl:template> -->
    
    <xsl:template match="tei:seg[@type='transposition' and not(@subtype='implicit') and not(parent::tei:restore)]">
        <span class="border rounded-pill {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@type='transposition' and not(@subtype='implicit') and parent::tei:restore]">
        <span class="border-dotted rounded-pill {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@type='relocation']">
        <span id="{if(not(@rend='line') and not(@rend='arrow'))then(@xml:id)else(concat('parent-', @xml:id))}">
            <xsl:if test="@rend='border'">
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('border border-1 border-secondary-subtle', replace(@change, '#', ''))"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@rend='line'"><span id="{@xml:id}">&#124;</span></xsl:if><xsl:if test="@rend='arrow'"><span id="{@xml:id}">&#8592;</span></xsl:if><xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:seg[@rendition='#runningText1']">
        <span class="d-block runningText1  {if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@type='F890']">
        <span class="fackelrefs entity {substring-after(@rendition, '#')} {if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- <xsl:template match="tei:seg[@type=('transposition','relocation')]" mode="render">
    <xsl:apply-templates/>
    </xsl:template> -->
    <!-- <xsl:template match="tei:metamark[@function=('insertion','relocation') and not(matches(@target,'(note)+.*([a-z])_'))]">
       <xsl:variable name="target" select="replace(@target,'#','')"/>
        <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//(tei:seg|tei:note)[@xml:id=$target]" mode="render"/>
    </xsl:template> -->
    <!-- <xsl:template match="tei:metamark[@function=('insertion') and matches(@target,'(note)+.*([a-z])_')]">
       <xsl:variable name="target" select="replace(@target,'#','')"/>
       <wpn-entity>
       <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//tei:note[@xml:id=$target]" mode="render"/>
       </wpn-entity>
    </xsl:template> -->
     <!-- <xsl:template match="tei:metamark[@function=('printInstruction','undefined','progress')]">
        <span class="metamark {replace(@change, '#', '')} {@rend} {replace(@rendition, '#', '')} {@place}"><xsl:apply-templates/></span>
     </xsl:template> -->
    <xsl:template match="tei:mod[@style=('noLetterSpacing') and not(parent::tei:restore)]">
        <span class="mod {@style} underline {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@style=('letterSpacing') and not(parent::tei:restore)]">
        <span class="mod {@style} underline {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@style='indent2']">
        <span class="mod {@style} {replace(@rendition,'#','')} {replace(@change, '#', '')}"><xsl:apply-templates/> <span style="font-size:1.25em;">&#8594;</span></span>
    </xsl:template>
    <xsl:template match="tei:mod[@style='noUnderline']">
        <span class="mod {@style} {replace(@rendition,'#','')} {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@style='italic']">
        <span class="mod {@style} fst-italic {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition='#rightAlignSmall']">
        <span class="mod {@style} {replace(@change, '#', '')} longQuoteRightAlign my-05 d-block"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="tei:mod[contains(@rendition,'Quote')]">
        <span class="mod connect entity {@style} {replace(@rendition,'#','')} {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
    </xsl:template>
    <!-- container element -->
    <xsl:template match="tei:mod[@rendition='#longQuote' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="mod connect ms-1 {@rend} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div><span style="font-size:1.25em;">&#124;</span></div>
        </div>
     </xsl:template>
     <xsl:template match="tei:mod[@rendition='#longQuote' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="mod connect ms-1 {@rend} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div><span style="font-size:1.25em;">&#124;</span></div>
        </div>
     </xsl:template>
    
    <xsl:template match="tei:mod[@rendition='#runningText1']">
        <span class="mod connect entity no-indent {@style} {replace(@rendition,'#','')} {replace(@change, '#', '')}" id="{@xml:id}">[<xsl:apply-templates/></span>
    </xsl:template>
    <!-- container element -->
     <xsl:template match="tei:mod[@rendition='#runningText1' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="mod connect ms-1 {@rend} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div><span style="font-size:1.25em;">[</span></div>
        </div>
     </xsl:template>
     <xsl:template match="tei:mod[@rendition='#runningText1' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="mod connect ms-1 {@rend} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div><span style="font-size:1.25em;">[</span></div>
        </div>
     </xsl:template>
    <xsl:template match="tei:note[@place]">
        <span class="note d-block {@place} {replace(@change, '#', '')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:note[not(@place)]">
        <span class="note {replace(@change,'#','')}" id="{@xml:id}"><xsl:apply-templates/></span>
    </xsl:template>
    <!-- <xsl:template match="tei:lb[@type='req']">
        <br/>
    </xsl:template> -->
    <xsl:template match="tei:lb[not(@n)]">
    <!-- [not(parent::tei:seg|tei:p[parent::tei:p|tei:seg|tei:body] and position() = 1 or preceding-sibling::*[1]/local-name() = 'fw')] -->
        <xsl:if test="@break"><xsl:text>-</xsl:text></xsl:if><br/>
    </xsl:template>
    <xsl:template match="tei:lb[@n='first']"/>
    <xsl:template match="tei:lb[@n='firstLast']"/>
    <xsl:template match="tei:lb[@n='last']">
        <xsl:if test="@break"><xsl:text>-</xsl:text></xsl:if><br/>
    </xsl:template>
    <xsl:template match="tei:span[@n='last']">
        <xsl:choose>
            <xsl:when test="ancestor::tei:del or parent::tei:del or preceding-sibling::*[1]/local-name() = ('del', 'add')">
                <span class="d-table-row text-align-left no-indent">&#160;<xsl:apply-templates/></span>
            </xsl:when>
            <!-- <xsl:when test="preceding-sibling::*[1][@n='last']/local-name() = 'span'">
                <span class="d-table-row text-align-left no-indent">&#160;<xsl:apply-templates/></span>
            </xsl:when> -->
            <xsl:otherwise>
                <span class="d-block text-align-left no-indent"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    <xsl:template match="tei:span[not(@n)]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:listTranspose"/>
    <xsl:template match="tei:gap">
        <xsl:choose>
        <xsl:when test="@extent">
            <xsl:value-of select="string-join((for $i in 1 to @extent return '&#9618;'),'')"/>
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
