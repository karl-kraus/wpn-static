<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:add[parent::tei:subst[ancestor::tei:restore[not(./tei:seg)]]]">
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)"/>
        <xsl:choose>
            <xsl:when test="$rend = 'inline'">
                <del class="add" id="{@xml:id}"><xsl:apply-templates/></del>
            </xsl:when>
            <xsl:when test="$rend=('below', 'furtherBelow', 'above', 'leftBelow', 'rightBelow', 'rightFurtherBelow', 'leftAbove', 'rightAbove')">
            
                <span class="position-relative">
                    <!-- test: aren't they all supposed to be del?
                    <xsl:variable name="el">
                        <xsl:choose>
                            <xsl:when test="ancestor::tei:del">
                                <xsl:text>del</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>span</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable> -->
                    <xsl:element name="del">
                        <xsl:attribute name="class">
                            <xsl:value-of select="concat('add ', $rend, ' ', replace(@change[1], '#', ''))"/>
                        </xsl:attribute>
                        <xsl:attribute name="id" select="@xml:id"/>
                        &#124;&#xA0;<xsl:apply-templates/>
                    </xsl:element>
                </span>
            </xsl:when>
            <xsl:when test="$rend='overwritten'">
                <del class="add connect overwrite position-absolute start-0{if(ancestor::tei:note)then(' top-0 bottom-0')else()}" id="{@xml:id}"><xsl:apply-templates/></del>
            </xsl:when>
            <xsl:otherwise>
                <del class="add connect entity" id="{@xml:id}"></del>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:add[parent::tei:subst[not(ancestor::tei:restore[not(./tei:seg)])]]|tei:add[parent::tei:span[ancestor::tei:subst[not(ancestor::tei:restore[not(./tei:seg)])]]]">
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(parent::tei:span[parent::tei:span[parent::tei:subst]])then(ancestor::tei:subst/@rend)else(@rend)"/>
        <xsl:choose>
            <xsl:when test="$rend = 'inline'">
                <span class="add" id="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="$rend=('below', 'furtherBelow', 'above', 'leftBelow', 'rightBelow', 'rightFurtherBelow', 'leftAbove', 'rightAbove')">
                
                <xsl:if test="not(parent::tei:subst)">
                    <span class="add {replace(@change, '#', '')}" id="{@xml:id}-inline">&#124;</span>
                </xsl:if>
                
                <span class="position-relative">
                    <xsl:variable name="el">
                        <xsl:choose>
                            <xsl:when test="ancestor::tei:del">
                                <xsl:text>del</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>span</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:element name="{$el}">
                        <xsl:attribute name="class">
                            <xsl:value-of select="concat('add ', $rend, ' ', replace(@change[1], '#', ''))"/>
                        </xsl:attribute>
                        <xsl:attribute name="id" select="@xml:id"/>
                        &#124;&#xA0;<xsl:apply-templates/>
                    </xsl:element>
                </span>
            </xsl:when>
            <xsl:when test="$rend='overwritten'">
                <span class="add connect overwrite position-absolute start-0{if(ancestor::tei:note)then(' top-0 bottom-0')else()}" id="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="add connect entity{if(./tei:metamark[@target])then(' target')else()}" id="{@xml:id}">
                <xsl:if test="./tei:metamark[@target]">
                    <span>
                        <xsl:variable name="targetList" select="tokenize(./tei:metamark[@target]/@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </span>
                </xsl:if>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:add[not(parent::tei:subst) and not(parent::tei:restore)]">
        <xsl:choose>
            <xsl:when test="@rend = 'inline'">
                <span class="add connect entity {replace(@change[1], '#', '')}" id="{@xml:id}">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend=('below', 'furtherBelow', 'above', 'leftBelow', 'rightBelow', 'rightFurtherBelow', 'leftAbove', 'rightAbove')">
                <xsl:if test="not(parent::tei:subst)">
                    <span class="add {replace(@change[1], '#', '')}" id="{@xml:id}-inline">&#124;</span>
                </xsl:if>
                <span class="position-relative">
                    <xsl:variable name="el">
                        <xsl:choose>
                            <xsl:when test="ancestor::tei:del">
                                <xsl:text>del</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>span</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:element name="{$el}">
                        <xsl:attribute name="class">
                            <xsl:value-of select="concat('add ', @rend, ' ', replace(@change[1], '#', ''))"/>
                        </xsl:attribute>
                        <xsl:attribute name="id" select="@xml:id"/>
                        &#124;&#xA0;<xsl:apply-templates/>
                    </xsl:element>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="add connect entity {replace(@change[1], '#', '')} {if(./tei:metamark[@target])then(' target')else()}" id="{@xml:id}">
                    <span>
                        <xsl:if test="./tei:metamark[@target]">
                            <xsl:variable name="targetList" select="tokenize(./tei:metamark[@target]/@target, ' ')"/>
                            <xsl:attribute name="data-target">
                                <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                            </xsl:attribute>
                        </xsl:if>
                        &#124;
                    </span>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:add[parent::tei:restore]">
        <xsl:choose>
            <xsl:when test="parent::tei:restore[not(@rend='marginOnly')]">
                <xsl:choose>
                    <xsl:when test="@rend=('below', 'furtherBelow', 'above', 'leftBelow', 'rightBelow', 'rightFurtherBelow', 'leftAbove', 'rightAbove')">
                        
                        <xsl:if test="not(parent::tei:subst)">
                           <span class="add {replace(@change[1], '#', '')}" id="{@xml:id}-inline">&#124;</span>
                        </xsl:if>
                        
                        <span class="position-relative">
                            <del class="add {@rend} {replace(@change[1], '#', '')}" id="{@xml:id}">
                                &#124;&#xA0;<xsl:apply-templates/>
                            </del>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="add connect entity text-decoration-underline-dotted {replace(@change[1], '#', '')}" id="{@xml:id}">
                            <del>&#124;</del>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <span class="add connect entity {replace(@change[1], '#', '')}" id="{@xml:id}">&#124;</span>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    <xsl:template match="tei:add[@rendition]">
        <span class="add rendition {replace(@rendition,'#','')} {replace(@change[1],'#','')}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- margin container elements -->
    <xsl:template match="tei:add[@rend|parent::tei:subst[@rend]|ancestor::tei:subst[@rend]]" mode="render">
        <xsl:variable name="change" select="if(parent::tei:subst[@change])then(parent::tei:subst/@change)else if(ancestor::tei:subst[@change])then(ancestor::tei:subst/@change)else(@change)"/>
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(ancestor::tei:subst[@rend])then(ancestor::tei:subst/@rend)else(@rend)"/>
        <xsl:variable name="containerID" select="if(parent::tei:subst)then(preceding-sibling::tei:del[1]/@xml:id)else if(ancestor::tei:subst)then(preceding-sibling::tei:del[1])else(@xml:id)"/>
        <div data-xmlid="{@xml:id}" class="d-flex w-100 position-relative">
            <div id="container-{if(string-length($containerID) gt 0)then($containerID)else(@xml:id)}" class="add connect w-100 {replace($change[1],'#','')} {if(./tei:metamark[@target]) then ('target') else ()}">
                <div class="w-100">
                    <xsl:apply-templates select="." mode="manual"/>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:add" mode="manual">
        <xsl:variable name="change" select="if(parent::tei:subst[@change])then(parent::tei:subst/@change)else if(ancestor::tei:subst[@change])then(ancestor::tei:subst/@change)else(@change)"/>
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(ancestor::tei:subst[@rend])then(ancestor::tei:subst/@rend)else(@rend)"/>
        <xsl:choose>
            <xsl:when test="parent::tei:subst[ancestor::tei:restore[not(./tei:seg)]]">
                <xsl:variable name="restore-change" select="(ancestor::tei:restore/@change)[1]"/>
                <del class="{$rend} {replace($restore-change[1],'#','')}">
                    <xsl:if test="./tei:metamark[@target]">
                        <xsl:variable name="targetList" select="tokenize(./tei:metamark[@target]/@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#124;&#xA0;<xsl:apply-templates/>
                </del>
            </xsl:when>
            <xsl:when test="parent::tei:restore">
                <xsl:variable name="restore-change" select="(ancestor::tei:restore/@change)[1]"/>
                <del class="restore {$rend} {replace($restore-change,'#','')}">
                    <xsl:if test="./tei:metamark[@target]">
                        <xsl:variable name="targetList" select="tokenize(./tei:metamark[@target]/@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    <span class="{replace(@change[1],'#','')}">&#124;&#xA0;<xsl:apply-templates/></span>
                </del>
            </xsl:when>
            <xsl:when test="parent::tei:subst[not(parent::tei:restore)]">
                <span class="{$rend} {replace($change[1],'#','')}">
                    <xsl:if test="./tei:metamark[@target]">
                        <xsl:variable name="targetList" select="tokenize(./tei:metamark[@target]/@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#124;&#xA0;<xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="{$rend} {replace($change[1],'#','')}">
                    <xsl:if test="./tei:metamark[@target]">
                        <xsl:variable name="targetList" select="tokenize(./tei:metamark[@target]/@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#124;&#xA0;<xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
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
