<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="3.0" exclude-result-prefixes="#all">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="no" omit-xml-declaration="yes"/>
    <xsl:preserve-space elements="*" />
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/aot-options.xsl"/>
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
                            <div id="editor-widget" class="mx-auto">
                                <div>
                                    <div id="aot-navBarNavDropdown" class="navBarNavDropdown dropstart d-md-none">
                                        <!-- Your menu goes here -->
                                        <a title="Annotationen" href="#" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false" role="button">
                                            <i class="bi bi-gear" title="Menü zur Anpassung der Anzeige"></i>
                                        </a>                  
                                        <ul class="dropdown-menu d-block border-0 z-2">
                                            <!--<li class="dropdown-item">
                                                <full-size opt="fls"></full-size>
                                            </li>
                                            <li class="dropdown-item">
                                                <image-switch opt="es"></image-switch>
                                            </li>
                                            <li class="dropdown-item">
                                                <font-size opt="fs"></font-size>
                                            </li>
                                            <li class="dropdown-item">
                                                <font-family opt="ff"></font-family>
                                            </li>-->
                                            <li class="dropdown-item">
                                                <annotation-slider opt="prs" class="text-wpn-person fs-7"></annotation-slider>
                                            </li>
                                            <li class="dropdown-item">
                                                <annotation-slider opt="quts" class="text-wpn-quote fs-7"></annotation-slider>
                                            </li>
                                            <li class="dropdown-item">
                                                <annotation-slider opt="pbs" class="text-black-grey fs-7"></annotation-slider>
                                            </li>
                                            <li class="dropdown-item">
                                                <annotation-slider opt="cmts" class="text-comment fs-7"></annotation-slider>
                                            </li>
                                        </ul>                                                    
                                    </div>
                                    <div class="mt-2 d-flex">
                                            <!-- Your menu goes here --> 
                                            <fieldset>
                                                <div class="text-center gap-1_5 justify-content-center mb-05">
                                                <legend class="text-dark-grey fs-7">Textgröße</legend>
                                                <wpn-text-zoom-button zoom-direction="in">
                                                    <svg viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false" width="24" height="24"><g><path fill="#999" d="M13 7h-2v4H7v2h4v4h2v-4h4v-2h-4V7zm-1-5C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"></path></g></svg>
                                                </wpn-text-zoom-button>
                                                <wpn-text-zoom-button zoom-direction="out">
                                                    <svg viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false" width="24" height="24"><g><path fill="#999" d="M7 11v2h10v-2H7zm5-9C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"></path></g></svg>
                                                </wpn-text-zoom-button>
                                                </div>
                                            </fieldset>                        
                                            <ul class="gap-1_5 border-0 z-2 list-unstyled d-flex">
                                                <!--<li class="dropdown-item">
                                                    <full-size opt="fls"></full-size>
                                                </li>
                                                <li class="dropdown-item">
                                                    <image-switch opt="es"></image-switch>
                                                </li>
                                                <li class="dropdown-item">
                                                    <font-size opt="fs"></font-size>
                                                </li>
                                                <li class="dropdown-item">
                                                    <font-family opt="ff"></font-family>
                                                </li>-->
                                                <li>
                                                    <annotation-slider opt="prs" class="text-wpn-person fs-7 mx-auto"></annotation-slider>
                                                </li>
                                                <li>
                                                    <annotation-slider opt="quts" class="text-wpn-quote fs-7 mx-auto"></annotation-slider>
                                                </li>
                                                <li>
                                                    <annotation-slider opt="pbs" class="text-black-grey fs-7 mx-auto"></annotation-slider>
                                                </li>
                                                <li>
                                                    <annotation-slider opt="cmts" class="text-wpn-comment fs-7 mx-auto"></annotation-slider>
                                                </li>
                                            </ul>                                                    
                                        </div>
                                </div>
                            </div>
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
                        <wpn-text-view annotation-selectors=".entity" id="sub_grid_pb">
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
                                <xsl:for-each select="//tei:TEI/tei:facsimile[1]/tei:surface/tei:note">
                                    <div class="note m-2 {replace(@corresp, '#', '')}">
                                        <xsl:apply-templates/>
                                    </div>
                                </xsl:for-each>
                                </div>
                            </div>
                        </wpn-text-view>
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
        <div class="d-flex flex-column print-page {$printType}">
            <div class="print-header {$printType}">
                <xsl:apply-templates select="//tei:note[contains(@place, 'top')]" mode="render"/>
            </div>
            <div class="print-body {$printType}">
                <div class="body-left">

                </div>
                <div class="body-main">
                    <xsl:apply-templates/>
                </div>
                <div class="body-right">

                </div>
            </div>
            <div class="print-footer {$printType}">
                <xsl:apply-templates select="//tei:note[contains(@place, 'bottom')]" mode="render"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:p[@n]|tei:mod[@n]">
        <div id="{local:makeId(.)}" class="yes-index {replace(@rendition,'#','')} position-relative text-align-justify{if(@prev)then(' no-indent')else()}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{local:makeId(.)}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:pb">
        <span class="pagebreaks entity" id="{'pb'||@n}"  style="display:none;">||</span>
    </xsl:template>
    <xsl:template match="tei:ref[@type=('comment','glossary','event')]">
        <span class="comments entity" id="{@xml:id}"></span>
    </xsl:template>
    <xsl:template match="tei:fw"/>
    <xsl:template match="tei:mod[@change='#pencilOnProof_KK'][not(@rendition='#pencilOnProof_rightAlignSmall')]"/>
    <xsl:template match="tei:app">
        <span class="hidden"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:lg">
        <span class="d-block lg {replace(@rendition,'#','')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:l">
        <span class="d-block l {@style}"><span class="inline-text"><xsl:apply-templates/></span></span>
	</xsl:template>
    <xsl:template match="tei:seg[@type='F890']">
        <span class="fackelrefs entity {substring-after(@rendition, '#')} position-relative" id="{@xml:id}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:quote">
        <wpn-entity class="quotes entity {substring-after(@rendition, '#')} text-align-left" id="{@xml:id}">
            <xsl:apply-templates/>
        </wpn-entity>
    </xsl:template>
    <xsl:template match="tei:rs[@type=('person','personGroup')]">
        <wpn-entity class="persons entity {substring-after(@rendition, '#')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </wpn-entity>
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
    <xsl:template match="tei:del">
        <del><xsl:apply-templates/></del>
    </xsl:template>
    <xsl:template match="tei:hi[@rendition='#inkOnProof_KK_spc' or @rendition='#typescriptSpc' or @style='letterSpacing']">
        <span class="spacing"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition='#rightAlignSmall']">
        <span class="longQuoteRightAlign my-05 d-block"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@rendition='#runningText1']">
        <span class="d-block runningText1 position-relative text-align-justify{if(@prev)then(' no-indent')else()}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:choice[child::tei:corr[@type='comment']]">
        <xsl:apply-templates select="tei:sic" mode="render"/>
    </xsl:template>
    <xsl:template match="tei:choice[not(child::tei:corr[@type='comment'])]">
        <span><xsl:apply-templates select="tei:corr"/></span>
    </xsl:template>
     <xsl:template match="tei:p[not(@n)]">
        <span class="d-block {replace(@rendition,'#','')} text-align-justify{if(@prev)then(' no-indent')else()}">
            <span class="inline-text position-relative"><xsl:apply-templates/></span>
        </span>
    </xsl:template>
    <xsl:template match="tei:c">
        <xsl:value-of select="'&#x2060;&#x2009;&#x2060;'"/>
    </xsl:template>
     <xsl:template match="tei:sic"/>
     <xsl:template match="tei:sic" mode="render">
        <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="tei:add">
        <span class="add position-absolute {if(parent::tei:subst)then(parent::tei:subst/@rend)else(@rend)} {replace(@rendition,'#','')}">
            <xsl:apply-templates/>
        </span>
     </xsl:template>
     <!-- <xsl:template match="tei:add[ancestor::tei:restore[not(child::tei:seg)]]"/>
     <xsl:template match="tei:add[ancestor::tei:restore[child::tei:seg]]">
        <xsl:apply-templates/>
     </xsl:template> -->
     <xsl:template match="tei:corr">
        <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="tei:restore">
        <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="tei:subst">
        <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="tei:seg">
        <xsl:apply-templates/>
     </xsl:template>
     <!-- <xsl:template match="tei:ptr[parent::tei:transpose]">
        <xsl:variable name="target" select="replace(@target,'#','')"/>
        <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//tei:seg[@xml:id=$target]" mode="render"/>
     </xsl:template> -->
     <!-- <xsl:template match="tei:seg[@type=('transposition','relocation') and not(parent::tei:restore)]"/> -->
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
     <xsl:template match="tei:metamark[@function=('printInstruction','undefined','progress')][child::*]">
        <span class="metamark {replace(@change, '#', '')} {@rend} {@place} text-align-left"><xsl:apply-templates/></span>
     </xsl:template>
    <xsl:template match="tei:mod[@style=('noLetterSpacing') and not(parent::tei:restore)]">
        <span class="ls-0"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@style=('letterSpacing') and not(parent::tei:restore)]">
        <span class="spacing"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[contains(@rendition,'Quote')]">
        <span class="{replace(@rendition,'#','')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:note[contains(@place, 'bottom')]" mode="render">
        <div class="note {@place} {replace(@change, '#', '')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:note[contains(@place, 'top')]" mode="render">
        <div class="note {@place} {replace(@change, '#', '')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:mod[@style='italic']">
        <span class="fst-italic"><xsl:apply-templates/></span>
    </xsl:template>
    <!-- <xsl:template match="tei:lb[@type='req']">
        <br/>
    </xsl:template> -->
    <xsl:template match="tei:lb[not(@type)]">
    <!-- [not(parent::tei:seg|tei:p[parent::tei:p|tei:seg|tei:body] and position() = 1 or preceding-sibling::*[1]/local-name() = 'fw')] -->
        <xsl:if test="@break"><xsl:text>-</xsl:text></xsl:if><br/>
    </xsl:template>
    <xsl:template match="tei:lb[@type='first']"/>
    <xsl:template match="tei:lb[@type='last']">
        <xsl:if test="@break"><xsl:text>-</xsl:text></xsl:if><br/>
    </xsl:template>
    <xsl:template match="tei:s[@type='last']">
        <span class="d-block text-align-left no-indent"><xsl:apply-templates/></span>
    </xsl:template>
</xsl:stylesheet>
