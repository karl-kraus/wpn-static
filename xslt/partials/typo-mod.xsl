<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:mod[@n]">
        <div id="{local:makeId(.)}" class="yes-index {if(self::tei:p)then(replace(@rendition,'#',''))else()}{if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}">
            <xsl:if test="@rendition='#runningText1'">
                <span class="mod connect entity no-indent position-relative {@style} {replace(@change, '#', '')}" id="{@xml:id}">
                    <span class="mod-inline position-absolute" style="left: -0.5em; top: 0.2em;">
                        <xsl:if test="not(@continued)">
                            <xsl:choose>
                                <xsl:when test="ancestor::tei:restore">
                                  <del>[</del>
                                </xsl:when>
                                <xsl:otherwise>
                                  <span>[</span>
                                </xsl:otherwise>
                             </xsl:choose>
                        </xsl:if>
                    </span>
                </span>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:mod[@rendition='#longQuoteVerseRightAlign' and @rend='inlineArrows']">
		<span class="mod inline-arrows {replace(@change, '#', '')}" id="{@xml:id}"><span style="margin-left: -0.5rem;">&#8594;</span><xsl:apply-templates/><span>&#8594;</span></span>
	</xsl:template>
    
    <xsl:template match="tei:mod[@style='noLetterSpacing']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="mod underline {@style} {replace(@change, '#', '')}">
                    <span class="underline-wavy"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="mod underline {@style} {replace(@change, '#', '')}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@style='letterSpacing']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="mod underline {@style} {replace(@change, '#', '')}">
                    <span class="underline-wavy"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="mod underline {@style} {replace(@change, '#', '')}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@style='indent2']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="mod underline {@style} {replace(@change, '#', '')}">
                    <span class="underline-wavy"><xsl:apply-templates/> <span style="font-size:1.25em;">&#8594;</span></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="mod {@style} {replace(@change, '#', '')}">
                    <xsl:apply-templates/> <span style="font-size:1.25em;">&#8594;</span>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@style='noIndent']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span id="{@xml:id}" class="mod underline connect entity {@style} {replace(@change, '#', '')}">
                    <span class="underline-wavy"><span style="font-size:1.25em;">&#8592;</span> <xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span id="{@xml:id}" class="mod connect entity {@style} {replace(@change, '#', '')}">
                    <span style="font-size:1.25em; margin-right: 1em;">&#8592;</span> <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@style='noUnderline']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="mod underline {@style} {replace(@change, '#', '')}">
                    <span class="underline-wavy"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="mod {@style} {replace(@change, '#', '')}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@style='italic']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="mod underline {@style} {replace(@change, '#', '')}">
                    <span class="underline-wavy"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="mod underline {@style} {replace(@change, '#', '')}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition='#rightAlignSmall']">
        <span class="mod {@style} {replace(@change, '#', '')} longQuoteRightAlign my-05 d-block"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[contains(@rendition,'Quote') and not(@resp='#edACE')]">
        <xsl:choose>
            <xsl:when test="@rendition=('#longQuoteStartIndent', '#longQuoteEndIndent',  '#longQuoteIndent') and not(child::tei:span[@n='firstLast'])">
                <span class="mod connect entity {@style} {replace(@change, '#', '')}" id="{@xml:id}"
                    style="margin-left: -0.5em;">
                    <span>[ </span><xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="mod connect entity {@style} {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition=('#runningText1') and not(@n)]">
        <span class="mod connect entity no-indent position-relative {@style} {replace(@change, '#', '')}" id="{@xml:id}">
            <span class="mod-inline position-absolute" style="left: -0.5em; top: 0.2em;">
                <xsl:if test="not(@continued)">
                            <xsl:choose>
                                <xsl:when test="ancestor::tei:restore">
                                  <del>[</del>
                                </xsl:when>
                                <xsl:otherwise>
                                  <span>[</span>
                                </xsl:otherwise>
                             </xsl:choose>
                        </xsl:if>
                 <xsl:apply-templates/>
            </span>
        </span>
    </xsl:template>
	<xsl:template match="tei:mod[@rendition='#verseLine' and not(@resp='#edACE') and not(@rend='none')]">
		<span class="mod connect entity no-indent position-relative {replace(@change, '#', '')}" id="{@xml:id}">
            <span class="mod-inline {replace(@change, '#', '')}"><span>[</span><xsl:apply-templates/></span>
		</span>
	</xsl:template>


    <!-- container element -->
    <xsl:template match="tei:mod[@rendition='#longQuote' and not(@continued)]" mode="render">
        <div class="d-flex position-relative" data-xmlid="{@xml:id}">
            <div class="mod connect {@rend} {replace(@change,'#','')}">
                <span>&#124;</span>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition='#longQuoteEndCenter' and not(@continued)]" mode="render">
        <div class="d-flex position-relative" data-xmlid="{@xml:id}">
            <div class="mod connect {@rend} {replace(@change,'#','')}">
                <span>&#8594;</span>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:mod[not(@rendition) and @style='noIndent' and not(@continued)]" mode="render">
        <div class="d-flex position-relative" data-xmlid="{@xml:id}">
            <div id="container-{@xml:id}" class="mod connect {@rend} {replace(@change,'#','')}">
                <div><span>&#8592;</span></div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition=('#longQuoteStartIndent', '#longQuoteEndIndent',  '#longQuoteIndent', '#runningText1', '#verseLine') and not(@continued)]" mode="render">
        <div class="d-flex position-relative" data-xmlid="{@xml:id}">
            <div id="container-{@xml:id}" class="mod connect {@rend} {replace(@change,'#','')}">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:restore">
                      <del><span>[</span></del>
                    </xsl:when>
                    <xsl:otherwise>
                      <div><span>[</span></div>
                    </xsl:otherwise>
              </xsl:choose>
            </div>
        </div>
    </xsl:template>
    
    <!-- <xsl:template match="tei:mod[@change='#pencilOnProof_KK'][not(@rendition='#pencilOnProof_rightAlignSmall')]"/> -->

</xsl:stylesheet>
