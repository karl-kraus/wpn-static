<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:preserve-space elements="*" />
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/aot-options.xsl"/>
    <xsl:import href="./partials/short-infos.xsl"/>

    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"/>
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
        <html class="h-100" id="edition-view">
            <body id="main_grid" class="h-100">
                <main class="flex-shrink-0 mt-18">
                    <div class="container-fluid px-0">
                        <div>
                            <xsl:apply-templates/>
                        </div>
                    </div>
                    <xsl:for-each select="//tei:back">
                        <div class="tei-back">
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                </main>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:p[parent::tei:TEI]|tei:mod[parent::tei:TEI]">
        <div id="{local:makeId(.)}" class="yes-index {replace(@rendition,'#','')}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:p">
        <p id="{local:makeId(.)}" class="yes-index {replace(@rendition,'#','')}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{local:makeId(.)}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:pb"/>
    <xsl:template match="tei:fw"/>
    <xsl:template match="tei:mod[@change='#pencilOnProof_KK'][not(@rendition='#pencilOnProof_rightAlignSmall')]"/>
    <xsl:template match="tei:app">
        <span class="hidden"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:lg">
        <span class="d-block lg {replace(@rendition,'#','')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:l">
        <span class="d-block l"><xsl:apply-templates/></span>
	</xsl:template>
    <xsl:template match="tei:seg[@type='F890']">
        <span class="fackelrefs entity {substring-after(@rendition, '#')}" id="{@xml:id}" data-bs-toggle="modal" data-bs-target="{@ref}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:quote">
        <span class="quotes entity {substring-after(@rendition, '#')}" id="{@xml:id}" data-bs-toggle="modal" data-bs-target="{@ref}">
            <xsl:apply-templates/>
        </span>
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
</xsl:stylesheet>
