<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:del[parent::tei:subst[@rend='overwritten']]">
        <span class="del text-black-grey {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:subst[parent::tei:restore]]">
        <del>
            <span class="del text-decoration-underline-dotted {replace(@change, '#', '')}"><xsl:apply-templates/></span>
        </del>
    </xsl:template>
    <xsl:template match="tei:del[@rend=('below', 'above') or parent::tei:subst/@rend=('below', 'above')]">
        <span class="position-relative">
            <span class="del {@rend} {replace(@change,'#','')}"><xsl:apply-templates/></span>
        </span>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:add]">
        <del id="{@xml:id}" class="{replace(@change, '#', '')}"><xsl:apply-templates/></del>
    </xsl:template>

    <xsl:template match="tei:del[parent::tei:restore]">
        <del>
            <span id="{@xml:id}" class="del connect entity text-decoration-underline-dotted {replace(@change, '#', '')}"><xsl:apply-templates/></span>
        </del>
    </xsl:template>
    <xsl:template match="tei:del[not(parent::tei:subst[@rend='overwritten']) and not(parent::tei:restore)]">
        <xsl:choose>
            <xsl:when test="child::tei:*">
                <del class="del connect entity {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></del>
            </xsl:when>
            <xsl:otherwise>
                <span class="del connect entity {replace(@change, '#', '')}" id="{@xml:id}">
                    <xsl:choose>
                        <xsl:when test="starts-with(., ' ')">
                            <xsl:text>&#x20;</xsl:text><del><xsl:value-of select="normalize-space(.)"/></del>
                        </xsl:when>
                        <xsl:when test="ends-with(., ' ')">
                            <del><xsl:value-of select="normalize-space(.)"/></del><xsl:text>&#x20;</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <del><xsl:value-of select="normalize-space(.)"/></del>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- margin container elements -->
    <xsl:template match="tei:del[not(parent::tei:subst) and contains(@rend, 'Left')]" mode="render">
        <div data-xmlid="{@xml:id}" class="d-flex ms-1">
            <xsl:if test="not(@xml:rend)">
            <div id="container-{@xml:id}" class="del connect {replace(@change,'#','')} w-100">
                <div class="position-relative">
                    <span class="{@rend}" style="font-size:1.25em;">&#124;&#x20B0;</span>
                </div>
            </div>
            </xsl:if>
            <xsl:if test="contains(@rend, 'marginInner')">
                <div id="container-{@xml:id}" class="del connect {replace(@change,'#','')}">
                    <div class="position-relative">
                        <span class="{@rend}" style="font-size:1.25em;">&#124;&#x20B0;</span>
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
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'del')">
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}" style="font-size:1.25em;">
                                        &#124;&#x20B0;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'sub')">
                                    <span class="{$next/@rend}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next/tei:add"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'metam')">
                                    <span class="{$next/@rend}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next"/>
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
    <xsl:template match="tei:del[not(parent::tei:subst) and contains(@rend, 'Right')]" mode="render">
        <div data-xmlid="{@xml:id}" class="d-flex ms-1">
            <xsl:if test="not(@xml:rend)">
                <div id="container-{@xml:id}" class="del connect {replace(@change,'#','')} w-100">
                    <div class="position-relative">
                        <span class="{@rend}" style="font-size:1.25em;">&#124;&#x20B0;</span>
                    </div>
                </div>
            </xsl:if>
            <xsl:if test="contains(@rend, 'marginInner')">
                <div id="container-{@xml:id}" class="del connect {replace(@change,'#','')}">
                    <div class="position-relative">
                        <span class="{@rend}" style="font-size:1.25em;">&#124;&#x20B0;</span>
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
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'del')">
                                    <span class="{if($next/parent::tei:subst)then($next/parent::tei:subst/@rend)else($next/@rend)}" style="font-size:1.25em;">
                                        &#124;&#x20B0;<xsl:value-of select="$next"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, '-sub-')">
                                    <span class="{$next/@rend}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next/tei:add"/>
                                    </span>
                                </xsl:when>
                                <xsl:when test="contains($next/@xml:id, 'metam')">
                                    <span class="{$next/@rend}" style="font-size:1.25em;">
                                        &#124;<xsl:value-of select="$next"/>
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
    
    <!-- <xsl:template match="tei:del[ancestor::tei:restore[ancestor::tei:restore[child::tei:seg]]]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[ancestor::tei:restore[child::tei:seg]]"/>
    <xsl:template match="tei:del[ancestor::tei:restore[not(child::tei:seg)]]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del[not(ancestor::tei:restore)][not(ancestor::tei:restore[ancestor::tei:restore[child::tei:seg]])]"/> -->
</xsl:stylesheet>