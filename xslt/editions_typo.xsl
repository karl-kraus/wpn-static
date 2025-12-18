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
                        <wpn-page-view annotation-selectors=".entity">
                            <div id="sub_grid_pb" class="sub_grid_pb_three">
                                <div id="facscolumn" class="grid-box-1 mx-auto ff-crimson-text m-visually-hidden py-4">
                                    <div id="facscontent" wpn-data="{$facsimile}" wpn-type="{.//tei:pb[1]/@type}">
                                        <!-- osd viewer container -->
                                    </div>                                
                                </div>
                                <div id="textcolumn-pb" class="grid-box-2 mx-auto ff-crimson-text py-4">
                                    <div id="textcontent-pb">
                                        <xsl:apply-templates select="//tei:text" />
                                    </div>
                                </div>
                                <xsl:call-template name="info-3rd-column"/>
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

    <xsl:template match="text()">
        <xsl:choose>
            <xsl:when test="following-sibling::*[1]/local-name() = ('note', 'pb')">
                <xsl:value-of select="replace(., '\s$', '')"/>
            </xsl:when>
            <xsl:when test="following-sibling::*[1][@n='lb-dash']">
                <xsl:value-of select="replace(., '\s$', '')"/>
            </xsl:when>
            <xsl:when test="following-sibling::*[1][@n='first']">
                <xsl:value-of select="replace(., '\s$', '')"/>
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
        <div id="print-page" class="print-page {$printType} position-relative">
            <div class="print-header {$printType} zindex-99">
                <!-- <xsl:apply-templates select="//tei:fw" mode="render"/> -->
                <!-- <xsl:apply-templates select="//tei:note[contains(@place, 'top')]" mode="render"/> -->
            </div>
            <div class="print-body {$printType}">
                <div class="body-left row m-0">
                    <div class="body-left-outer col px-0">
                        <xsl:apply-templates select="//tei:add[@rend|parent::tei:subst[@rend]|ancestor::tei:subst[@rend]
                                                    and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(parent::tei:span[ancestor::tei:subst[@rend]])then(ancestor::tei:subst/@rend)else(@rend)), 'marginOuterLeft')]
                        | //tei:del[not(parent::tei:subst) and contains(@rend, 'marginOuterLeft')]
                        | //tei:metamark[@function='progress' and contains(@rend, 'marginOuterLeft')]
                        | //tei:metamark[@function='transposition' and contains(@rend, 'marginOuterLeft')]
                        | //tei:metamark[@function='printInstruction' and contains(@rend, 'marginOuterLeft')]
                        | //tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'marginOuterLeft')]
                        | //tei:metamark[@function='insertion' and contains(@rend, 'marginOuterLeft')]
						| //tei:metamark[@function='modification' and contains(@rend, 'marginOuterLeft')]
						| //tei:metamark[@function='undefined' and contains(@rend, 'marginOuterLeft')]
                        | //tei:mod[@rendition='#longQuote' and not(@continued) and contains(@rend, 'marginOuterLeft')]
                        | //tei:mod[@rendition='#longQuoteEndCenter' and not(@continued) and contains(@rend, 'marginOuterLeft')]
                        | //tei:mod[@rendition=('#longQuoteStartIndent', '#longQuoteEndIndent',  '#longQuoteIndent', '#verseLine', '#runningText1') and not(@continued) and contains(@rend, 'marginOuterLeft')]
                        | //tei:mod[not(@rendition) and @style='noIndent' and not(@continued) and contains(@rend, 'marginOuterLeft')]
                        | //tei:mod[@rend and not(@rendition) and not(@style='noIndent') and not(@continued) and contains(@rend, 'marginOuterLeft')]" mode="render"/>
                    </div>
                    <div class="body-left-middle col px-0">
                        <xsl:apply-templates select="//tei:add[@rend|parent::tei:subst[@rend]|ancestor::tei:subst[@rend]
                                                    and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(parent::tei:span[ancestor::tei:subst[@rend]])then(ancestor::tei:subst/@rend)else(@rend)), 'marginLeft')]
                        | //tei:del[not(parent::tei:subst) and contains(@rend, 'marginLeft')]
                        | //tei:metamark[@function='progress' and contains(@rend, 'marginLeft')]
                        | //tei:metamark[@function='transposition' and contains(@rend, 'marginLeft')]
                        | //tei:metamark[@function='printInstruction' and contains(@rend, 'marginLeft')]
                        | //tei:metamark[contains (@function, 'printSpan') and (contains(@rend, 'Left'))]
                        | //tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'marginLeft')]
                        | //tei:metamark[@function='insertion' and contains(@rend, 'marginLeft')]
						| //tei:metamark[@function='modification' and contains(@rend, 'marginLeft')]
						| //tei:metamark[@function='undefined' and contains(@rend, 'marginLeft')]
                        | //tei:mod[@rendition='#longQuote' and not(@continued) and contains(@rend, 'marginLeft')]
                        | //tei:mod[@rendition='#longQuoteEndCenter' and not(@continued) and contains(@rend, 'marginLeft')]
                        | //tei:mod[@rendition=('#longQuoteStartIndent', '#longQuoteEndIndent',  '#longQuoteIndent', '#verseLine', '#runningText1') and not(@continued) and contains(@rend, 'marginLeft')]
                        | //tei:mod[not(@rendition) and @style='noIndent' and not(@continued) and contains(@rend, 'marginLeft')]
                        | //tei:mod[@rend and not(@rendition) and not(@style='noIndent') and not(@continued) and contains(@rend, 'marginLeft')]" mode="render"/>
                    </div>
                    <div class="body-left-inner col ps-0 pe-1">
                        <xsl:apply-templates select="//tei:add[@rend|parent::tei:subst[@rend]|ancestor::tei:subst[@rend]
                                                    and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(parent::tei:span[ancestor::tei:subst[@rend]])then(ancestor::tei:subst/@rend)else(@rend)), 'marginInnerLeft')]
                        | //tei:del[not(parent::tei:subst) and contains(@rend, 'marginInnerLeft')]
                        | //tei:metamark[@function='progress' and contains(@rend, 'marginInnerLeft')]
                        | //tei:metamark[@function='transposition' and contains(@rend, 'marginInnerLeft')]
                        | //tei:metamark[@function='printInstruction' and contains(@rend, 'marginInnerLeft')]
                        | //tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'marginInnerLeft')]
                        | //tei:metamark[@function='insertion' and contains(@rend, 'marginInnerLeft')]
						| //tei:metamark[@function='modification' and contains(@rend, 'marginInnerLeft')]
						| //tei:metamark[@function='undefined' and contains(@rend, 'marginInnerLeft')]
                        | //tei:mod[@rendition='#longQuote' and not(@continued) and contains(@rend, 'marginInnerLeft')]
                        | //tei:mod[@rendition='#longQuoteEndCenter' and not(@continued) and contains(@rend, 'marginInnerLeft')]
                        | //tei:mod[@rendition=('#longQuoteCenter', '#longQuoteStartIndent', '#longQuoteEndIndent',  '#longQuoteIndent', '#verseLine', '#runningText1') and not(@continued) and contains(@rend, 'marginInnerLeft')]
                        | //tei:mod[not(@rendition) and @style='noIndent' and not(@continued) and contains(@rend, 'marginInnerLeft')]
                        | //tei:mod[@rend and not(@rendition) and not(@style='noIndent') and not(@continued) and contains(@rend, 'marginInnerLeft')]
                        | //tei:seg[@type='relocation' and @rend='arrow']" mode="render"/>
                    </div>
                </div>
                <div class="body-main">
                    <xsl:apply-templates/>
                </div>
                <div class="body-right row m-0">
                    <div class="body-right-inner col ps-1 pe-0">
                        <xsl:apply-templates select="//tei:add[@rend|parent::tei:subst[@rend]|ancestor::tei:subst[@rend]
                                                    and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(parent::tei:span[ancestor::tei:subst[@rend]])then(ancestor::tei:subst/@rend)else(@rend)), 'marginInnerRight')]
                        | //tei:del[not(parent::tei:subst) and contains(@rend, 'marginInnerRight')]
                        | //tei:metamark[@function='progress' and contains(@rend, 'marginInnerRight')]
                        | //tei:metamark[@function='transposition' and contains(@rend, 'marginInnerRight')]
                        | //tei:metamark[@function='printInstruction' and contains(@rend, 'marginInnerRight')]
                        | //tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'marginInnerRight')]
                        | //tei:metamark[@function='insertion' and contains(@rend, 'marginInnerRight')]
						| //tei:metamark[@function='modification' and contains(@rend, 'marginInnerRight')]
						| //tei:metamark[@function='undefined' and contains(@rend, 'marginInnerRight')]
                        | //tei:mod[@rendition='#longQuote' and not(@continued) and contains(@rend, 'marginInnerRight')]
                        | //tei:mod[@rendition='#longQuoteEndCenter' and not(@continued) and contains(@rend, 'marginInnerRight')]
                        | //tei:mod[@rendition=('#longQuoteStartIndent', '#longQuoteEndIndent',  '#longQuoteIndent', '#verseLine', '#runningText1') and not(@continued) and contains(@rend, 'marginInnerRight')]
                        | //tei:mod[not(@rendition) and @style='noIndent' and not(@continued) and contains(@rend, 'marginInnerRight')]
                        | //tei:mod[@rend and not(@rendition) and not(@style='noIndent') and not(@continued) and contains(@rend, 'marginInnerRight')]" mode="render"/>
                    </div>
                    <div class="body-right-middle col px-0">
                        <xsl:apply-templates select="//tei:add[@rend|parent::tei:subst[@rend]|ancestor::tei:subst[@rend]
                                                    and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(parent::tei:span[ancestor::tei:subst[@rend]])then(ancestor::tei:subst/@rend)else(@rend)), 'marginRight')]
                        | //tei:del[not(parent::tei:subst) and contains(@rend, 'marginRight')]
                        | //tei:metamark[@function='progress' and contains(@rend, 'marginRight')]
                        | //tei:metamark[@function='transposition' and contains(@rend, 'marginRight')]
                        | //tei:metamark[@function='printInstruction' and contains(@rend, 'marginRight')]
                        | //tei:metamark[contains(@function, 'printSpan') and (contains(@rend, 'Right'))]
                        | //tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'marginRight')]
                        | //tei:metamark[@function='insertion' and contains(@rend, 'marginRight')]
						| //tei:metamark[@function='modification' and contains(@rend, 'marginRight')]
						| //tei:metamark[@function='undefined' and contains(@rend, 'marginRight')]
                        | //tei:mod[@rendition='#longQuote' and not(@continued) and contains(@rend, 'marginRight')]
                        | //tei:mod[@rendition='#longQuoteEndCenter' and not(@continued) and contains(@rend, 'marginRight')]
                        | //tei:mod[@rendition=('#longQuoteStartIndent', '#longQuoteEndIndent',  '#longQuoteIndent', '#verseLine', '#runningText1') and not(@continued) and contains(@rend, 'marginRight')]
                        | //tei:mod[not(@rendition) and @style='noIndent' and not(@continued) and contains(@rend, 'marginRight')]
                        | //tei:mod[@rend and not(@rendition) and not(@style='noIndent') and not(@continued) and contains(@rend, 'marginRight')]" mode="render"/>
                    </div>
                    <div class="body-right-outer col px-0">
                        <xsl:apply-templates select="//tei:add[@rend|parent::tei:subst[@rend]|ancestor::tei:subst[@rend]
                                                    and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(parent::tei:span[ancestor::tei:subst[@rend]])then(ancestor::tei:subst/@rend)else(@rend)), 'marginOuterRight')]
                        | //tei:del[not(parent::tei:subst) and contains(@rend, 'marginOuterRight')]
                        | //tei:metamark[@function='progress' and contains(@rend, 'marginOuterRight')]
                        | //tei:metamark[@function='transposition' and contains(@rend, 'marginOuterRight')]
                        | //tei:metamark[@function='printInstruction' and contains(@rend, 'marginOuterRight')]
                        | //tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'marginOuterRight')]
                        | //tei:metamark[@function='insertion' and contains(@rend, 'marginOuterRight')]
						| //tei:metamark[@function='modification' and contains(@rend, 'marginOuterRight')]
						| //tei:metamark[@function='undefined' and contains(@rend, 'marginOuterRight')]
                        | //tei:mod[@rendition='#longQuote' and not(@continued) and contains(@rend, 'marginOuterRight')]
                        | //tei:mod[@rendition='#longQuoteEndCenter' and not(@continued) and contains(@rend, 'marginOuterRight')]
                        | //tei:mod[@rendition=('#longQuoteStartIndent', '#longQuoteEndIndent',  '#longQuoteIndent', '#verseLine', '#runningText1') and not(@continued) and contains(@rend, 'marginOuterRight')]
                        | //tei:mod[not(@rendition) and @style='noIndent' and not(@continued) and contains(@rend, 'marginOuterRight')]
                        | //tei:mod[@rend and not(@rendition) and not(@style='noIndent') and not(@continued) and contains(@rend, 'marginOuterRight')]" mode="render"/>
                    </div>
                    <div class="body-right-outermost col px-0">
                        <xsl:apply-templates select="//tei:add[@rend|parent::tei:subst[@rend]|ancestor::tei:subst[@rend]
                                                    and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(parent::tei:span[ancestor::tei:subst[@rend]])then(ancestor::tei:subst/@rend)else(@rend)), 'marginOutermostRight')]
                        | //tei:del[not(parent::tei:subst) and contains(@rend, 'marginOutermostRight')]
                        | //tei:metamark[@function='progress' and contains(@rend, 'marginOutermostRight')]
                        | //tei:metamark[@function='transposition' and contains(@rend, 'marginOutermostRight')]
                        | //tei:metamark[@function='printInstruction' and contains(@rend, 'marginOutermostRight')]
                        | //tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'marginOutermostRight')]
                        | //tei:metamark[@function='insertion' and contains(@rend, 'marginOutermostRight')]
						| //tei:metamark[@function='modification' and contains(@rend, 'marginOutermostRight')]
						| //tei:metamark[@function='undefined' and contains(@rend, 'marginOutermostRight')]
                        | //tei:mod[@rendition='#longQuote' and not(@continued) and contains(@rend, 'marginOutermostRight')]
                        | //tei:mod[@rendition='#longQuoteEndCenter' and not(@continued) and contains(@rend, 'marginOutermostRight')]
                        | //tei:mod[@rendition=('#longQuoteStartIndent', '#longQuoteEndIndent',  '#longQuoteIndent', '#verseLine', '#runningText1') and not(@continued) and contains(@rend, 'marginOutermostRight')]
                        | //tei:mod[not(@rendition) and @style='noIndent' and not(@continued) and contains(@rend, 'marginOutermostRight')]
                        | //tei:mod[@rend and not(@rendition) and not(@style='noIndent') and not(@continued) and contains(@rend, 'marginOutermostRight')]" mode="render"/>
                    </div>
                </div>
            </div>
            <div class="print-footer {$printType} zindex-99">
                <!-- <xsl:apply-templates select="//tei:note[contains(@place, 'bottom')]" mode="render"/> -->
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:p[@n]">
        <div id="{local:makeId(.)}" data-hand="{replace(@change, '#', '')}" class="yes-index {if(self::tei:p)then(replace(@rendition,'#',''))else()}{if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}">
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
        <span class="comments" data-anchor="{@xml:id}"></span>
    </xsl:template>
    <xsl:template match="tei:fw">
        <span style="z-index:1;" class="fw {replace(@change,'#','')} {replace(@rendition,'#','')} {@place}" data-hand="fw-{replace(@change,'#','')} {replace(@change,'#','')}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:app">
        <!-- <xsl:variable name="inheritIDfromNote" select="
            if(ancestor::tei:note)
            then(ancestor::tei:note/@xml:id)
            else()"/>
        <xsl:variable name="inheritChangefromNote" select="
            if(ancestor::tei:note)
            then(ancestor::tei:note/@change)
            else()"/>
        <span class="hidden">
            <xsl:if test="ancestor::tei:note/@xml:id">
            <xsl:attribute name="data-anchor">
                <xsl:text> </xsl:text>
                <xsl:value-of select="$inheritIDfromNote"/>
            </xsl:attribute>
            </xsl:if>
            <xsl:if test="ancestor::tei:note/@change">
            <xsl:attribute name="data-hand">
                <xsl:text> </xsl:text>
                <xsl:value-of select="replace($inheritChangefromNote, '#', '')"/>
            </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span> -->
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:lg">
        <span class="d-block lg {replace(@rendition,'#','')}"><xsl:apply-templates/></span>      
    </xsl:template>
    <xsl:template match="tei:l">
		<xsl:choose>
			<xsl:when test="ancestor::tei:mod[@rendition=('#longQuoteVerseStart', '#longQuoteVerseEnd')]">
				<span style="margin-left: -0.5em;" class="d-block l {@style}"><span class="{replace(ancestor::tei:mod/@change, '#', '')}">[ </span><span data-hand="{replace(ancestor::tei:mod/@change, '#', '')}" class="inline-text"><xsl:apply-templates/></span></span>
			</xsl:when>
			<xsl:otherwise>
			    <span class="d-block l {@style}"><span class="inline-text"><xsl:apply-templates/></span></span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    <xsl:template match="tei:quote">
        <span class="quotes {substring-after(@rendition, '#')} {substring-after(@change, '#')}" data-anchor="{@xml:id}" data-hand="{substring-after(@change, '#')}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:rs[@type=('person','personGroup')]">
        <span class="persons {substring-after(@rendition, '#')}">
            <xsl:attribute name="data-anchor">
                <xsl:choose>
                    <xsl:when test="parent::tei:del">
                        <xsl:value-of select="concat(@xml:id, ' ', parent::tei:del/@xml:id)"/>
                    </xsl:when>
                    <xsl:when test="parent::tei:add">
                        <xsl:choose>
                            <xsl:when test="preceding-sibling::tei:del[1]">
                                <xsl:value-of select="concat(@xml:id, ' ', preceding-sibling::tei:del[1]/@xml:id)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(@xml:id, ' ', parent::tei:add/preceding-sibling::tei:del[1]/@xml:id)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@xml:id"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:rdg[@source='F890']"/>
    <xsl:template match="tei:rdg[@source='DW']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:hi[@rendition='#inkOnProof_KK_spc' or @rendition='#typescriptSpc' or @style='letterSpacing']">
        <xsl:variable name="anchor" select="if(ancestor::tei:note)then(ancestor::tei:note/@xml:id)else()"/>
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span data-hand="{replace(@change, '#', '')}" class="spacing underline {replace(@change, '#', '')}">
                    <span class="underline-crossed-out">
                        <xsl:if test="$anchor">
                            <xsl:attribute name="data-anchor">
                                <xsl:value-of select="$anchor"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates/>
                    </span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span data-hand="{replace(@change, '#', '')}" class="spacing {replace(@change, '#', '')}">
                    <xsl:if test="$anchor">
                        <xsl:attribute name="data-anchor">
                            <xsl:value-of select="$anchor"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:hi[@style='underline']">
        <xsl:variable name="anchor" select="if(ancestor::tei:note)then(ancestor::tei:note/@xml:id)else()"/>
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="underline {replace(@change, '#', '')}">
                    <span data-hand="{replace(@change, '#', '')}" class="underline-wavy">
                        <xsl:if test="$anchor">
                            <xsl:attribute name="data-anchor">
                                <xsl:value-of select="$anchor"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates/>
                    </span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span data-hand="{replace(@change, '#', '')}" class="underline {replace(@change, '#', '')}">
                    <xsl:if test="$anchor">
                        <xsl:attribute name="data-anchor">
                            <xsl:value-of select="$anchor"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
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
            <span data-hand="{replace(@change, '#', '')}" class="inline-text"><xsl:apply-templates/></span>
        </span>
    </xsl:template>
    <xsl:template match="tei:c[@resp='#edACE']"/>
    <xsl:template match="tei:c[not(@resp='#edACE')]">
        <xsl:value-of select="'&#x2060;&#x2009;&#x2060;'"/>
    </xsl:template>
	
    <!-- SIC/CORR TEST
	<xsl:template match="tei:choice[child::tei:corr[@type='comment']]">
        <xsl:apply-templates select="tei:sic" mode="render"/>
        <xsl:apply-templates select="tei:corr" mode="render"/>
    </xsl:template>
    <xsl:template match="tei:choice[not(child::tei:corr[@type='comment'])]">
        <span><xsl:apply-templates /></span>
    </xsl:template>
    <xsl:template match="tei:corr">
        <xsl:for-each select="tei:add">
            <span class="add connect entity {replace(@change[1], '#', '')}" id="{@xml:id}">
            </span>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:sic">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:sic" mode="render">
        <xsl:apply-templates/>
    </xsl:template>
	INSTEAD SIMPLY: -->
	<xsl:template match="tei:sic">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tei:corr"/>
	
     <xsl:template match="tei:anchor[@type='metamark']">
        <span class="anchor {replace((@change)[1], '#', '')}" data-anchor="{@xml:id}" data-hand="{replace((@change)[1], '#', '')}"></span>
     </xsl:template>
    <xsl:template match="tei:restore">
        <span class="restore {replace((@change)[1], '#', '')}" data-anchor="{@xml:id}" data-hand="{replace((@change)[1], '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:subst">
        <xsl:variable name="rend" select="if(@rend)then(@rend)else(if(tei:del[@rend])then(tei:del/@rend)else(tei:add/@rend))"/>
        <span data-hand="{replace((@change)[1], '#', '')}" class="subst {if($rend='overwritten')then('overwrittenAnchor')else()} {replace((@change)[1], '#', '')}{if(child::*[$rend='overwritten'])then(' position-relative')else()}"><xsl:apply-templates/></span>
    </xsl:template>
    
    <!-- <xsl:template match="tei:ptr[parent::tei:transpose]">
    <xsl:variable name="target" select="replace(@target,'#','')"/>
    <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//tei:seg[@xml:id=$target]" mode="render"/>
    </xsl:template> -->
    <xsl:template match="tei:note">
        <span class="note d-block text-align-left {if(@place)then(concat(@place, ' position-absolute'))else()} {replace(@change,'#','')}">
            <xsl:if test="not(contains(preceding::tei:pb/@n, '_'))">
                <xsl:attribute name="data-hand">
                    <xsl:value-of select="replace(@change,'#','')"/>
                </xsl:attribute>
                <xsl:attribute name="data-anchor">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- <xsl:template match="tei:lb[@type='req']">
        <br/>
    </xsl:template> -->
    <xsl:template match="tei:lb[@n='first']"/>
    <xsl:template match="tei:lb[@n='firstLast']"/>
    
	<xsl:template match="tei:lb[@n='last' or not(@n)]">
		<xsl:choose>
			<xsl:when test="@break and not(@type='noHyphen')">
				<xsl:text>-</xsl:text><br/>
			</xsl:when>
			<xsl:when test="@type='forced'">
				<br class="forced"/>
			</xsl:when>
			<xsl:when test="@type='forcedRight'">
				<br class="forcedRight"/>
			</xsl:when>
			<xsl:otherwise>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>
	
    <xsl:template match="tei:span[@n='last']">
        <xsl:choose>
            <xsl:when test="not(child::node())">
                <!-- empty span: do nothing -->
            </xsl:when>
            <xsl:when test="ancestor::tei:del or parent::tei:del or preceding-sibling::*[1]/local-name() = ('del', 'add')">
                <span class="d-table-row {if(ancestor::tei:p[contains(@rendition, 'Center') or contains(@rendition, 'center')])then()else('text-align-left')} no-indent"><xsl:if test="starts-with(string(.), ' ')"><xsl:text>&#160;</xsl:text></xsl:if><xsl:apply-templates/></span>
            </xsl:when>
            <!-- <xsl:when test="preceding-sibling::*[1][@n='last']/local-name() = 'span'">
                <span class="d-table-row text-align-left no-indent">&#160;<xsl:apply-templates/></span>
            </xsl:when> -->
            <xsl:when test="preceding-sibling::tei:lb[1][@type='forced']">
				<span class="d-inline-block text-align-left lb-forced"><xsl:apply-templates/></span>
			</xsl:when>
			<xsl:when test="preceding-sibling::tei:lb[1][@type='forcedRight']">
				<span class="d-inline-block text-align-left lb-forced-right"><xsl:apply-templates/></span>
			</xsl:when>
			<xsl:when test="preceding-sibling::tei:lb[1][@type='forcedRight2']">
				<span class="d-inline-block text-align-left lb-forced-right2"><xsl:apply-templates/></span>
			</xsl:when>
			<xsl:otherwise>
                <span class="d-inline-block {if(ancestor::tei:p[contains(@rendition, 'Center') or contains(@rendition, 'center')])then()else('text-align-left')} no-indent">
                    <xsl:attribute name="data-anchor">
                        <xsl:value-of select="@xml:id"/>
                        <xsl:if test="parent::tei:metamark[@xml:id]">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="parent::tei:metamark/@xml:id"/>
                        </xsl:if>
                        <xsl:if test="parent::tei:metamark[@corresp]">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="for $i in tokenize(parent::tei:metamark/@corresp, ' ') return substring-after($i, '#')"/>
                        </xsl:if>
                        <xsl:if test="parent::tei:metamark[@spanTo]">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="for $i in tokenize(parent::tei:metamark/@spanTo, ' ') return substring-after($i, '#')"/>
                        </xsl:if>
                        <xsl:if test="ancestor::tei:note">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="ancestor::tei:note/@xml:id"/>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:span[@n='firstLast']">
        <xsl:choose>
            <xsl:when test="not(child::node())">
                <!-- empty span: do nothing -->
            </xsl:when>
            <xsl:when test="ancestor::tei:del or parent::tei:del or preceding-sibling::*[1]/local-name() = ('del', 'add')">
                <span class="d-table-row {if(ancestor::tei:p[contains(@rendition, 'Center') or contains(@rendition, 'center')])then()else('text-align-left')} no-indent">&#160;<xsl:apply-templates/></span>
            </xsl:when>
            <!-- <xsl:when test="preceding-sibling::*[1][@n='last']/local-name() = 'span'">
                <span class="d-table-row text-align-left no-indent">&#160;<xsl:apply-templates/></span>
            </xsl:when> -->
            <xsl:otherwise>
                <span class="d-inline-block {if(ancestor::tei:p[contains(@rendition, 'Center') or contains(@rendition, 'center')])then()else('text-align-left')} no-indent">
                    <xsl:attribute name="data-anchor">
                        <xsl:value-of select="@xml:id"/>
                        <xsl:if test="parent::tei:metamark[@xml:id]">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="parent::tei:metamark/@xml:id"/>
                        </xsl:if>
                        <xsl:if test="parent::tei:metamark[@corresp]">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="for $i in tokenize(parent::tei:metamark/@corresp, ' ') return substring-after($i, '#')"/>
                        </xsl:if>
                        <xsl:if test="parent::tei:metamark[@spanTo]">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="for $i in tokenize(parent::tei:metamark/@spanTo, ' ') return substring-after($i, '#')"/>
                        </xsl:if>
                        <xsl:if test="ancestor::tei:note">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="ancestor::tei:note/@xml:id"/>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:if test="parent::tei:seg[@rend='arrow'] and parent::tei:seg[@xml:id='seg0111_01']">
                        <span id="{parent::tei:seg/@xml:id}" class="seg entity seg-inline">
                            <span data-hand="{replace(parent::tei:seg/@change, '#', '')}" class="{parent::tei:seg/@rend} {replace(parent::tei:seg/@change, '#', '')}">
                                <xsl:attribute name="data-anchor">
                                    <xsl:value-of select="@xml:id"/>
                                    <xsl:if test="parent::tei:metamark[@xml:id]">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="parent::tei:metamark/@xml:id"/>
                                    </xsl:if>
                                    <xsl:if test="parent::tei:metamark[@corresp]">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="for $i in tokenize(parent::tei:metamark/@corresp, ' ') return substring-after($i, '#')"/>
                                    </xsl:if>
                                    <xsl:if test="parent::tei:metamark[@spanTo]">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="for $i in tokenize(parent::tei:metamark/@spanTo, ' ') return substring-after($i, '#')"/>
                                    </xsl:if>
                                    <xsl:if test="parent::tei:seg[@xml:id]">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="parent::tei:seg/@xml:id"/>
                                    </xsl:if>
                                    <xsl:if test="ancestor::tei:note">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="ancestor::tei:note/@xml:id"/>
                                    </xsl:if>
                                </xsl:attribute>
                                <xsl:text>&#8592;</xsl:text>
                            </span>
                        </span>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="parent::tei:mod[@rendition=('#longQuoteStartIndent', '#longQuoteEndIndent',  '#longQuoteIndent')]">
                            <span style="margin-left: -0.5em;"><span data-hand="{replace(parent::tei:mod/@change, '#', '')}" class="mod quote-indent {replace(parent::tei:mod/@change, '#', '')}">[ </span><xsl:apply-templates/></span>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:span[not(@n)]">
        <xsl:choose>
            <xsl:when test="child::tei:*">
                <span>
                    <xsl:if test="@style">
                        <xsl:attribute name="class">
                            <xsl:value-of select="@style"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="string-length(normalize-space(.)) > 0">
                <span>
                    <xsl:if test="@style">
                        <xsl:attribute name="class">
                            <xsl:value-of select="@style"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(.)"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <!-- do not render empty elements -->
            </xsl:otherwise>
        </xsl:choose>
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
        <xsl:variable name="inheritIDfromAddDel" select="
            if(ancestor::tei:add)
            then(
                if(ancestor::tei:add/preceding-sibling::tei:del)
                    then(ancestor::tei:add/preceding-sibling::tei:del/@xml:id)
                else if(ancestor::tei:add/following-sibling::tei:del)
                    then(ancestor::tei:add/following-sibling::tei:del/@xml:id)
                else()
            )
            else()"/>
        <xsl:variable name="inheritIDfromNote" select="
            if(ancestor::tei:note)
            then(ancestor::tei:note/@xml:id)
            else()"/>
        <span class="unclear">
            <xsl:if test="parent::tei:del/@xml:id">
            <xsl:attribute name="data-anchor">
                <xsl:value-of select="parent::tei:del/@xml:id"/>
                <xsl:if test="ancestor::tei:add">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$inheritIDfromAddDel"/>
                </xsl:if>
                <xsl:if test="ancestor::tei:note">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$inheritIDfromNote"/>
                </xsl:if>
            </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:citedRange" mode="typo_short_info">
        <xsl:param name="printType" select="'fackel'"/>
        <xsl:param name="datalink" select="'false'"/>
        <span class="d-inline-block fs-6 ps-3 text-dark-grey quote_signet_background bg-no-repeat bg-position-short-info">
            <xsl:if test="$datalink != 'false'">
            <xsl:attribute name="data-linkone">
                <xsl:value-of select="$datalink"/>
            </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$printType='fackel'">
                    <xsl:text>Die Fackel Nr. 890-905, hier </xsl:text>
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <b><i><xsl:value-of select="preceding-sibling::tei:title[@type='short']"/></i></b><xsl:value-of select="concat(' vom ', preceding-sibling::tei:date/text()[1], ', ')"/><xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
            <a class="text-dark-grey text-decoration-none text-wpn-quote-hover" href="{./tei:ref[@type='ext']/@target}">
                <xsl:choose>
                    <xsl:when test="$printType='fackel'">
                        <xsl:attribute name="href">
                            <xsl:value-of select="./tei:ref[@type='ext']/@target"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat('register_intertexte.html', '#', parent::tei:bibl/@xml:id)"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="icon">
                    <xsl:with-param name="icon_name" select="'expand_info'"/>
                </xsl:call-template>
            </a>
        </span>
    </xsl:template>
</xsl:stylesheet>
