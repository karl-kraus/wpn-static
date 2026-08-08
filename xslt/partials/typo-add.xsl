<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:add[parent::tei:subst[ancestor::tei:restore[not(./tei:seg)]]]">
        <xsl:variable name="note-change" select="ancestor::tei:note/@change"/>
        <xsl:variable name="subst-change" select="parent::tei:subst/@change"/>
        <xsl:variable name="tohighlight" select="if($note-change = $subst-change)then('highlight')else('noHighlight')"/>
        <xsl:variable name="highlight" select="if(ancestor::tei:note)then($tohighlight)else('')"/>
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else(@rend)"/>
        <xsl:choose>
            <xsl:when test="$rend='inline'">
                <del class="add {highlight}" data-anchor="{@xml:id} {preceding-sibling::tei:del[1]/@xml:id} {following-sibling::tei:del[1]/@xml:id}"><xsl:apply-templates/></del>
            </xsl:when>
            <xsl:when test="$rend='lineExt'">
                <del class="add $rend {highlight}" data-anchor="{@xml:id} {preceding-sibling::tei:del[1]/@xml:id} {following-sibling::tei:del[1]/@xml:id}"><xsl:apply-templates/></del>
            </xsl:when>
            <xsl:when test="$rend=('below', 'furtherBelow', 'above', 'leftBelow', 'rightBelow', 'rightFurtherBelow', 'leftAbove', 'rightAbove', 'left')">
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
                            <xsl:value-of select="concat('add ', $rend, ' ', replace(@change[1], '#', ''), ' ', $highlight)"/>
                        </xsl:attribute>
                        <xsl:attribute name="data-anchor" select="concat(@xml:id, ' ', preceding-sibling::tei:del[1]/@xml:id, ' ', following-sibling::tei:del[1]/@xml:id)"/>
                        <xsl:attribute name="data-hand" select="if(@change)then(replace(@change[1], '#', ''))else(replace(parent::tei:subst/@change, '#', ''))"/>
                        <xsl:text>&#124;&#xA0;</xsl:text><xsl:apply-templates/>
                    </xsl:element>
                </span>
            </xsl:when>
            <xsl:when test="$rend='overwritten'">
                <del class="add overwrite position-absolute start-0{if(ancestor::tei:note[not(contains(@change, 'typewriter'))] and not(ancestor::tei:add[contains(@change, 'typewriter')]))then(' top-0 bottom-0')else()}" data-anchor="{@xml:id}"><xsl:apply-templates/></del>
            </xsl:when>
            <xsl:otherwise>
                <del id="{@xml:id}" class="add entity" data-anchor="{@xml:id}"></del>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:add[parent::tei:subst[not(ancestor::tei:restore[not(./tei:seg)])]]|tei:add[parent::tei:span[ancestor::tei:subst[not(ancestor::tei:restore[not(./tei:seg)])]]]">
        <xsl:variable name="note-change" select="ancestor::tei:note/@change"/>
        <xsl:variable name="subst-change" select="parent::tei:subst/@change"/>
        <xsl:variable name="tohighlight" select="if($note-change = $subst-change)then('highlight')else('noHighlight')"/>
        <xsl:variable name="highlight" select="if(ancestor::tei:note)then($tohighlight)else('')"/>
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(parent::tei:span[parent::tei:span[parent::tei:subst]])then(ancestor::tei:subst/@rend)else(@rend)"/>
        <xsl:choose>
            <xsl:when test="$rend = 'inline'">
                <span class="add inline {highlight}" data-anchor="{@xml:id} {preceding-sibling::tei:del[1]/@xml:id} {following-sibling::tei:del[1]/@xml:id}"><xsl:apply-templates/></span> <!-- added "inline" class esp. for para 64  -->
            </xsl:when>
            
            <xsl:when test="$rend = 'lineExt'">
                <span class="add {$rend} {highlight}" data-anchor="{@xml:id} {preceding-sibling::tei:del[1]/@xml:id} {following-sibling::tei:del[1]/@xml:id}"><xsl:apply-templates/></span> <!-- added "inline" class esp. for para 64  -->
            </xsl:when>
            <xsl:when test="$rend=('below', 'furtherBelow', 'above', 'leftBelow', 'rightBelow', 'rightFurtherBelow', 'leftAbove', 'rightAbove', 'rightAbove2','left')">
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
                            <xsl:value-of select="concat('add ', $rend, ' ', replace(@change[1], '#', ''), ' ', $highlight)"/>
                        </xsl:attribute>
                        <xsl:attribute name="data-anchor" select="concat(@xml:id, ' ', preceding-sibling::tei:del[1]/@xml:id, ' ', following-sibling::tei:del[1]/@xml:id)"/>
                        <xsl:attribute name="data-hand" select="if(@change)then(replace(@change[1], '#', ''))else(replace(parent::tei:subst/@change, '#', ''))"/>
                        <xsl:text>&#124;&#xA0;</xsl:text><xsl:apply-templates/>
                    </xsl:element>
                </span>
            </xsl:when>
            <xsl:when test="$rend='overwritten'">
                <span class="add overwrite position-absolute start-0{if(ancestor::tei:note[not(contains(@change, 'typewriter'))] and not(ancestor::tei:add[contains(@change, 'typewriter')]))then(' top-0 bottom-0')else()} {replace(@change[1], '#', '')} {highlight}" data-anchor="{@xml:id}" data-hand="{if(@change)then(replace(@change[1],'#','')) else(replace(parent::tei:subst/@change,'#',''))}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:when test="not($rend)">
                <span id="{@xml:id}" class="add entity {highlight}" data-anchor="{@xml:id}">
                    <xsl:if test="./tei:metamark[@target]">
                        <xsl:variable name="targetList" select="tokenize(./tei:metamark[@target]/@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                        </xsl:attribute>
                    </xsl:if>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span id="{@xml:id}" class="add entity {highlight}" data-anchor="{@xml:id}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:add[not(parent::tei:subst) and not(parent::tei:restore)]">
        <xsl:variable name="note-change" select="ancestor::tei:note/@change"/>
        <xsl:variable name="change" select="@change"/>
        <xsl:variable name="tohighlight" select="if($note-change = $change)then('highlight')else('noHighlight')"/>
        <xsl:variable name="highlight" select="if(ancestor::tei:note)then($tohighlight)else('')"/>
        <xsl:variable name="inheritIDfromNote" select="if(ancestor::tei:note[@place or @rendition][@xml:id and not(preceding::tei:pb[contains(@n, '_')])])then(ancestor::tei:note/@xml:id)else()"/>
        <xsl:choose>
            <xsl:when test="@rend='inline' or @rend='lineExt'">
                <span id="{@xml:id}" class="add {@rend} {highlight} entity {replace(@change[1], '#', '')}" data-hand="{replace(@change[1],'#','')}"> <!-- added "inline" class esp. for para 64  -->
                    <xsl:attribute name="data-anchor">
                        <xsl:value-of select="@xml:id"/>
                        <xsl:if test="ancestor::tei:note">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$inheritIDfromNote"/>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend=('below', 'furtherBelow', 'above', 'leftBelow', 'rightBelow', 'rightFurtherBelow', 'leftAbove', 'rightAbove', 'left')">
                <span class="add {highlight} {replace(@change[1], '#', '')}" data-hand="{replace(@change[1],'#','')}">
                    <xsl:attribute name="data-anchor">
                        <xsl:value-of select="@xml:id"/>
                        <xsl:if test="ancestor::tei:note">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$inheritIDfromNote"/>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:text>&#124;</xsl:text>
                </span>
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
                            <xsl:value-of select="concat('add ', @rend, ' ', $highlight, ' ', replace(@change[1], '#', ''))"/>
                        </xsl:attribute>
                        <xsl:attribute name="data-anchor" select="@xml:id"/>
                        <xsl:attribute name="data-hand" select="replace(@change[1], '#', '')"/>
                        <xsl:text>&#124;&#xA0;</xsl:text><xsl:apply-templates/>
                    </xsl:element>
                </span>
            </xsl:when>
            <xsl:when test="not(@rend)">
                <span id="{@xml:id}" class="add {highlight} connect entity {replace(@change[1], '#', '')}" data-hand="{replace(@change[1],'#','')}">
                    <xsl:if test="./tei:metamark[@target]">
                        <xsl:variable name="targetList" select="tokenize(./tei:metamark[@target]/@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="data-anchor">
                        <xsl:value-of select="@xml:id"/>
                        <xsl:if test="ancestor::tei:note">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$inheritIDfromNote"/>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:text>&#124;</xsl:text>
                </span>
            </xsl:when>
            <xsl:when test="contains(@rend, 'Only')">
                <span id="{@xml:id}" class="add {highlight} entity {replace(@change[1], '#', '')}" data-hand="{replace(@change[1],'#','')}">
                    <xsl:attribute name="data-anchor">
                        <xsl:value-of select="@xml:id"/>
                        <xsl:if test="ancestor::tei:note">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$inheritIDfromNote"/>
                        </xsl:if>
                    </xsl:attribute>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span id="{@xml:id}" class="add entity {highlight} {replace(@change[1], '#', '')}" data-hand="{replace(@change[1],'#','')}">
                    <xsl:attribute name="data-anchor">
                        <xsl:value-of select="@xml:id"/>
                        <xsl:if test="ancestor::tei:note">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$inheritIDfromNote"/>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:text>&#124;</xsl:text>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:add[parent::tei:restore]">
        <xsl:variable name="note-change" select="ancestor::tei:note/@change"/>
        <xsl:variable name="change" select="@change"/>
        <xsl:variable name="tohighlight" select="if($note-change = $change)then('highlight')else('noHighlight')"/>
        <xsl:variable name="highlight" select="if(ancestor::tei:note)then($tohighlight)else('')"/>
        <xsl:choose>
            <xsl:when test="parent::tei:restore[not(@rend='marginOnly')]">
                <xsl:choose>
                    <xsl:when test="@rend=('below', 'furtherBelow', 'above', 'leftBelow', 'rightBelow', 'rightFurtherBelow', 'leftAbove', 'rightAbove')">
                        <xsl:if test="not(parent::tei:subst)">
                           <del class="add {highlight} {replace(@change[1], '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change[1],'#','')}"><xsl:text>&#124;</xsl:text></del>
                        </xsl:if>
                        <span class="position-relative">
                            <del class="add {@rend} {highlight} {replace(@change[1], '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change[1],'#','')}">
                                <xsl:text>&#124;&#xA0;</xsl:text><xsl:apply-templates/>
                            </del>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="ancestor::tei:del">
                                <span id="{@xml:id}" class="add entity text-decoration-underline-dotted {highlight} {replace(@change[1], '#', '')}">
                                    <span data-anchor="{@xml:id}" data-hand="{replace(@change[1],'#','')}"><xsl:text>&#124;</xsl:text></span>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span id="{@xml:id}" class="add entity text-decoration-underline-dotted {highlight} {replace(@change[1], '#', '')}">
                                    <del data-anchor="{@xml:id}" data-hand="{replace(@change[1],'#','')}"><xsl:text>&#124;</xsl:text></del>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                     <xsl:when test="contains(@rend, 'Only')">
                         <span id="{@xml:id}" class="add entity {highlight} {replace(@change[1], '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change[1],'#','')}"/>
                     </xsl:when>
                    <xsl:otherwise>
                        <span id="{@xml:id}" class="add entity {highlight} {replace(@change[1], '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change[1],'#','')}"><xsl:text>&#124;</xsl:text></span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:add[@rendition]">
        <xsl:variable name="note-change" select="ancestor::tei:note/@change"/>
        <xsl:variable name="change" select="@change"/>
        <xsl:variable name="tohighlight" select="if($note-change = $change)then('highlight')else('noHighlight')"/>
        <xsl:variable name="highlight" select="if(ancestor::tei:note)then($tohighlight)else('')"/>
        <span data-anchor="{replace(@change[1], '#', '')}" class="add rendition {highlight} {replace(@rendition,'#','')} {replace(@change[1],'#','')}"><xsl:apply-templates/></span>
    </xsl:template>
    <!-- margin container elements -->
    <xsl:template match="tei:add[@rend|parent::tei:subst[@rend]|ancestor::tei:subst[@rend]]" mode="render">
        <!-- potentially remove change but check with Bernhard-->
        <xsl:variable name="change" select="if(parent::tei:subst[@change])then(parent::tei:subst/@change)else if(ancestor::tei:subst[@change])then(ancestor::tei:subst/@change)else(@change)"/>
        <xsl:variable name="containerID" select="
            if(parent::tei:subst)
            then(
                if(preceding-sibling::tei:del[1][@xml:id])
                then(concat(preceding-sibling::tei:del[1]/@xml:id, ' ', preceding-sibling::tei:del[1]/tei:restore/tei:subst/tei:del[1]/@xml:id))
                else(concat(following-sibling::tei:del[1]/@xml:id, ' ', following-sibling::tei:del[1]/tei:restore/tei:subst/tei:del[1]/@xml:id)))
            else if(ancestor::tei:subst)
                then(
                    if(preceding-sibling::tei:del[1][@xml:id])
                    then(concat(preceding-sibling::tei:del[1]/@xml:id, ' ', preceding-sibling::tei:del[1]/tei:restore/tei:subst/tei:del[1]/@xml:id))
                    else(concat(following-sibling::tei:del[1]/@xml:id, ' ', following-sibling::tei:del[1]/tei:restore/tei:subst/tei:del[1]/@xml:id)))
                else(@xml:id)"/>
        <div data-xmlid="{@xml:id}" class="d-flex w-100 position-relative">
            <div class="add w-100 {replace($change[1],'#','')}">
                <div class="w-100">
                    <xsl:apply-templates select="." mode="manual">
                        <xsl:with-param name="id" select="if(string-length(normalize-space($containerID)) gt 0)then($containerID)else(@xml:id)"/>
                    </xsl:apply-templates>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:add" mode="manual">
        <xsl:param name="id" select="@xml:id"/>
        <xsl:variable name="change" select="if(parent::tei:subst[@change])then(parent::tei:subst/@change)else if(ancestor::tei:subst[@change])then(ancestor::tei:subst/@change)else(@change)"/>
        <xsl:variable name="rend" select="if(parent::tei:subst[@rend])then(parent::tei:subst/@rend)else if(ancestor::tei:subst[@rend])then(ancestor::tei:subst/@rend)else(@rend)"/>
        <xsl:choose>
            <xsl:when test="parent::tei:subst[ancestor::tei:restore[not(./tei:seg)]]">
                <xsl:variable name="restore-change" select="(ancestor::tei:restore/@change)[1]"/>
                <del data-anchor="{$id}" data-hand="{replace($restore-change[1],'#','')}{if(ancestor::tei:restore[ancestor::tei:subst])then(replace(ancestor::tei:restore/ancestor::tei:subst/@change,'#',' '))else()}" class="{$rend} {replace($restore-change[1],'#','')}">
                    <xsl:if test="./tei:metamark[@target]">
                        <xsl:variable name="targetList" select="tokenize(./tei:metamark[@target]/@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:text>&#124;&#xA0;</xsl:text><xsl:apply-templates/>
                </del>
            </xsl:when>
            <xsl:when test="parent::tei:restore">
                <xsl:variable name="restore-change" select="(ancestor::tei:restore/@change)[1]"/>
                <del data-hand="{replace($restore-change,'#','')}" class="restore {$rend} {replace($restore-change,'#','')}">
                    <xsl:if test="./tei:metamark[@target]">
                        <xsl:variable name="targetList" select="tokenize(./tei:metamark[@target]/@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <span data-anchor="{$id}" data-hand="{replace(@change[1],'#','')}" class="{replace(@change[1],'#','')}"><xsl:text>&#124;&#xA0;</xsl:text><xsl:apply-templates/></span>
                </del>
            </xsl:when>
            <xsl:when test="parent::tei:subst[not(parent::tei:restore)]">
                <span data-anchor="{$id}" data-hand="{replace($change[1],'#','')}" class="{$rend} {replace($change[1],'#','')}">
                    <xsl:if test="./tei:metamark[@target]">
                        <xsl:variable name="targetList" select="tokenize(./tei:metamark[@target]/@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:text>&#124;&#xA0;</xsl:text><xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span data-anchor="{$id}" data-hand="{replace($change[1],'#','')}" class="{$rend} {replace($change[1],'#','')}">
                    <xsl:if test="./tei:metamark[@target]">
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="./tei:metamark[1][@target]"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:text>&#124;&#xA0;</xsl:text><xsl:apply-templates/>
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
