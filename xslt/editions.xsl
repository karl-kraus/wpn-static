<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="no" omit-xml-declaration="yes"/>
    <xsl:preserve-space elements="*" />
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/aot-options.xsl"/>
    <xsl:import href="./partials/short-infos.xsl"/>
    <xsl:import href="./partials/pagination.xsl"/>
    <xsl:import href="./partials/scripts.xsl"/>

    <xsl:variable name="prev">
        <xsl:value-of select="data(tei:TEI/@prev)||'.html'"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="data(tei:TEI/@next)||'.html'"/>
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
                    <xsl:with-param name="include_searchbox" select="true()"/>
                    <xsl:with-param name="container" select="'container-fluid mx-1 edition-header'"/>
                </xsl:call-template>
                <main class="flex-shrink-0 mt-18">
                    <div class="container-fluid px-0">
                        <wpn-text-view annotation-selectors=".entity" id="sub_grid">
                           <div class="d-flex justify-content-center mt-2">
                                <div id="controls" class="p-0 d-flex flex-column align-items-center position-fixed">
                                    <xsl:call-template name="pagination">
                                        <xsl:with-param name="current-page" select="if (matches($id,'[0-9]+')) then $id else data(tei:TEI/tei:p/@n)"/>
                                        <xsl:with-param name="prev-page" select="$prev"/>
                                        <xsl:with-param name="next-page" select="$next"/>
                                    </xsl:call-template>
                                    <div id="editor-widget">
                                        <xsl:call-template name="annotation-options"/>
                                    </div>
                                </div>
                                </div>
                                <div id="textcolumn" class="mx-auto ff-century-old-style">
                                        <div id="textcontent">
                                            <xsl:apply-templates/>
                                        </div>
                                </div>
                                <div id="infocolumn" class="bg-white px-0 border-start border-light-grey">
                                <xsl:variable name="regrefs">
                                    <xsl:copy>
                                        <xsl:apply-templates mode="raw"/>
                                    </xsl:copy>
                                </xsl:variable>
                                <xsl:for-each select="$regrefs//@target">
                                    <xsl:variable name="target" select="current()"/>
                                    <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//*[@xml:id=$target]" mode="short_info"/>
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
                <script type="text/javascript" src="js/vendor/markjs/mark.min.js"></script>
                <xsl:call-template name="scripts"/>
                
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
    <xsl:template match="tei:pb" mode="raw">
        <ref target="{@xml:id}">
            <xsl:apply-templates mode="raw"/>
        </ref>
    </xsl:template>
    <xsl:template match="tei:ref[@type=('comment','glossary','event')]">
        <span class="comments entity" id="{@xml:id}"></span>
    </xsl:template>
    <xsl:template match="tei:ref[@type=('comment','glossary','event')]" mode="raw">
        <ref target="{@xml:id}">
            <xsl:apply-templates mode="raw"/>
        </ref>
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
    <xsl:variable name="isInline" select="boolean(./preceding-sibling::node()[self::text()[matches(.,'.*[a-z].*')]] or ./following-sibling::node()[self::text()[matches(.,'.*[a-z].*')]])"/>
        <wpn-entity class="fackel entity {substring-after(@rendition, '#')} {if ($isInline) then () else 'd-block'}" id="{@xml:id}">
            <xsl:apply-templates/>
        </wpn-entity>
    </xsl:template>
    <xsl:template match="tei:seg[@type='F890']" mode="raw">
        <ref target="{@xml:id}">
            <xsl:apply-templates mode="raw"/>
        </ref>
    </xsl:template>
    <xsl:template match="tei:app[not(@prev)][not(@next)]">
        <wpn-entity class="apps fackel entity" id="{@xml:id}">
            <xsl:apply-templates/>
        </wpn-entity>
    </xsl:template>
    <xsl:template match="tei:app[not(@prev)][not(@next)]" mode="raw">
        <ref target="{@xml:id}">
            <xsl:apply-templates mode="raw"/>
        </ref>
    </xsl:template>
    <xsl:template match="tei:quote">
    <xsl:variable name="break" select="if (descendant::node()[1]/local-name()='p' or descendant::node()[1]/local-name()='lg') then 'd-block' else()"/>
        <wpn-entity class="quotes entity {substring-after(@rendition, '#')}{$break}" id="{@xml:id}">
        <xsl:if test="@prev">
            <xsl:attribute name="data-prev" select="replace(@prev,'#','')"/>
        </xsl:if>
            <xsl:apply-templates/>
        </wpn-entity>
    </xsl:template>
    <xsl:template match="tei:quote" mode="raw">
        <ref target="{@xml:id}">
            <xsl:apply-templates mode="raw"/>
        </ref>
    </xsl:template>
    <xsl:template match="tei:rs[@type=('person','personGroup')][@prev]"/>
    <xsl:template match="tei:rs[@type=('person','personGroup')][not(@prev)]">
        <wpn-entity class="persons entity {substring-after(@rendition, '#')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </wpn-entity>
    </xsl:template>
    <xsl:template match="tei:rs[@type=('person','personGroup')][not(@prev)]" mode="raw">
       <ref target="{@xml:id}">
            <xsl:apply-templates mode="raw"/>
        </ref>
    </xsl:template>
    <xsl:template match="tei:rdg[@source='F890']"/>
    <xsl:template match="tei:rdg[@source='DW']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[ancestor::tei:restore[ancestor::tei:restore[child::tei:seg]]]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[ancestor::tei:restore[child::tei:seg]]"/>
    <xsl:template match="tei:del[ancestor::tei:restore[not(child::tei:seg)]]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[not(ancestor::tei:restore)][not(ancestor::tei:restore[ancestor::tei:restore[child::tei:seg]])]"/>
    <xsl:template match="tei:hi[@rendition='#inkOnProof_KK_spc' or @rendition='#typescriptSpc' or @style=('letterSpacing','underline')]">
        <span class="spacing"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition='#rightAlignSmall']">
        <span class="longQuoteRightAlign my-05 d-block"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@rendition='#runningText1']">
        <span class="d-block runningText1"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:choice[child::tei:corr[@type='comment']]">
        <xsl:apply-templates select="tei:sic" mode="render"/>
    </xsl:template>
    <xsl:template match="tei:choice[not(child::tei:corr[@type='comment'])]">
        <span><xsl:apply-templates select="tei:corr"/></span>
    </xsl:template>
     <xsl:template match="tei:p[not(@n)]">
        <span class="d-block {replace(@rendition,'#','')}">
            <span class="inline-text"><xsl:apply-templates/></span>
        </span>
    </xsl:template>
    <xsl:template match="tei:c">
        <xsl:value-of select="'&#x2060;&#x2009;&#x2060;'"/>
    </xsl:template>
     <xsl:template match="tei:sic"/>
     <xsl:template match="tei:sic" mode="render">
        <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="tei:add[ancestor::tei:restore[not(child::tei:seg)]]"/>
     <xsl:template match="tei:add[ancestor::tei:restore[child::tei:seg]]">
     <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="tei:corr">
        <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="tei:restore">
        <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="tei:subst">
        <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="tei:ptr[parent::tei:transpose]">
     <xsl:variable name="target" select="replace(@target,'#','')"/>
        <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//tei:seg[@xml:id=$target]" mode="render"/>
     </xsl:template>
     <xsl:template match="tei:seg[@type=('transposition','relocation') and not(parent::tei:restore)]"/>
     <xsl:template match="tei:seg[@type=('transposition','relocation')]" mode="render">
       <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:seg[@type=('transposition','relocation')]" mode="raw">
       <xsl:apply-templates mode="raw"/>
    </xsl:template>
    <xsl:template match="tei:metamark[@function=('insertion','relocation') and not(matches(@target,'(note)+.*([a-z])_'))]">
       <xsl:variable name="target" select="replace(@target,'#','')"/>
        <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//(tei:seg|tei:note)[@xml:id=$target]" mode="render"/>
    </xsl:template>
    <xsl:template match="tei:metamark[@function=('insertion','relocation') and not(matches(@target,'(note)+.*([a-z])_'))]" mode="raw">
       <xsl:variable name="target" select="replace(@target,'#','')"/>
        <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//(tei:seg|tei:note)[@xml:id=$target]" mode="raw"/>
    </xsl:template>
    <xsl:template match="tei:metamark[@function=('insertion') and matches(@target,'(note)+.*([a-z])_')]">
       <xsl:variable name="target" select="replace(@target,'#','')"/>
       <wpn-entity>
       <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//tei:note[@xml:id=$target]" mode="render"/>
       </wpn-entity>
    </xsl:template>
     <xsl:template match="tei:metamark[@function=('printInstruction','undefined','progress')]"/>
    <xsl:template match="tei:mod[@style=('noLetterSpacing') and not(parent::tei:restore)]">
        <span class="ls-0"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@style=('letterSpacing') and not(parent::tei:restore)]">
        <span class="spacing"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[contains(@rendition,'Quote')]">
        <span class="{replace(@rendition,'#','')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:note" mode="render">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:mod[@style='italic']">
        <span class="fst-italic"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:lb[@type='req']">
        <br/>
    </xsl:template>
    <xsl:template match="tei:lb[not(@break)][not(@type)]"><xsl:text> </xsl:text></xsl:template>
     <xsl:template match="text()">
    <xsl:value-of 
     select="translate(.,'&#xA;&#x9;','')"/>
  </xsl:template>
  <xsl:template match="text()" mode="raw"/>
</xsl:stylesheet>
