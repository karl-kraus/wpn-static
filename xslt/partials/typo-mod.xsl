<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:mod[@n and parent::tei:p[@rendition='#runningText2']]">
        <div id="{local:makeId(.)}" class="yes-index {if(self::tei:p)then(replace(@rendition,'#',''))else()}{if(@prev)then(' no-indent')else()}">
            <xsl:if test="@rendition='#runningText1'">
                <span id="{@xml:id}" class="mod entity no-indent position-relative {@style} {replace(@change, '#', '')}">
                    <span class="mod-inline position-absolute" style="left: -0.5em; top: 0.2em;">
                        <xsl:if test="not(@continued)">
                            <xsl:choose>
                                <xsl:when test="ancestor::tei:restore">
                                  <del data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">[</del>
                                </xsl:when>
                                <xsl:otherwise>
                                  <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">[</span>
                                </xsl:otherwise>
                             </xsl:choose>
                        </xsl:if>
                    </span>
                </span>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

	<xsl:template match="tei:mod[@rend and not(@rendition)]">
        <span id="{@xml:id}" class="mod entity {@style} {replace(@change, '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
	
    <xsl:template match="tei:mod[@style='noLetterSpacing']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="mod underline {@style} {replace(@change, '#', '')}">
                    <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="underline-wavy"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="mod underline {@style} {replace(@change, '#', '')}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@style='letterSpacing']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="mod underline {@style} {replace(@change, '#', '')}">
                    <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="underline-wavy"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="mod underline {@style} {replace(@change, '#', '')}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@style='indent2' and @rend='arrow']">
		<xsl:apply-templates/>
		<span id="{@xml:id}" class="mod entity {@style} {@rend} {replace(@change, '#', '')}">
			<span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" style="font-size:1.25em;"><xsl:text>&#8594;</xsl:text></span>
		</span>
    </xsl:template>
    <xsl:template match="tei:mod[@style='noIndent']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span id="{@xml:id}" class="mod entity underline {@style} {replace(@change, '#', '')}">
                    <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="underline-wavy"><span style="font-size:1.25em;"><xsl:text>&#8594;</xsl:text></span> <xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span id="{@xml:id}" class="mod entity {@style} {replace(@change, '#', '')}">
                    <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" style="margin-right: 1em;"><xsl:text>&#8592;</xsl:text></span>
				</span>
				<xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@style='noUnderline']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="mod underline {@style} {replace(@change, '#', '')}">
                    <span data-hand="{replace(@change,'#','')}" class="underline-wavy"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span data-hand="{replace(@change,'#','')}" class="mod {@style} {replace(@change, '#', '')}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@style='italic']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="mod underline {@style} {replace(@change, '#', '')}">
                    <span data-hand="{replace(@change,'#','')}" class="underline-wavy"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span data-hand="{replace(@change,'#','')}" class="mod underline {@style} {replace(@change, '#', '')}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition='#rightAlignSmall']">
        <span data-hand="{replace(@change,'#','')}" class="mod {@style} {replace(@change, '#', '')} longQuoteRightAlign my-05 d-block"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:mod[contains(@rendition,'Quote') and not(@resp='#edACE')]">
        <xsl:choose>
            <xsl:when test="@rendition=('#longQuoteStartIndent', '#longQuoteEndIndent',  '#longQuoteIndent', '#longQuoteVerseStart', '#longQuoteVerseEnd') and not(child::tei:span[@n='firstLast'])">
                <span id="{@xml:id}" class="mod entity quote-indent {@style} {replace(@change, '#', '')}" 
                    style="margin-left: -0.25rem; top: 0.2em;">
                    <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">[</span>
                </span>
				<xsl:apply-templates/>
            </xsl:when>
			<xsl:when test="@rendition='#longQuote'">
				<xsl:choose>
					<xsl:when test="@rend='line'">
						<span id="{@xml:id}" class="mod line entity {replace(@change, '#', '')}"  data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>&#124;</xsl:text></span><xsl:apply-templates/>
					</xsl:when>
					<xsl:otherwise>
						<span id="{@xml:id}" class="mod border entity {replace(@change, '#', '')}"  data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
							<xsl:apply-templates/>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@rendition='#longQuoteEndCenter'">
				<span id="{@xml:id}" class="mod entity {@style} {replace(@change, '#', '')}" data-anchor="{@xml:id}"></span>
				<xsl:apply-templates/>
			</xsl:when>
            <xsl:otherwise>
                <!-- <span class="mod entity {@style} {replace(@change, '#', '')}" data-anchor="{@xml:id}"></span> -->
				<xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition=('#runningText1') and not(@n)]">
        <span id="{@xml:id}" class="mod entity no-indent position-relative {@style} {replace(@change, '#', '')}">
            <span class="mod-inline position-absolute" style="left: -0.5em; top: 0.2em;">
                <xsl:if test="not(@continued)">
                    <xsl:choose>
                        <xsl:when test="ancestor::tei:restore">
                            <del data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>[&#160;</xsl:text></del>
                        </xsl:when>
                        <xsl:otherwise>
                            <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>[&#160;</xsl:text></span>
                        </xsl:otherwise>
                        </xsl:choose>
                </xsl:if>
            </span>		
        	<xsl:apply-templates/>
        </span>
    </xsl:template>
	 <xsl:template match="tei:mod[@rendition=('#runningText1') and @n and not(parent::tei:p[@rendition='#runningText2'])]">
        <span id="{@xml:id}" class="mod entity running-text-1 no-indent position-relative {replace(@change, '#', '')}">
            <span class="mod-inline {replace(@change, '#', '')}">
                <xsl:if test="not(@continued)">
                    <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>[</xsl:text></span>
                </xsl:if>
            </span>
		</span>
		<xsl:apply-templates/>
    </xsl:template>
	<xsl:template match="tei:mod[@rendition='#verseLine' and not(@resp='#edACE') and not(@rend='none')]">
		<span id="{@xml:id}" class="mod entity verseline no-indent position-relative {replace(@change, '#', '')}">
            <span class="mod-inline {replace(@change, '#', '')}">
                <xsl:if test="not(@continued)">
                    <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>[&#160;</xsl:text></span>
                </xsl:if>
            </span>
		</span>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tei:mod[@rendition='#longQuoteVerseRightAlign' and @rend='inlineArrows']">
		<span class="mod inline-arrows {replace(@change, '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" style="margin-left: -1rem;">&#8594;&#xA0;</span>
		<xsl:apply-templates/>
		<span data-hand="{replace(@change,'#','')}" class="mod inline-arrows {replace(@change, '#', '')}">&#xA0;&#8594;</span>
	</xsl:template>
	<xsl:template match="tei:mod[@rendition='#inkLongQuote' and @rend='inline']">
		<span class="mod inline inkLongQuote {replace(@change, '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">&#124;</span><xsl:apply-templates/>
	</xsl:template>
	

    <!-- container element -->
    <xsl:template match="tei:mod[@rendition='#longQuote' and not(@continued)]" mode="render">
        <div class="d-flex position-relative" data-xmlid="{@xml:id}">
            <div class="mod {@rend} {replace(@change,'#','')}">
                <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>&#124;</xsl:text></span>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition='#longQuoteEndCenter' and not(@continued)]" mode="render">
        <div class="d-flex position-relative" data-xmlid="{@xml:id}">
            <div class="mod {@rend} {replace(@change,'#','')}">
                <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>&#8594;</xsl:text></span>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:mod[not(@rendition) and @style='noIndent' and not(@continued)]" mode="render">
        <div class="d-flex position-relative" data-xmlid="{@xml:id}">
            <div class="mod {@rend} {replace(@change,'#','')}">
                <div><span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>&#8592;</xsl:text></span></div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:mod[@rendition=('#longQuoteStartIndent', '#longQuoteEndIndent',  '#longQuoteIndent', '#runningText1', '#verseLine') and not(@continued)]" mode="render">
        <div class="d-flex position-relative" data-xmlid="{@xml:id}">
            <div class="mod {@rend} {replace(@change,'#','')}">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:restore">
                      <del><span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>[</xsl:text></span></del>
                    </xsl:when>
                    <xsl:otherwise>
                      <div><span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>[</xsl:text></span></div>
                    </xsl:otherwise>
              </xsl:choose>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:mod[@rend and not(@rendition) and not(@style='noIndent') and not(@continued)]" mode="render">
        <xsl:variable name="change" select="@change"/>
        <xsl:variable name="rend" select="@rend"/>
        <div data-xmlid="{@xml:id}" class="d-flex position-relative">
            <div class="mod {replace($change[1],'#','')}">
                <div class="w-100">
                    <xsl:call-template name="manual">
                        <xsl:with-param name="id" select="@xml:id"/>
                    </xsl:call-template>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="manual">
        <xsl:param name="id" select="@xml:id"/>
        <xsl:variable name="change" select="@change"/>
        <xsl:variable name="rend" select="@rend"/>
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <xsl:variable name="restore-change" select="(ancestor::tei:restore/@change)[1]"/>
                <del class="{$rend} {replace($restore-change,'#','')}">
                    <span data-anchor="{$id}" data-hand="{replace(@change[1],'#','')} {replace($restore-change,'#','')}" class="connect {replace(@change[1],'#','')}"><xsl:text>&#124;&#xA0;</xsl:text></span>
                </del>
            </xsl:when>
            <xsl:otherwise>
                <span data-anchor="{$id}" data-hand="{replace(@change[1],'#','')}" class="connect {$rend} {replace($change[1],'#','')}"><xsl:text>&#124;&#xA0;</xsl:text></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- <xsl:template match="tei:mod[@change='#pencilOnProof_KK'][not(@rendition='#pencilOnProof_rightAlignSmall')]"/> -->

</xsl:stylesheet>
