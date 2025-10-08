<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:mod[@n and parent::tei:p[@rendition='#runningText2']]">
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
	 <xsl:template match="tei:mod[@rendition=('#runningText1') and @n and not(parent::tei:p[@rendition='#runningText2'])]">
        <span class="mod connect entity running-text-1 no-indent position-relative {replace(@change, '#', '')}" id="{@xml:id}">
            <span class="mod-inline {replace(@change, '#', '')}"><span>[</span></span>
		</span>
		<xsl:apply-templates/>
    </xsl:template>
	<xsl:template match="tei:mod[@rendition='#verseLine' and not(@resp='#edACE') and not(@rend='none')]">
		<span class="mod connect entity verseline no-indent position-relative {replace(@change, '#', '')}" id="{@xml:id}">
            <span class="mod-inline {replace(@change, '#', '')}"><span>[</span></span>
		</span>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tei:mod[@rendition='#longQuoteVerseRightAlign' and @rend='inlineArrows']">
		<span class="mod inline-arrows {replace(@change, '#', '')}" id="{@xml:id}" style="margin-left: -1rem;">&#8594;&#xA0;</span>
		<xsl:apply-templates/>
		<span class="mod inline-arrows {replace(@change, '#', '')}">&#xA0;&#8594;</span>
	</xsl:template>
    <xsl:template match="tei:mod[@rend and not(@rendition)]">
        <span class="mod connect entity {@style} {replace(@change, '#', '')}" id="{@xml:id}">
            <xsl:apply-templates/>
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

    <xsl:template match="tei:mod[@rend and not(@rendition) and not(@style='noIndent') and not(@continued)]" mode="render">
        <xsl:variable name="xmlrend" select="@xml:rend"/>
        <xsl:if test="$xmlrend = 'yes'">
            <xsl:variable name="xml-data" select="@xml:data"/>
            <xsl:variable name="change" select="@change"/>
            <xsl:variable name="rend" select="@rend"/>
            <xsl:variable name="containerID" select="@xml:id"/>
            <div data-xmlid="{@xml:id}" class="d-flex position-relative">
                <div id="container-{$containerID}" class="mod connect {replace($change[1],'#','')}">
                    <div class="w-100">
                        <xsl:call-template name="manual"/>
                    </div>
                </div>
                <xsl:call-template name="wrapper-iter">
                    <xsl:with-param name="xmldata" select="tokenize($xml-data[1], '/')"/>
                </xsl:call-template>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="wrapper-iter">
        <xsl:param name="xmldata" as="xs:string*"/>
        <xsl:variable name="tei" select="ancestor::tei:TEI"/>
        <xsl:iterate select="$xmldata">
            <xsl:if test="string-length(current()) != 0">
                <xsl:variable name="next" select="$tei//tei:*[@xml:id=current()]" as="element()"/>
                <xsl:variable name="next-change" select="if($next[parent::tei:subst[@change]])then($next/parent::tei:subst/@change)else($next/@change)"/>
                <xsl:variable name="next-rend" select="if($next[parent::tei:subst[@rend]])then($next/parent::tei:subst/@rend)else($next/@rend)"/>
                <xsl:variable name="subornot" select="if(contains($next/@xml:id, '-sub-'))then($next/tei:del/@xml:id)else($next/@xml:id)"/>
                <div id="container-{$subornot}" class="{$next/local-name()} connect {replace($next-change,'#','')}">
                    <div class="w-100">
                        <xsl:choose>
                            <xsl:when test="contains($next/@xml:id, 'add')">
                                <span class="{$next-rend} {replace($next-change[1],'#','')}">
                                    &#124;&#xA0;<xsl:apply-templates select="$next/tei:add" mode="manual_iter"/>
                                </span>
                            </xsl:when>
                            <xsl:when test="contains($next/@xml:id, 'del')">
                                <xsl:choose>
                                    <xsl:when test="$next[parent::tei:restore]">
                                        <del class="{$next-rend} {replace(($next/parent::tei:restore/@change)[1],'#','')}">
                                            <span class="{replace($next-change[1],'#','')}">
                                                &#124;&#xA0;<span class="arimo">&#8368;</span>
                                            </span>
                                        </del>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="{$next-rend} {replace($next-change[1],'#','')}">
                                            &#124;&#xA0;<span class="arimo">&#8368;</span>
                                        </span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($next/@xml:id, 'sub')">
                                <span class="{$next-rend} {replace($next-change,'#','')}">
                                    &#124;&#xA0;<xsl:apply-templates select="$next/tei:add" mode="manual_iter"/>
                                </span>
                            </xsl:when>
                            <xsl:when test="contains($next/@xml:id, 'metam')">
                                <span class="{$next-rend} {replace($next-change,'#','')}">
                                    <xsl:apply-templates select="$next" mode="manual_iter"/>
                                </span>
                            </xsl:when>
                        </xsl:choose>
                    </div>
                </div>
            </xsl:if>
        </xsl:iterate>
    </xsl:template>

    <xsl:template name="manual">
        <xsl:variable name="change" select="@change"/>
        <xsl:variable name="rend" select="@rend"/>
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <xsl:variable name="restore-change" select="(ancestor::tei:restore/@change)[1]"/>
                <del class="{$rend} {replace($restore-change,'#','')}">
                    <span class="{replace(@change[1],'#','')}">&#124;&#xA0;</span>
                </del>
            </xsl:when>
            <xsl:otherwise>
                <span class="{$rend} {replace($change[1],'#','')}">&#124;&#xA0;</span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:add" mode="manual_iter">
        <xsl:if test="self::tei:metamark[not(@function='progress')]">
            &#124;&#xA0;
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- <xsl:template match="tei:mod[@change='#pencilOnProof_KK'][not(@rendition='#pencilOnProof_rightAlignSmall')]"/> -->

</xsl:stylesheet>
