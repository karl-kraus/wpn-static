<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">    
    
    <xsl:template match="tei:add[parent::tei:subst[parent::tei:restore]]">
        <span class="add connect entity text-decoration-underline-dotted" id="{@xml:id}"></span>
    </xsl:template>
    <xsl:template match="tei:add[parent::tei:subst[not(parent::tei:restore)]]">
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)"/>
        <xsl:choose>
            <xsl:when test="$rend = 'inline'">
                <span class="add" id="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="$rend=('below', 'above', 'leftBelow', 'rightBelow', 'leftAbove', 'rightAbove')">
                <span class="position-relative">
                    <span class="add {$rend}" id="{@xml:id}"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:when test="$rend='overwritten'">
                <span class="add connect overwrite ms-n08" id="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="add connect entity" id="{@xml:id}"></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:add[not(parent::tei:subst) and not(parent::tei:restore)]">
        <xsl:choose>
            <xsl:when test="@rend = 'inline'">
                <span class="add connect entity {replace(@change, '#', '')}" id="{@xml:id}">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend=('below', 'above', 'leftBelow', 'rightBelow', 'leftAbove', 'rightAbove')">
                <span class="position-relative">
                    <span class="add {@rend} {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="add connect entity {replace(@change, '#', '')}" id="{@xml:id}">
                    <span>&#124;&#xA0;</span>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:add[parent::tei:restore]">
        <span class="add connect entity text-decoration-underline-dotted" id="{@xml:id}">
            <del>&#124;&#xA0;</del>
        </span>
    </xsl:template>
    <xsl:template match="tei:add[@rendition]">
        <span class="add rendition {replace(@rendition,'#','')} {replace(@change,'#','')}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- margin container elements -->
    <xsl:template match="tei:add[@rend|parent::tei:subst[@rend]]" mode="render">
        <xsl:variable name="xmlrend" select="if(parent::tei:subst[@xml:rend])then(parent::tei:subst/@xml:rend)else(@xml:rend)"/>
        <xsl:if test="$xmlrend = 'yes'">
            <xsl:variable name="xml-data" select="if(parent::tei:subst[@xml:data])then(parent::tei:subst/@xml:data)else(@xml:data)"/>
            <xsl:variable name="change" select="if(parent::tei:subst[@change])then(parent::tei:subst/@change)else(@change)"/>
            <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)"/>
            <xsl:variable name="containerID" select="if(parent::tei:subst)then(preceding-sibling::tei:del[1]/@xml:id)else(@xml:id)"/>
            <div data-xmlid="{@xml:id}" class="d-flex ms-1 w-100 position-relative">
                <div id="container-{$containerID}" class="add connect w-100 {replace($change,'#','')}">
                    <div class="w-100">
                        <xsl:apply-templates select="." mode="manual"/>
                    </div>
                </div>
                <xsl:call-template name="wrapper-iter">
                    <xsl:with-param name="xmldata" select="tokenize($xml-data, '/')"/>
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
                <div id="container-{$subornot}" class="ms-1 add connect w-100 {replace($next-change,'#','')}">
                    <div class="w-100">
                        <xsl:choose>
                            <xsl:when test="contains($next/@xml:id, 'add')">
                                <span class="{$next-rend}">
                                    &#124;&#xA0;<xsl:apply-templates select="$next" mode="manual_iter"/>
                                </span>
                            </xsl:when>
                            <xsl:when test="contains($next/@xml:id, 'del')">
                                <span class="{$next-rend}">
                                    &#124;<svg xmlns="http://www.w3.org/2000/svg" xmlns:dc="http://purl.org/dc/elements/1.1/" fill="currentColor" viewBox="0 0 8.99 16.04">
                                                <metadata>
                                                <dc:creator>Bernhard Oberreither</dc:creator>
                                                <dc:creator>https://d-nb.info/gnd/1036708799</dc:creator>
                                                </metadata>
                                                <path d="M4.29,12.55c.08.14.16.26.24.39-.41.35-.47.8-.31,1.27.14.42.46.69.85.88.43.21.88.34,1.35.38.38.03.76,0,1.12-.17.46-.22.7-.6.77-1.1.1-.72.06-1.44-.04-2.15-.04-.29-.08-.59-.16-.87-.22-.81-.49-1.61-.88-2.36-.37-.72-.75-1.44-1.12-2.18-.02.02-.05.05-.07.09-.27.47-.53.94-.82,1.4-.34.54-.69,1.07-1.05,1.61-.06.09-.13.17-.22.27-.4-1.2-.79-2.38-1.18-3.57-.61.98-1.43,1.73-2.44,2.31-.09-.14-.17-.27-.26-.41,1.31-.74,2.25-1.82,2.82-3.22.01,0,.02,0,.03,0,.19.64.37,1.27.56,1.91.19.63.39,1.26.59,1.9.02,0,.03,0,.05,0,.15-.23.31-.46.45-.7.16-.25.31-.51.46-.76.26-.45.53-.89.78-1.34.03-.05.04-.14.02-.2-.36-1.11-.52-2.25-.49-3.41.01-.53.07-1.06.32-1.55.3-.57.78-.87,1.42-.9.39-.02.68.17.94.45.25.28.31.62.29.97-.02.32-.09.64-.17.96-.04.18-.14.34-.22.51-.26.58-.52,1.17-.8,1.75-.2.42-.43.84-.65,1.25-.04.07-.05.13-.01.21.19.43.37.86.58,1.28.3.61.62,1.21.92,1.82.4.8.62,1.66.76,2.53.12.78.17,1.58.08,2.37-.06.52-.22,1-.65,1.34-.33.25-.7.39-1.12.44-.62.07-1.21-.03-1.79-.24-.41-.15-.76-.38-1.08-.68-.61-.59-.65-1.53-.27-2.09.05-.08.11-.15.18-.21.06-.06.14-.1.23-.16ZM6.19,5.37s.03,0,.05,0c0-.01.02-.03.03-.04.29-.59.59-1.19.88-1.78.13-.28.25-.56.38-.85.2-.46.34-.93.29-1.45-.05-.48-.42-.79-.85-.71-.44.09-.73.37-.9.76-.1.22-.15.46-.18.7-.09.73-.06,1.46.06,2.19.07.4.17.79.25,1.18Z"/>
                                            </svg>
                                    <xsl:apply-templates select="$next" mode="manual_iter"/>
                                </span>
                            </xsl:when>
                            <xsl:when test="contains($next/@xml:id, 'sub')">
                                <span class="{$next-rend}">
                                    &#124;&#xA0;<xsl:apply-templates select="$next/tei:add" mode="manual_iter"/>
                                </span>
                            </xsl:when>
                            <xsl:when test="contains($next/@xml:id, 'metam')">
                                <span class="{$next-rend}">
                                    &#124;&#xA0;<xsl:apply-templates select="$next" mode="manual_iter"/>
                                </span>
                            </xsl:when>
                        </xsl:choose>
                    </div>
                </div>
            </xsl:if>
        </xsl:iterate>
    </xsl:template>

    <xsl:template match="tei:add" mode="manual">
        <xsl:variable name="change" select="if(parent::tei:subst[@change])then(parent::tei:subst/@change)else(@change)"/>
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)"/>
        <xsl:choose>
            <xsl:when test="parent::tei:subst[parent::tei:restore]">
                <xsl:variable name="restore-change" select="(ancestor::tei:restore/@change)[1]"/>
                <del class="{$rend} {replace($restore-change,'#','')}">&#124;&#xA0;<xsl:apply-templates/></del>
            </xsl:when>
            <xsl:when test="parent::tei:restore">
                <xsl:variable name="restore-change" select="(ancestor::tei:restore/@change)[1]"/>
                <del class="{$rend} {replace($restore-change,'#','')}">
                    <span class="{replace(@change,'#','')}">&#124;&#xA0;<xsl:apply-templates/></span>
                </del>
            </xsl:when>
            <xsl:when test="parent::tei:subst[not(parent::tei:restore)]">
                <span class="{$rend} {replace($change,'#','')}">&#124;&#xA0;<xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="{$rend} {replace($change,'#','')}">&#124;&#xA0;<xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:add" mode="manual_iter">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- <xsl:template match="tei:add[@rend|parent::tei:subst[@rend] and contains((@rend|parent::tei:subst/@rend), 'Right')]">
    <wpn-entity class="add entity" id="{@xml:id}"></wpn-entity>
    </xsl:template>
    <xsl:template match="tei:add[@rend|parent::tei:subst[@rend] and contains((@rend|parent::tei:subst/@rend), 'Left')]">
    <wpn-entity class="add entity" id="{@xml:id}"></wpn-entity>
    </xsl:template> -->
    <!-- <xsl:template match="tei:add[ancestor::tei:restore[not(child::tei:seg)]]"/>
    <xsl:template match="tei:add[ancestor::tei:restore[child::tei:seg]]">
    <xsl:apply-templates/>
    </xsl:template> -->
</xsl:stylesheet>
