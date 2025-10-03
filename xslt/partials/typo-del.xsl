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
                <del><xsl:value-of select="normalize-space(.)"/></del>
                <span class="position-relative">
                   <span class="del {@rend} {replace($change, '#', '')}">&#124;&#xA0;<span class="arimo">&#8368;</span></span>
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
                                <xsl:when test="count(node())=1 and text()=' ' and not(@resp)">
                                    <span class="whitespace-del"><xsl:text>&#8256;</xsl:text></span>
                                </xsl:when>
                                <xsl:otherwise>
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
        <xsl:choose>
            <xsl:when test="$rend='overwritten'">
                <span class="del text-black-grey" id="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="$rend=('below', 'above', 'leftBelow', 'rightBelow', 'leftAbove', 'rightAbove')">
                <span class="del" id="{@xml:id}">
                    <del><xsl:apply-templates/></del>
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
        <xsl:choose>
            <xsl:when test="parent::tei:subst[parent::tei:restore[not(@rend='marginOnly')]]">
               <span class="del text-decoration-underline-dotted" id="{@xml:id}">
                    <del><xsl:apply-templates/></del>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="del" id="{@xml:id}">
                    <del><xsl:apply-templates/></del>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:add]">
        <span id="{@xml:id}" class="{replace((@change)[1], '#', '')}">
            <del><xsl:apply-templates/></del>
        </span>
    </xsl:template>
    <xsl:template match="tei:del[parent::tei:restore]">
         <xsl:choose>
            <xsl:when test="parent::tei:restore[not(@rend='marginOnly')]">
               <span id="{@xml:id}" class="del connect entity text-decoration-underline-dotted">
                    <del><xsl:apply-templates/></del>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span id="{@xml:id}" class="del connect entity ">
                    <del><xsl:apply-templates/></del>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- margin container elements -->
    <xsl:template match="tei:del[not(parent::tei:subst)]" mode="render">
        <xsl:variable name="xmlrend" select="if(parent::tei:subst[@xml:rend])then(parent::tei:subst/@xml:rend)else(@xml:rend)"/>
        <xsl:variable name="xml-data" select="if(parent::tei:subst[@xml:data])then(parent::tei:subst/@xml:data)else(@xml:data)"/>
        <xsl:if test="$xmlrend = 'yes'">
            <div data-xmlid="{@xml:id}" class="d-flex w-100 position-relative">
                <div id="container-{@xml:id}" class="del connect w-100 {replace(@change,'#','')}">
                    <div class="w-100">
                        <xsl:apply-templates select="self::tei:del" mode="manual"/>
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
                <xsl:variable name="subornot" select="if(contains($next/@xml:id, '-sub-'))then($next/tei:add/@xml:id)else($next/@xml:id)"/>
                <div id="container-{$subornot}" class="del connect w-100 {replace($next-change,'#','')}">
                    <div class="w-100">
                        <xsl:choose>
                            <xsl:when test="contains($next/@xml:id, 'add')">
                                <span class="{$next-rend} {replace($next-change,'#','')}">
                                    &#124;&#xA0;<xsl:apply-templates select="$next" mode="manual_iter"/>
                                </span>
                            </xsl:when>
                            <xsl:when test="contains($next/@xml:id, 'del')">
                                <xsl:choose>
                                    <xsl:when test="$next[parent::tei:restore]">
                                        <del class="{$next-rend} {replace(($next/parent::tei:restore/@change)[1],'#','')}">
                                            <span class="{replace($next-change,'#','')}">
                                                &#124;&#xA0;<span class="arimo">&#8368;</span>
                                            </span>
                                        </del>
                                    </xsl:when>
                                    <xsl:when test="count(node())=1 and text()=' ' and not(@resp)">
                                        <span class="{$next-rend} {replace($next-change,'#','')}">
                                            &#124;&#xA0;<span class="arimo">&#8256;</span>
                                        </span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="{$next-rend} {replace($next-change,'#','')}">
                                            &#124;&#xA0;<span class="arimo">&#8368;</span>
                                        </span>
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                            </xsl:when>
                            <xsl:when test="contains($next/@xml:id, '-sub-')">
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

    <xsl:template match="tei:del" mode="manual">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <del class="{@rend} {replace((parent::tei:restore/@change)[1],'#','')}">
                    <span class="{replace(@change,'#','')}">
                        &#124;&#xA0;<span class="arimo">&#8368;</span>
                    </span>
                </del>
            </xsl:when>
            <xsl:otherwise>
                <span class="{@rend} {replace(@change,'#','')}">
                    &#124;&#xA0;<span class="arimo">&#8368;</span>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:del" mode="manual_iter">
        <xsl:if test="not(@function='progress')">
            &#124;&#xA0;
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
   
</xsl:stylesheet>
