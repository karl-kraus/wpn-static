<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:mod[@style=('noLetterSpacing') and not(parent::tei:restore)]">
        <span class="mod {@style} underline {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@style=('letterSpacing') and not(parent::tei:restore)]">
        <span class="mod {@style} underline {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@style='indent2']">
        <span class="mod {@style} {replace(@rendition,'#','')} {replace(@change, '#', '')}"><xsl:apply-templates/> <span style="font-size:1.25em;">&#8594;</span></span>
    </xsl:template>
    <xsl:template match="tei:mod[@style='noIndent']">
        <span id="{@xml:id}" class="mod connect entity {@style} {replace(@rendition,'#','')} {replace(@change, '#', '')}"><span style="font-size:1.25em;">&#8592;</span> <xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@style='noUnderline']">
        <span class="mod {@style} {replace(@rendition,'#','')} {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@style='italic']">
        <span class="mod {@style} underline {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition='#rightAlignSmall']">
        <span class="mod {@style} {replace(@change, '#', '')} longQuoteRightAlign my-05 d-block"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[contains(@rendition,'Quote')]">
        <span class="mod connect entity {@style} {replace(@rendition,'#','')} {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
    </xsl:template>
    <!-- container element -->
    <xsl:template match="tei:mod[@rendition='#longQuote' and contains(@rend, 'Right')]" mode="render">
        <div class="d-flex ms-1" data-xmlid="{@xml:id}">
            <div class="mod connect {@rend} {replace(@change,'#','')}" id="container-{@xml:id}"><span style="font-size:1.25em;">&#124;</span></div>
        </div>
     </xsl:template>
     <xsl:template match="tei:mod[@rendition='#longQuote' and contains(@rend, 'Left')]" mode="render">
        <div class="d-flex ms-1" data-xmlid="{@xml:id}">
            <div class="mod connect {@rend} {replace(@change,'#','')}" id="container-{@xml:id}"><span style="font-size:1.25em;">&#124;</span></div>
        </div>
     </xsl:template>
     <xsl:template match="tei:mod[not(@rendition) and @style='noIndent' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="mod connect ms-1 {@rend} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div><span>&#8592;</span></div>
        </div>
     </xsl:template>
     <xsl:template match="tei:mod[not(@rendition) and @style='noIndent' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="mod connect ms-1 {@rend} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div><span>&#8592;</span></div>
        </div>
     </xsl:template>
    <xsl:template match="tei:mod[@rendition='#runningText1']">
        <span class="mod connect entity no-indent {@style} {replace(@rendition,'#','')} {replace(@change, '#', '')}" id="{@xml:id}">
            <span class="mod mod-inline"><span>[</span></span>
            <xsl:apply-templates/>
        </span>
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
    
    <!-- <xsl:template match="tei:mod[@change='#pencilOnProof_KK'][not(@rendition='#pencilOnProof_rightAlignSmall')]"/> -->

</stylesheet>