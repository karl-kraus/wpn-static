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
                <span class="del text-black-grey" data-anchor="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="@rend=('below', 'above', 'left', 'leftBelow', 'rightBelow', 'leftAbove', 'rightAbove')">
                <del><xsl:value-of select="normalize-space(.)"/></del>
                <span class="position-relative">
                   <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="del {@rend} {replace($change, '#', '')}"><xsl:text>&#124;&#xA0;</xsl:text><span class="arimo" data-anchor="{@xml:id}"><xsl:text>&#8368;</xsl:text></span></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="child::tei:*">
                        <span class="del {replace(($change)[1], '#', '')}">
                            <del class="entity" data-anchor="{@xml:id}" data-hand="{replace($change[1],'#','')}"><xsl:apply-templates/></del>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="del {replace(($change)[1], '#', '')}">
                            <xsl:choose>
                                <xsl:when test="count(node())=1 and text()=' ' and not(@resp)">
                                    <del data-anchor="{@xml:id}" data-hand="{replace($change[1],'#','')}" class="entity"><xsl:text>&#32;</xsl:text></del>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="starts-with(., ' ')">
                                            <xsl:text>&#xA0;</xsl:text><del data-anchor="{@xml:id}" data-hand="{replace($change[1],'#','')}" class="entity"><xsl:value-of select="normalize-space(.)"/></del>
                                        </xsl:when>
                                        <xsl:when test="ends-with(., ' ')">
                                            <del data-anchor="{@xml:id}" data-hand="{replace($change[1],'#','')}" class="entity"><xsl:value-of select="normalize-space(.)"/></del><xsl:text>&#xA0;</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <del data-anchor="{@xml:id}" data-hand="{replace($change[1],'#','')}" class="entity"><xsl:value-of select="normalize-space(.)"/></del>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:subst[not(parent::tei:restore)]]">
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)"/>
        <!-- <xsl:variable name="change" select="replace((parent::tei:subst/@change)[1], '#', '')"/> -->
        <xsl:variable name="targetorfalse" select="if(parent::tei:subst[./tei:add[./tei:metamark[@target]]])then(parent::tei:subst/tei:add/tei:metamark/@target)else('false')"/>
        <xsl:variable name="target" select="if($targetorfalse!='false')then(replace($targetorfalse, '#', ''))else('false')"/>
        <xsl:choose>
            <xsl:when test="$rend='overwritten'">
                <span class="del text-black-grey" data-anchor="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="$rend=('below', 'above', 'left', 'leftBelow', 'rightBelow', 'leftAbove', 'rightAbove')">
                <del class="del" data-anchor="{@xml:id}"><xsl:apply-templates/></del>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="child::tei:*">
                        <del class="del entity" data-anchor="{@xml:id}">
                            <xsl:if test="$target!='false'">
                                <xsl:attribute name="data-target">
                                    <xsl:value-of select="$target"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:apply-templates/>
                        </del>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="count(node())=1 and text()=' ' and not(@resp)">
                                <del class="entity" data-anchor="{@xml:id}">
                                    <xsl:if test="$target!='false'">
                                        <xsl:attribute name="data-target">
                                            <xsl:value-of select="$target"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:text>&#x20;</xsl:text>
                                </del>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <!-- <xsl:when test="starts-with(., ' ') and ends-with(., ' ')">
                                        <span class="del">
                                            <xsl:text>&#xA0;</xsl:text>
                                            <del class="entity" data-anchor="{@xml:id}">
                                                <xsl:if test="$target!='false'">
                                                    <xsl:attribute name="data-target">
                                                        <xsl:value-of select="$target"/>
                                                    </xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </del>
                                            <xsl:text>&#xA0;</xsl:text>
                                        </span>
                                    </xsl:when> -->
                                    <xsl:when test="starts-with(., ' ')">
                                        <span class="del">
                                            <xsl:text>&#xA0;</xsl:text>
                                            <del class="entity" data-anchor="{@xml:id}">
                                                <xsl:if test="$target!='false'">
                                                    <xsl:attribute name="data-target">
                                                        <xsl:value-of select="$target"/>
                                                    </xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </del>
                                        </span>
                                    </xsl:when>
                                    <xsl:when test="ends-with(., ' ')">
                                        <del class="entity" data-anchor="{@xml:id}">
                                            <xsl:if test="$target!='false'">
                                                <xsl:attribute name="data-target">
                                                    <xsl:value-of select="$target"/>
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </del><xsl:text>&#xA0;</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <del class="entity" data-anchor="{@xml:id}">
                                            <xsl:if test="$target!='false'">
                                                <xsl:attribute name="data-target">
                                                    <xsl:value-of select="$target"/>
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </del>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:subst[parent::tei:restore]]">
        <xsl:choose>
            <xsl:when test="parent::tei:subst[parent::tei:restore[parent::tei:del]]">
               <span class="del text-decoration-underline-dotted">
                    <span data-anchor="{@xml:id} {ancestor::tei:del/@xml:id}"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:when test="parent::tei:subst[parent::tei:restore[not(@rend='marginOnly')]]">
               <span class="del text-decoration-underline-dotted">
                    <del data-anchor="{@xml:id}"><xsl:apply-templates/></del>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <del data-anchor="{@xml:id}"><xsl:apply-templates/></del>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:add]">
        <xsl:choose>
            <xsl:when test="@rend='left'">
                <span class="del {replace((@change)[1], '#', '')}">
                    <del data-anchor="{@xml:id}"><xsl:value-of select="normalize-space(.)"/></del>
                </span>
                <span class="position-relative">
                   <span data-hand="{replace(@change, '#', '')}" class="del {@rend} {replace(@change, '#', '')}"><xsl:text>&#124;&#xA0;</xsl:text><span class="arimo"><xsl:text>&#8368;</xsl:text></span></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="ancestor::tei:del">
                        <span class="{replace((@change)[1], '#', '')}">
                            <span data-anchor="{@xml:id}" data-hand="{replace((@change)[1], '#', '')}"><xsl:apply-templates/></span>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="{replace((@change)[1], '#', '')}">
                            <del data-anchor="{@xml:id}" data-hand="{replace((@change)[1], '#', '')}"><xsl:apply-templates/></del>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:restore]">
         <xsl:choose>
            <xsl:when test="parent::tei:restore[not(@rend='marginOnly')]">
               <span class="del text-decoration-underline-dotted">
                    <del class="entity" data-anchor="{@xml:id}"><xsl:apply-templates/></del>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="ancestor::tei:del">
                        <span class="del entity" data-anchor="{@xml:id}"><xsl:apply-templates/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <del class="del entity" data-anchor="{@xml:id}"><xsl:apply-templates/></del>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:del[@resp and @type='implicit']">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- margin container elements -->
    <xsl:template match="tei:del[not(parent::tei:subst)]" mode="render">
        <div data-xmlid="{@xml:id}" class="d-flex w-100 position-relative">
            <div class="del w-100 {replace(@change,'#','')}">
                <div class="w-100">
                    <xsl:apply-templates select="self::tei:del" mode="manual">
                        <xsl:with-param name="id" select="@xml:id"/>
                    </xsl:apply-templates>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:del" mode="manual">
        <xsl:param name="id" select="@xml:id"/>
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <del class="{@rend} {replace((parent::tei:restore/@change)[1],'#','')}">
                    <span data-anchor="{$id}" data-hand="{replace(@change,'#','')}" class="{replace(@change,'#','')}">
                        <xsl:text>&#124;&#xA0;</xsl:text><span class="arimo" data-anchor="{$id}"><xsl:text>&#8368;</xsl:text></span>
                    </span>
                </del>
            </xsl:when>
            <xsl:when test="count(node())=1 and text()=' ' and not(@resp)">
                <span data-anchor="{$id}" data-hand="{replace(@change,'#','')}" class="whitespace-del {replace(@change,'#','')}">
                    <xsl:text>&#124;&#xA0;</xsl:text><span class="arimo" data-anchor="{$id}"><xsl:text>&#8368;</xsl:text></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span data-anchor="{$id}" data-hand="{replace(@change,'#','')}" class="{@rend} {replace(@change,'#','')}">
                    <xsl:text>&#124;&#xA0;</xsl:text><span class="arimo" data-anchor="{$id}"><xsl:text>&#8368;</xsl:text></span>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
