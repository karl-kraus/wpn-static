<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    version="2.0" exclude-result-prefixes="xsl tei xs local wpn">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:preserve-space elements="*" />
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/aot-options.xsl"/>
    <xsl:import href="./partials/short-infos.xsl"/>
    <xsl:import href="./partials/wpn_utils.xsl"/>

    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>
    <xsl:template match="/">
        <html class="h-100" id="edition-view">
            <body id="main_grid" class="h-100"  data-teiid="{$teiSource}" data-label="{wpn:parse-page-name(replace($teiSource,'absatz_',''),'label')}">
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
    <xsl:template match="tei:app[not(@prev)][not(@next)]">
        <wpn-entity class="apps fackel entity" id="{@xml:id}">
            <xsl:apply-templates/>
        </wpn-entity>
    </xsl:template>
    <xsl:template match="tei:quote">
        <span class="quotes entity {substring-after(@rendition, '#')}" id="{@xml:id}" data-bs-toggle="modal" data-bs-target="{@ref}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:rs[@type=('person','personGroup')]">
        <span id="{@xml:id}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
     <xsl:template match="tei:ref[@type=('comment','glossary','event')]">
        <span class="comments entity" id="{@xml:id}"></span>
    </xsl:template>
    <xsl:template match="tei:rdg[@source='F890']"/>
    <xsl:template match="tei:rdg[@source='DW']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[ancestor::tei:restore[1][child::seg]]"/>
    <xsl:template match="tei:del[ancestor::tei:restore[1][not(child::seg)]]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[not(ancestor::tei:restore)][not(ancestor::tei:restore[ancestor::tei:restore[child::tei:seg]])]"/>
    <xsl:template match="tei:hi[@rendition='#inkOnProof_KK_spc' or @rendition='#typescriptSpc' or @style='letter-spacing: 0.1em;']">
        <span><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition='#rightAlignSmall']">
        <span><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@rendition='#runningText1']">
        <span><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:choice[child::tei:corr[@type='comment']]">
        <xsl:apply-templates select="tei:sic" mode="render"/>
    </xsl:template>
    <xsl:template match="tei:choice[not(child::tei:corr[@type='comment'])]">
        <xsl:apply-templates select="tei:corr"/>
    </xsl:template>
    <xsl:template match="tei:p[not(@n)]">
            <span><xsl:apply-templates/></span>
    </xsl:template>
        <xsl:template match="tei:c[@type='nnbsp']">
        <span><xsl:value-of select="'&#x2060;&#x2009;&#x2060;'"/></span>
    </xsl:template>
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
    <xsl:template match="tei:metamark[@function=('insertion','relocation') and not(matches(@target,'(note)+.*([a-z])_'))]">
       <xsl:variable name="target" select="replace(@target,'#','')"/>
        <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//(tei:seg|tei:note)[@xml:id=$target]" mode="render"/>
    </xsl:template>
    <xsl:template match="tei:metamark[@function=('insertion') and matches(@target,'(note)+.*([a-z])_')]">
       <xsl:choose>
        <xsl:when test="contains(@target,' ')">
            <xsl:for-each select="tokenize(@target,' ')">
                <xsl:variable name="target" select="replace(current(),'#','')"/>
                <span>
                    <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//tei:note[@xml:id=$target]" mode="render"/>
                </span>
            </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="target" select="replace(@target,'#','')"/>
            <span>
                <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//tei:note[@xml:id=$target]" mode="render"/>
            </span>
        </xsl:otherwise>
       </xsl:choose>
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
    <xsl:template match="tei:lb[not(@break)][not(@type)]"><xsl:text> </xsl:text></xsl:template>
    <xsl:template match="text()">
    <xsl:value-of 
     select="translate(.,'&#xA;&#x9;','')"/>
  </xsl:template>
</xsl:stylesheet>
