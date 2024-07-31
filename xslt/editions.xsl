<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:preserve-space elements="*" />
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/aot-options.xsl"/>
    <xsl:import href="./partials/short-infos.xsl"/>
    <xsl:import href="./partials/pagination.xsl"/>

    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"/>
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
                    <xsl:with-param name="container" select="'container-fluid'"/>
                </xsl:call-template>
                <main class="flex-shrink-0 mt-18">
                    <div class="container-fluid px-0">
                        <div class="row">
                            <div class="col-md-2 col-lg-2 col-sm-12">
                                <xsl:if test="ends-with($prev,'.html')">
                                    <h1>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$prev"/>
                                            </xsl:attribute>
                                            <i class="bi bi-chevron-left" title="zurück"/>
                                        </a>
                                    </h1>
                                </xsl:if>
                            </div>
                            <!--<div class="col-md-8 col-lg-8 col-sm-12">
                                <h1 align="center">
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                                <h3 align="center">
                                    <a href="{$teiSource}">
                                        <i class="bi bi-download" title="TEI/XML"/>
                                    </a>
                                </h3>
                            </div>-->
                            <div class="col-md-2 col-lg-2 col-sm-12" style="text-align:right">
                                <xsl:if test="ends-with($next, '.html')">
                                    <h1>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$next"/>
                                            </xsl:attribute>
                                            <i class="bi bi-chevron-right" title="weiter"/>
                                        </a>
                                    </h1>
                                </xsl:if>
                            </div>
                        </div>
                        <wpn-text-view annotation-selectors=".entity" id="sub_grid">
                           <div>
                                <div class="p-0 d-flex flex-column align-items-center position-fixed">
                                    <xsl:call-template name="pagination">
                                        <xsl:with-param name="current-page" select="$id"/>
                                    </xsl:call-template>
                                    <div id="editor-widget">
                                        <xsl:call-template name="annotation-options"/>
                                    </div>
                                </div>
                                </div>
                                <div id="textcolumn" class="mx-auto ff-century-old-style">
                                        <xsl:apply-templates/>
                                </div>
                                <div id="infocolumn" class="px-0 border-start border-light-grey">
                                    <xsl:for-each select="//(tei:quote | tei:rs[@type=('person','personGroup')] | tei:pb | tei:ref[@type=('comment','glossary','event')])">
                                        <xsl:apply-templates select="current()" mode="short_info"/>
                                    </xsl:for-each>

                            </div>
                        </wpn-text-view>
                    </div>
                    <xsl:for-each select="//tei:back">
                        <div class="tei-back">
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                </main>
                <xsl:call-template name="html_footer">
                    <xsl:with-param name="include_scroll_script" select="false()"/>
                </xsl:call-template>
                <!--<script src="https://unpkg.com/de-micro-editor@0.2.6/dist/de-editor.min.js"/>-->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/openseadragon.min.js"/>
                <script src="https://unpkg.com/de-micro-editor@0.4.0/dist/de-editor.min.js"></script>
                <script type="text/javascript" src="js/init-micro-editor.js"></script>
                <script type="text/javascript" src="js/wpn-text-view.js"></script>
                <script type="text/javascript" src="js/wpn-entity.js"></script>
                <script type="text/javascript" src="js/wpn-header.js"></script>

                <!--<script type="text/javascript" src="js/osd_scroll.js"></script>-->
                
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:p[@n]|tei:mod[@n]">
        <div id="{local:makeId(.)}" class="yes-index {replace(@rendition,'#','')}">
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
        <span class="d-block l"><span class="inline-text"><xsl:apply-templates/></span></span>
	</xsl:template>
    <xsl:template match="tei:seg[@type='F890']">
        <span class="fackelrefs entity {substring-after(@rendition, '#')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:quote">
        <wpn-entity class="quotes entity {substring-after(@rendition, '#')}" id="{@xml:id}">
                <xsl:apply-templates/>
        </wpn-entity>
    </xsl:template>
    <xsl:template match="tei:rs[@type=('person','personGroup')]">
        <wpn-entity class="persons entity {substring-after(@rendition, '#')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </wpn-entity>
    </xsl:template>
    <xsl:template match="tei:rdg[@source='F890']"/>
    <xsl:template match="tei:del[ancestor::tei:restore[ancestor::tei:restore[child::tei:seg]]]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[ancestor::tei:restore[child::seg]]"/>
    <xsl:template match="tei:del[ancestor::tei:restore[not(child::seg)]]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[not(ancestor::tei:restore)][not(ancestor::tei:restore[ancestor::tei:restore[child::tei:seg]])]"/>
    <xsl:template match="tei:hi[@rendition='#inkOnProof_KK_spc' or @rendition='#typescriptSpc' or @style='letter-spacing: 0.1em;']">
        <span class="spacing"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:metamark[@function='printInstruction' or @function='undefined']"/>
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:mod[@rendition='#pencilOnProof_rightAlignSmall']">
        <span class="longQuoteRightAlign d-block"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@rendition='#runningText1']">
        <span class="d-block runningText1"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:choice[child::tei:corr[@type='comment']]">
        <xsl:apply-templates select="tei:sic"/>
    </xsl:template>
    <xsl:template match="tei:choice[not(child::tei:corr[@type='comment'])]">
        <xsl:apply-templates select="tei:corr"/>
    </xsl:template>
    <xsl:template match="tei:seg[@type='relocation']">
        <span><xsl:apply-templates/></span>
    </xsl:template>
     <xsl:template match="tei:p[not(@n)]">
        <span class="d-block {replace(@rendition,'#','')}">
            <span class="inline-text"><xsl:apply-templates/></span>
        </span>
    </xsl:template>
</xsl:stylesheet>
