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
        <xsl:choose>
            <xsl:when test="@rend = 'inline'">
                <span class="add" id="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="@rend=('below', 'above', 'leftBelow', 'rightBelow', 'leftAbove', 'rightAbove')">
                <span class="position-relative">
                    <span class="add {parent::tei:subst/@rend}" id="{@xml:id}"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:when test="@rend='overwritten'">
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
    <xsl:template match="tei:add[@rend|parent::tei:subst[@rend] and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)), 'Right')]" mode="render">
        <xsl:variable name="change" select="if(parent::tei:subst[@change])then(parent::tei:subst/@change)else(@change)"/>
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)"/>
        <xsl:variable name="xmlrend" select="if(parent::tei:subst[@xml:rend])then(parent::tei:subst/@xml:rend)else(@xml:rend)"/>
        <xsl:variable name="containerID" select="if(parent::tei:subst)then(preceding-sibling::tei:del[1]/@xml:id)else(@xml:id)"/>
        <div data-xmlid="{@xml:id}" class="d-flex ms-1">
            <xsl:if test="not($xmlrend)">
                <div id="container-{$containerID}" class="add connect {replace($change,'#','')} w-100">
                    <div class="position-relative">
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
                    </div>
                </div>
            </xsl:if>
            <xsl:if test="contains($rend, 'marginInner')">
                <div id="container-{$containerID}" class="add connect {replace($change,'#','')}">
                    <div class="position-relative">
                        <span class="{$rend}">&#124;&#xA0;<xsl:apply-templates/></span>
                    </div>
                </div>
                <xsl:variable name="xmldata" select="tokenize(@xml:data, '/')"/>
                <xsl:variable name="tei" select="ancestor::tei:TEI"/>
                <xsl:iterate select="$xmldata">
                    <xsl:if test="string-length(current()) != 0">
                        <xsl:variable name="next" select="$tei//tei:*[@xml:id=current()]" as="element()"/>
                        <xsl:variable name="next-change" select="if($next/parent::tei:subst[@change])then($next/parent::tei:subst/@change)else($next/@change)"/>
                        <xsl:variable name="subornot" select="if(contains($next/@xml:id, '-sub-'))then($next/tei:del/@xml:id)else($next/@xml:id)"/>
                        <div id="container-{$subornot}" class="ms-1 add connect {replace($next-change,'#','')}">
                            <div class="position-relative">
                                <xsl:choose>
                                    <xsl:when test="contains($next/@xml:id, 'add')">
                                        <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}">
                                            &#124;&#xA0;<xsl:value-of select="$next"/>
                                        </span>
                                    </xsl:when>
                                    <xsl:when test="contains($next/@xml:id, 'del')">
                                        <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}">
                                            &#124;&#x20B0;&#xA0;<xsl:value-of select="$next"/>
                                        </span>
                                    </xsl:when>
                                    <xsl:when test="contains($next/@xml:id, 'sub')">
                                        <span class="{$next/tei:add/@rend}">
                                            &#124;&#xA0;<xsl:value-of select="$next/tei:add"/>
                                        </span>
                                    </xsl:when>
                                    <xsl:when test="contains($next/@xml:id, 'metam')">
                                        <span class="{$next/@rend}">
                                            &#124;&#xA0;<xsl:value-of select="$next"/>
                                        </span>
                                    </xsl:when>
                                </xsl:choose>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:iterate>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="tei:add[@rend|parent::tei:subst[@rend] and contains((if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)), 'Left')]" mode="render">
        <xsl:variable name="change" select="if(parent::tei:subst[@change])then(parent::tei:subst/@change)else(@change)"/>
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)"/>
        <xsl:variable name="xmlrend" select="if(parent::tei:subst[@xml:rend])then(parent::tei:subst/@xml:rend)else(@xml:rend)"/>
        <xsl:variable name="containerID" select="if(parent::tei:subst)then(preceding-sibling::tei:del[1]/@xml:id)else(@xml:id)"/>
        <div data-xmlid="{@xml:id}" class="d-flex ms-1">
            <xsl:if test="not($xmlrend)">
                <div id="container-{$containerID}" class="add connect {replace($change,'#','')} w-100">
                    <div class="position-relative">
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
                    </div>
                </div>
            </xsl:if>
            <xsl:if test="contains($rend, 'marginInner')">
                <div id="container-{$containerID}" class="add connect {replace($change,'#','')}">
                    <div class="position-relative">
                        <span class="{$rend}">&#124;&#xA0;<xsl:apply-templates/></span>
                    </div>
                </div>
                <xsl:variable name="xmldata" select="tokenize(@xml:data, '/')"/>
                <xsl:variable name="tei" select="ancestor::tei:TEI"/>
                <xsl:iterate select="$xmldata">
                    <xsl:if test="string-length(current()) != 0">
                        <xsl:variable name="next" select="$tei//tei:*[@xml:id=current()]" as="element()"/>
                        <xsl:variable name="next-change" select="if($next/parent::tei:subst[@change])then($next/parent::tei:subst/@change)else($next/@change)"/>
                        <xsl:variable name="subornot" select="if(contains($next/@xml:id, '-sub-'))then($next/tei:add/@xml:id)else($next/@xml:id)"/>
                        <div id="container-{$subornot}" class="ms-1 add connect {replace($next-change,'#','')}">
                            <div class="position-relative">
                                <xsl:choose>
                                    <xsl:when test="contains($next/@xml:id, 'add')">
                                        <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}">
                                            &#124;&#xA0;<xsl:value-of select="$next"/>
                                        </span>
                                    </xsl:when>
                                    <xsl:when test="contains($next/@xml:id, 'del')">
                                        <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}">
                                            &#124;&#x20B0;&#xA0;<xsl:value-of select="$next"/>
                                        </span>
                                    </xsl:when>
                                    <xsl:when test="contains($next/@xml:id, 'sub')">
                                        <span class="{$next/tei:add/@rend}">
                                            &#124;&#xA0;<xsl:value-of select="$next/tei:add"/>
                                        </span>
                                    </xsl:when>
                                    <xsl:when test="contains($next/@xml:id, 'metam')">
                                        <span class="{$next/@rend}">
                                            &#124;&#xA0;<xsl:value-of select="$next"/>
                                        </span>
                                    </xsl:when>
                                </xsl:choose>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:iterate>
            </xsl:if>
        </div>
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
