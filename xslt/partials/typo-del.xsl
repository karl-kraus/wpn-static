<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:del[not(parent::tei:subst[not(parent::tei:restore)])]">
        <xsl:variable name="rend" select="@rend"/>
        <xsl:variable name="change" select="@change"/>
        <xsl:choose>
            <xsl:when test="@rend='overwritten'">
                <span class="del text-black-grey" id="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="@rend=('below', 'above', 'leftBelow', 'rightBelow', 'leftAbove', 'rightAbove')">
                <span class="position-relative">
                    <span class="del {@rend} {replace(($change)[1],'#','')}" id="{@xml:id}"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="child::tei:*">
                        <span class="del connect entity {replace(($change)[1], '#', '')}" id="{@xml:id}">
                            <del><xsl:apply-templates/></del>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="del connect entity {replace(($change)[1], '#', '')}" id="{@xml:id}">
                            <xsl:choose>
                                <xsl:when test="starts-with(., ' ')">
                                    <xsl:text>&#xA0;</xsl:text><del><xsl:value-of select="normalize-space(.)"/></del>
                                </xsl:when>
                                <xsl:when test="ends-with(., ' ')">
                                    <del><xsl:value-of select="normalize-space(.)"/></del><xsl:text>&#xA0;</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <del><xsl:value-of select="normalize-space(.)"/></del>
                                </xsl:otherwise>
                            </xsl:choose>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:subst[not(parent::tei:restore)]]">
        <xsl:variable name="rend" select="replace((parent::tei:subst/@rend)[1], '#', '')"/>
        <!-- <xsl:variable name="change" select="replace((parent::tei:subst/@change)[1], '#', '')"/> -->
        <xsl:choose>
            <xsl:when test="$rend='overwritten'">
                <span class="del text-black-grey" id="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="$rend=('below', 'above', 'leftBelow', 'rightBelow', 'leftAbove', 'rightAbove')">
                <span class="position-relative">
                    <span class="del {$rend}" id="{@xml:id}"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="child::tei:*">
                        <span class="del connect entity" id="{@xml:id}">
                            <del><xsl:apply-templates/></del>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="del connect entity" id="{@xml:id}">
                            <xsl:choose>
                                <xsl:when test="starts-with(., ' ')">
                                    <xsl:text>&#xA0;</xsl:text><del><xsl:value-of select="normalize-space(.)"/></del>
                                </xsl:when>
                                <xsl:when test="ends-with(., ' ')">
                                    <del><xsl:value-of select="normalize-space(.)"/></del><xsl:text>&#xA0;</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <del><xsl:value-of select="normalize-space(.)"/></del>
                                </xsl:otherwise>
                            </xsl:choose>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:subst[parent::tei:restore]]">
        <span class="del text-decoration-underline-dotted" id="{@xml:id}">
            <del><xsl:apply-templates/></del>
        </span>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:add]">
        <span id="{@xml:id}" class="{replace((@change)[1], '#', '')}">
            <del><xsl:apply-templates/></del>
        </span>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:restore]">
        <span id="{@xml:id}" class="del connect entity text-decoration-underline-dotted">
            <del><xsl:apply-templates/></del>
        </span>
    </xsl:template>
    <!-- margin container elements -->
    <xsl:template match="tei:del[not(parent::tei:subst)]" mode="render">
        <div data-xmlid="{@xml:id}" class="d-flex ms-1">
            <xsl:if test="not(@xml:rend)">
            <div id="container-{@xml:id}" class="del connect w-100">
                <div class="position-relative">
                    <xsl:apply-templates select="." mode="manual"/>
                </div>
            </div>
            </xsl:if>
            <xsl:if test="contains(@rend, 'marginInner')">
                <div id="container-{@xml:id}" class="del connect {replace(@change,'#','')}">
                    <div class="position-relative">
                        <xsl:apply-templates select="." mode="manual"/>
                    </div>
                </div>
                <xsl:variable name="xmldata" select="tokenize(@xml:data, '/')"/>
                <xsl:variable name="tei" select="ancestor::tei:TEI"/>
                <xsl:iterate select="$xmldata">
                    <xsl:if test="string-length(current()) != 0">
                    <xsl:variable name="next" select="$tei//tei:*[@xml:id=current()]" as="element()"/>
                    <xsl:variable name="subornot" select="if(contains($next/@xml:id, '-sub-'))then($next/tei:add/@xml:id)else($next/@xml:id)"/>
                    <div id="container-{$subornot}" class="ms-1 del connect {replace($next/@change,'#','')}">
                        <div class="position-relative">
                            <xsl:choose>
                                <xsl:when test="contains($next/@xml:id, 'add')">
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}">
                                        &#124;&#xA0;<xsl:apply-templates select="$next" mode="manual_iter"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'del')">
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}">
                                        &#124;&#xA0;&#x20B0;<xsl:apply-templates select="$next" mode="manual_iter"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, '-sub-')">
                                    <span class="{$next/@rend}">
                                        &#124;&#xA0;<xsl:apply-templates select="$next/tei:add" mode="manual_iter"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'metam')">
                                    <span class="{$next/@rend}">
                                        &#124;&#xA0;<xsl:apply-templates select="$next" mode="manual_iter"/>
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

    <xsl:template match="tei:del" mode="manual">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <del class="{replace((parent::tei:restore/@change)[1],'#','')}">
                    <span class="{@rend} {replace(@change,'#','')}">&#124;&#xA0;&#x20B0;</span>
                </del>
            </xsl:when>
            <xsl:otherwise>
                <span class="{@rend} {replace(@change,'#','')}">&#124;&#xA0;&#x20B0;</span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:del" mode="manual_iter">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- <xsl:template match="tei:del[ancestor::tei:restore[ancestor::tei:restore[child::tei:seg]]]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[ancestor::tei:restore[child::tei:seg]]"/>
    <xsl:template match="tei:del[ancestor::tei:restore[not(child::tei:seg)]]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[not(ancestor::tei:restore)][not(ancestor::tei:restore[ancestor::tei:restore[child::tei:seg]])]"/> -->
</xsl:stylesheet>