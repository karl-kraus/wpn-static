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
    <xsl:import href="./partials/textview-detail-infos.xsl"/>
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

    
        <html id="edition-view" lang="{$site_language}">
    
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
                <div class="flex-shrink-0 mt-18">
                    <div class="container-fluid px-0">
                        <wpn-text-view annotation-selectors=".entity" id="sub_grid">
                            <aside>
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
                            </aside>
                            <main>
                                <div id="textcolumn" class="mx-auto ff-crimson-text">
                                        <div id="textcontent">
                                            <xsl:apply-templates select="tei:TEI/tei:p[@n]|tei:TEI/tei:mod[@n]"/>
                                        </div>
                                </div>
                            </main>
                            <aside id="infocolumn" class="bg-white px-0 border-start border-light-grey position-relative">
                                <xsl:variable name="regrefs">
                                    <xsl:copy>
                                        <xsl:apply-templates mode="raw"/>
                                    </xsl:copy>
                                </xsl:variable>
                                <xsl:for-each select="$regrefs//@target">
                                    <xsl:variable name="target" select="current()"/>
                                    <xsl:choose>
                                        <xsl:when test="starts-with($target,'insertionstart')">
                                            <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//*[contains(@target,replace($target,'insertionstart_','#'))]" mode="short_info">
                                                <xsl:with-param name="reftype" select="'insertionstart'"/>
                                                <xsl:with-param name="target" select="$target"/>
                                            </xsl:apply-templates>
                                        </xsl:when>
                                        <xsl:when test="starts-with($target,'insertionend')">
                                            <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//*[contains(@target,replace($target,'insertionend_','#'))]" mode="short_info">
                                                <xsl:with-param name="reftype" select="'insertionend'"/>
                                                <xsl:with-param name="target" select="$target"/>
                                            </xsl:apply-templates>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//*[@xml:id=$target]" mode="short_info"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <wpn-detail-view class="d-none position-absolute top-0 h-100 bg-white w-100">
                                    <div class="d-block position-sticky overflow-y-auto">
                                        <xsl:variable name="regrefs">
                                        <xsl:copy>
                                            <xsl:apply-templates mode="raw" />
                                        </xsl:copy>
                                        </xsl:variable>
                                        <xsl:for-each select="$regrefs//@target">
                                        <xsl:variable name="target" select="current()" />
                                        <xsl:choose>
                                            <xsl:when test="starts-with($target,'insertionstart')">
                                            <xsl:apply-templates
                                                select="doc('../data/editions/Gesamt.xml')//*[@target=replace($target,'insertionstart_','#')]"
                                                mode="short_info">
                                                <xsl:with-param name="reftype" select="'insertionstart'" />
                                            </xsl:apply-templates>
                                            </xsl:when>
                                            <xsl:when test="starts-with($target,'insertionend')">
                                            <xsl:apply-templates
                                                select="doc('../data/editions/Gesamt.xml')//*[@target=replace($target,'insertionend_','#')]"
                                                mode="short_info">
                                                <xsl:with-param name="reftype" select="'insertionend'" />
                                            </xsl:apply-templates>
                                            </xsl:when>
                                            <xsl:otherwise>
                                            <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//*[@xml:id=$target]"
                                                mode="detail_view_textpage" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        </xsl:for-each>
                                    </div>
                                </wpn-detail-view>
                           </aside>
                        </wpn-text-view>
                    </div>
                </div>
                <xsl:call-template name="html_footer">
                    <xsl:with-param name="include_scroll_script" select="false()"/>
                </xsl:call-template>
                <script type="text/javascript" src="js/vendor/markjs/mark.min.js"></script>
                <script type="text/javascript" src="js/vendor/openseadragon/openseadragon.min.js"></script>
                <xsl:call-template name="scripts"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:p[@n]|tei:mod[@n]">
        <div id="{local:makeId(.)}" class="yes-index {replace(@rendition,'#','')}">
			<xsl:apply-templates select="preceding-sibling::tei:pb"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{local:makeId(.)}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:pb[matches(@n,'.*_[a-z].*')]"/>
    <xsl:template match="tei:pb[not(matches(@n,'.*_[a-z].*'))]">
        <span class="pagebreaks entity" id="{'pb'||@n}"/>
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
    <xsl:template match="tei:lg">
        <span class="d-block lg {replace(@rendition,'#','')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:l|tei:mod[@rendition='#verseLine']">
        <span class="d-block l {@style}"><span class="inline-text"><xsl:apply-templates/></span></span>
	</xsl:template>
    <xsl:template match="tei:seg[@rendition='#typescriptFloatRight']">
        <span class="float-end"><xsl:apply-templates/></span>
    </xsl:template>
    <!-- refactor following template if time is left -->
    <xsl:template match="tei:seg[@type='F890']">
    <xsl:variable name="prev_id" select="replace(@prev,'#','')"/>
    <xsl:variable name="prev_on_same_page" select="boolean(root()//tei:seg[@xml:id=$prev_id])"/>
    <xsl:variable name="followed_by_inline" select="boolean(following-sibling::*[1][self::tei:metamark[not(matches(@target,'(note)+.*([a-z])_'))]])"/>
    <xsl:variable name="isInline" select="boolean(./preceding-sibling::node()[self::text()[matches(.,'.*[a-z].*')]] or ./following-sibling::node()[self::text()[matches(.,'.*[a-z].*')]] or ./parent::tei:note)"/> 
        <wpn-entity bubble="false" class="fackel entity {substring-after(@rendition, '#')} {if (($isInline or $prev_on_same_page or $followed_by_inline) and not(./child::tei:lg)) then () else 'd-block'}" id="{@xml:id}">
            <xsl:apply-templates/>
        </wpn-entity>
    </xsl:template>
    <xsl:template match="tei:seg[@type='F890']" mode="raw">
        <ref target="{@xml:id}">
            <xsl:apply-templates mode="raw"/>
        </ref>
    </xsl:template>
    <xsl:template match="tei:app">
        <wpn-entity bubble="false" class="apps fackel entity" id="{@xml:id}">
            <xsl:if test="@prev">
                <xsl:attribute name="data-prev" select="replace(@prev,'#','')"/>
            </xsl:if>
            <xsl:apply-templates/>
        </wpn-entity>
    </xsl:template>
    <xsl:template match="tei:app" mode="raw">
        <ref target="{@xml:id}">
            <xsl:apply-templates mode="raw"/>
        </ref>
    </xsl:template>
    <xsl:template match="tei:quote">
    <xsl:variable name="break" select="if (descendant::node()[1]/local-name()='p' or (descendant::*[1]/local-name()='p' and not(descendant::*[1]/preceding-sibling::node()[string-length(.)>1]) and not(descendant::*[1]/preceding-sibling::node()[string-length(.)>1]) and not(descendant::*[1]/following-sibling::node()[string-length(.)>1])) or descendant::node()[1]/local-name()='lg') then 'd-block' else()"/>
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
    <xsl:template match="tei:del[ancestor::tei:restore[1][child::tei:seg]]"/>
    <xsl:template match="tei:del[ancestor::tei:restore[1][not(child::tei:seg)]]">
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
    <xsl:template match="tei:c[@type='nnbsp']"/>
     <xsl:template match="tei:sic"/>
     <xsl:template match="tei:sic" mode="render">
        <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="tei:add[ancestor::tei:restore[1][not(child::tei:seg)]]"/>
     <xsl:template match="tei:add[ancestor::tei:restore[1][child::tei:seg]]">
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
        <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//(tei:seg|tei:note)[@xml:id=$target]/*" mode="raw"/>
    </xsl:template>
    <xsl:template match="tei:metamark[@function=('insertion') and matches(@target,'(note)+.*([a-z])_')]">
    <xsl:variable name="n" select="@n"/>
       <xsl:choose>
            <xsl:when test="contains(@target,' ')">
                <xsl:for-each select="tokenize(@target,' ')">
                    <xsl:variable name="target" select="replace(current(),'#','')"/>
                    <span>
                        <span class="pagebreaks entity" id="{'insertionstart_'||$target}">||</span>
                                <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//tei:note[@xml:id=$target]" mode="render"/>
                        <xsl:if test="$n='last' or position() = last()">
                            <span class="pagebreaks entity" id="{'insertionend_'||$target}">||</span>
                        </xsl:if>
                    </span>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="target" select="replace(@target,'#','')"/>
                <span>
                    <span class="pagebreaks entity" id="{'insertionstart_'||$target}">||</span>
                            <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//tei:note[@xml:id=$target]" mode="render"/>
                    <xsl:if test="@n='last'">
                        <span class="pagebreaks entity" id="{'insertionend_'||$target}">||</span>
                    </xsl:if>
                </span>
            </xsl:otherwise>
       </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:metamark[@function=('insertion') and matches(@target,'(note)+.*([a-z])_')]" mode="raw">
        <xsl:choose>
            <xsl:when test="contains(@target,' ')">
                <xsl:for-each select="tokenize(@target,' ')">
                    <xsl:variable name="target" select="replace(current(),'#','')"/>
                   <ref target="{'insertionstart_'||replace(current(),'#','')}">
                    <xsl:apply-templates  select="doc('../data/editions/Gesamt.xml')//tei:note[@xml:id=$target]/*" mode="raw"/>
                    <xsl:if test="position()=last()">
                        <ref target="{'insertionend_'||replace(current(),'#','')}"></ref>
                    </xsl:if>
                </ref>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="target" select="replace(@target,'#','')"/>
                <ref target="{'insertionstart_'||replace(@target,'#','')}">
                    <xsl:apply-templates  select="doc('../data/editions/Gesamt.xml')//tei:note[@xml:id=$target]/*" mode="raw"/>
                    <xsl:if test="@n='last'">
                        <ref target="{'insertionend_'||replace(@target,'#','')}"></ref>
                    </xsl:if>
                </ref>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
     <xsl:template match="tei:metamark[@function=('printInstruction','undefined','progress', 'modification')]"/>
    <xsl:template match="tei:mod[@style=('noLetterSpacing') and not(parent::tei:restore)]">
        <span class="ls-0"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@style=('letterSpacing') and not(parent::tei:restore)]">
        <span class="spacing"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[contains(@rendition,'Quote')]">
        <span class="{replace(@rendition,'#','')} {if (@rendition='#longQuote') then 'd-block' else ()}">
            <xsl:choose>
                <xsl:when test="contains(@rendition,'Verse')">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <span class="inline-text">
                        <xsl:apply-templates/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:note" mode="raw"/>
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
        <xsl:analyze-string select="." regex="[!:;?]">
            <xsl:matching-substring>
                <span class="ls-0">
                    <xsl:value-of select="'&#x2060;&#x2009;&#x2060;'||."/>
                </span>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="translate(.,'&#xA;&#x9;','')"/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <xsl:template match="text()" mode="raw"/>
</xsl:stylesheet>
