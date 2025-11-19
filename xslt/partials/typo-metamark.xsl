<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:metamark[@function='progress'][@place]">
        <span class="metamark progress position-absolute {replace(@change,'#','')} {@place} {@style}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
            <xsl:apply-templates/>
        </span>
     </xsl:template>
    <xsl:template match="tei:metamark[@function='progress'][@rend]">
        <xsl:choose>
            <xsl:when test="@rend='inline'">
                <span class="metamark progress mm-inline entity {replace(@change,'#','')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
                   <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend='right'">
                <span class="metamark progress mm-inline right entity {replace(@change,'#','')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
                   <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="metamark progress mm-inline entity {replace(@change,'#','')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
                </span>
            </xsl:otherwise>
        </xsl:choose>
    
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='progress']" mode="render">
        <div class="d-flex metamark progress w-100 position-relative {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="w-100">
                <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="{@rend}"><xsl:apply-templates/></span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='relocation'][@change='#edACE']"/>
     <xsl:template match="tei:metamark[@function='relocation'][not(@change='#edACE')][@place]">
        <span class="metamark mm-inline {@place} {@style} {replace(@change, '#', '')}">
            <xsl:if test="not(id(data(replace(@target, '#', '')))[@rend='arrow'])">
                <span data-anchor="{@xml:id}"><xsl:text>&#124;</xsl:text></span>
            </xsl:if>
        </span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='relocation'][not(@change='#edACE')][@rend][not(parent::tei:restore)]">
        <span class="metamark entity mm-inline {replace(@change, '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
            <xsl:if test="not(id(data(replace(@target, '#', '')))[@rend='arrow'])">
                <span class="entity" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>&#124;</xsl:text></span>
            </xsl:if>
            <xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if>
        </span>
     </xsl:template>
    <xsl:template match="tei:metamark[@function='relocation'][not(@change='#edACE')][@rend][parent::tei:restore]">
        <span class="metamark mm-inline {replace(@change, '#', '')}">
            <del class="entity" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>&#124;</xsl:text></del>
        </span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='relocation'][not(@change='#edACE')][not(@rend) and not(@place)]">
        <span class="metamark mm-inline entity {if(@target)then('target')else()} {replace(@change, '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
            <xsl:if test="@target">
                <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                <xsl:attribute name="data-target">
                    <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="not(id(data(replace(@target, '#', '')))[@rend='arrow'])">
                <xsl:text>&#124;</xsl:text>
            </xsl:if>
            <xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if>
        </span>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[not(@change='#edACE')][@function='relocation']" mode="render">
        <div class="d-flex metamark w-100 position-relative {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="w-100">
                <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="{@rend}">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="not(id(data(replace(@target, '#', '')))[@rend='arrow'])">
                        <xsl:choose>
                            <xsl:when test="parent::tei:restore">
                                <del data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>&#124;</xsl:text></del>
                            </xsl:when>
                            <xsl:otherwise>
                                <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>&#124;</xsl:text></span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='printInstruction'][@place]">
        <span class="metamark position-absolute {replace(@rendition,'#','')} {replace(@change,'#','')} {@place} {@style}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:apply-templates/></span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='printInstruction'][@rend]">
         <xsl:choose>
             <xsl:when test="@rend='above'">
                 <span class="position-relative">
                     <span class="metamark {@rend} {replace(@change,'#','')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
                         <xsl:apply-templates/>
                     </span>
                 </span>
             </xsl:when>
             <xsl:otherwise>
                <span class="metamark entity {replace(@change,'#','')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
                    <xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if>
                </span>
             </xsl:otherwise>
         </xsl:choose>
     </xsl:template>
    <xsl:template match="tei:metamark[contains(@function, 'printSpan')][@rend]">
         <xsl:choose>
             <xsl:when test="@rend='inline'">
                 <span class="position-absolute">
                     <span class="metamark {@function} {@rend} {replace(@change,'#','')} connection-color-line" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
                         <xsl:apply-templates/>
                     </span>
                 </span>
             </xsl:when>
             <xsl:otherwise>
                <span class="metamark entity {@function} {replace(@change,'#','')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
                </span>
             </xsl:otherwise>
         </xsl:choose>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='printInstruction' or contains(@function, 'printSpan')][@rend]" mode="render">
        <div class="d-flex metamark w-100 position-relative {replace(@change,'#','')} {replace(@rendition,'#','')}" data-xmlid="{@xml:id}">
            <div class="w-100">
                <span data-anchor="{@xml:id} {replace(@corresp, '#', '')}" data-hand="{replace(@change,'#','')}" class="{@rend} {@function} {@style} connection-color-line">
                    <!-- <xsl:if test="@corresp">
                        <xsl:attribute name="data-corresp">
                            <xsl:value-of select="replace(@corresp, '#', '')"/>
                        </xsl:attribute>
                    </xsl:if> -->
                    <!-- <xsl:if test="@spanTo">
                        <xsl:variable name="spanToList" select="tokenize(@spanTo, ' ')"/>
                        <xsl:attribute name="data-spanto">
                            <xsl:value-of select="for $i in $spanToList return concat('spanto-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if> -->
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <span class="fade"><xsl:text>&#124;</xsl:text></span><xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='printInstruction'][@rendition]">
         <xsl:choose>
            <xsl:when test="@rendition='#typescriptFont'">
                <span class="metamark {replace(@rendition,'#','')}" data-anchor="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:when>
             <xsl:when test="@rend='inline'">
                <span class="metamark inline {replace(@rendition,'#','')} {replace(@change,'#','')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:apply-templates/></span>
            </xsl:when>
             <xsl:when test="@place">
                <span class="metamark position-absolute {replace(@rendition,'#','')} {replace(@change,'#','')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="metamark {replace(@rendition,'#','')} {replace(@change,'#','')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:apply-templates/></span>
            </xsl:otherwise>
         </xsl:choose>
     </xsl:template>

    <xsl:template match="tei:metamark[@function='modification']">
       <span class="metamark entity {replace(@change,'#','')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"/>
    </xsl:template>
     <!-- margin container elements -->
    <xsl:template match="tei:metamark[@function='modification']" mode="render">
        <div class="d-flex metamark w-100 position-relative {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="w-100">
                <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="{@rend}{if(parent::tei:restore)then(replace((parent::tei:restore/@change)[1], '#', ' restore '))else()}">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="parent::tei:restore">
                            <del data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
                                <xsl:apply-templates/>
                            </del>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:metamark[@function='undefined']">
        <xsl:choose>
            <xsl:when test="contains(@rend, 'Only')">
                 <span class="metamark entity {replace(@change,'#','')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"/>
            </xsl:when>
            <xsl:when test="parent::restore">
                <del class="metamark entity {replace(@change, '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:text>&#124;</xsl:text></del>
            </xsl:when>
            <xsl:otherwise>
                 <span class="metamark entity {replace(@change, '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
                     <xsl:if test="not(.//text())"><xsl:text>&#124;</xsl:text></xsl:if>
                     <xsl:apply-templates/>
                 </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- margin container elements -->
    <xsl:template match="tei:metamark[@function='undefined']" mode="render">
        <div class="d-flex metamark w-100 position-relative {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="w-100">
                <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')} {if(parent::tei:restore[@change])then(replace(parent::tei:restore/@change, '#', ''))else()}" class="{@rend}{if(parent::tei:restore)then(replace((parent::tei:restore/@change)[1], '#', ' restore '))else()}">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="parent::tei:restore">
                            <del data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
                                <xsl:if test="not(.//text()) or not(self::tei:metamark[@function='progress'])"><xsl:text>&#124;</xsl:text></xsl:if>
                                <xsl:apply-templates/>
                            </del>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="not(.//text()) or not(self::tei:metamark[@function='progress'])"><xsl:text>&#124;</xsl:text></xsl:if>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </div>
        </div>
    </xsl:template>

     <xsl:template match="tei:metamark[@function='transposition'][@place]">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="metamark {replace(@change,'#','')} {@place} {@style}">
                    <del data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:apply-templates/></del>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="metamark {replace(@change,'#','')} {@place} {@style}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='transposition'][@rend]">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="metamark {replace(@change,'#','')}">
                    <del class="entity" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if></del>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="metamark entity {replace(@change,'#','')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}"><xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if></span>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='transposition']" mode="render">
        <div class="d-flex metamark w-100 position-relative {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="w-100">
                <span class="{@rend} {if(parent::tei:restore)then(replace((parent::tei:restore/@change)[1], '#', ' restore '))else()}" style="font-size:1.5rem; top:-0.2rem">
                    <xsl:choose>
                        <xsl:when test="parent::tei:restore">
                            <del data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')} {if(parent::tei:restore[@change])then(replace(parent::tei:restore/@change, '#', ''))else()}" style="text-decoration-thickness: 1px;">
                                <xsl:if test="@target">
                                    <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                                    <xsl:attribute name="data-target">
                                        <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:text>&#8766;</xsl:text>
                            </del>
                        </xsl:when>
                        <xsl:otherwise>
                            <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')} {if(parent::tei:restore[@change])then(replace(parent::tei:restore/@change, '#', ''))else()}">
                                <xsl:if test="@target">
                                    <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                                    <xsl:attribute name="data-target">
                                        <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:text>&#8766;</xsl:text>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='insertion'][@place]">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="metamark position-absolute {@style} {@place} {replace(@change, '#', '')}">
                    <del data-anchor="{@xml:id}"><xsl:apply-templates/></del>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="metamark position-absolute {@style} {@place} {replace(@change, '#', '')}" data-anchor="{@xml:id}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='insertion'][@rend]">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <xsl:choose>
                    <xsl:when test="not(contains(@rend, 'Only'))">
                        <span class="metamark {replace(@change, '#', '')}">
                            <del class="entity" data-anchor="{@xml:id}">
                                <xsl:if test="@target">
                                    <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                                    <xsl:attribute name="data-target">
                                        <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:text>&#124;</xsl:text>
                            </del>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="metamark entity {replace(@change, '#', '')}" data-anchor="{@xml:id}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@rend='lineSpace'">
                        <span class="metamark linespace entity {replace(@change, '#', '')}" data-anchor="{@xml:id}"/>
                    </xsl:when>
                    <xsl:when test="@rend='inlineRight'">
                        <span class="metamark {@rend} {@style} {replace(@change, '#', '')}" data-anchor="{@xml:id}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:when test="contains(@rend, 'Only')">
                        <span class="metamark entity {replace(@change, '#', '')}" data-anchor="{@xml:id}"/>
                    </xsl:when>
                    <xsl:when test="@rend='other'">
                        <xsl:choose>
                            <xsl:when test="parent::tei:add[@rend or parent::tei:subst[@rend]]">
                                <xsl:text>&#124;</xsl:text>
                            </xsl:when>
                            <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="@rend='inline' and ./text()">
                        <span class="metamark entity {replace(@change, '#', '')}" data-anchor="{@xml:id}">
                            <xsl:if test="@target">
                                <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                                <xsl:attribute name="data-target">
                                    <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>&#124;&#xA0;</xsl:text><xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="metamark entity {replace(@change, '#', '')}" data-anchor="{@xml:id}">
                            <xsl:if test="@target">
                                <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                                <xsl:attribute name="data-target">
                                    <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>&#124;</xsl:text>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='insertion' and not(@rend='inlineRight')]" mode="render">
        <div class="d-flex metamark w-100 position-relative {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="w-100">
                <span data-anchor="{@xml:id}" class="{@rend}{if(parent::tei:restore)then(replace((parent::tei:restore/@change)[1], '#', ' restore '))else()}">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return substring-after($i, '#')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="parent::tei:restore">
                            <del data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
                                <xsl:if test="not(.//text()) or not(self::tei:metamark[@function='progress'])"><xsl:text>&#124;</xsl:text></xsl:if>
                                <xsl:apply-templates/>
                            </del>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="not(.//text()) or not(self::tei:metamark[@function='progress'])"><xsl:text>&#124;</xsl:text></xsl:if>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:metamark" mode="manual_iter">
        <xsl:if test="self::tei:metamark[not(@function='progress')]">
            <xsl:text>&#124;&#xA0;</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- <xsl:template match="tei:metamark[@function=('insertion','relocation') and not(matches(@target,'(note)+.*([a-z])_'))]">
       <xsl:variable name="target" select="replace(@target,'#','')"/>
        <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//(tei:seg|tei:note)[@xml:id=$target]" mode="render"/>
    </xsl:template> -->
    <!-- <xsl:template match="tei:metamark[@function=('insertion') and matches(@target,'(note)+.*([a-z])_')]">
       <xsl:variable name="target" select="replace(@target,'#','')"/>
       <wpn-entity>
       <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//tei:note[@xml:id=$target]" mode="render"/>
       </wpn-entity>
    </xsl:template> -->
     <!-- <xsl:template match="tei:metamark[@function=('printInstruction','undefined','progress')]">
        <span class="metamark {replace(@change, '#', '')} {@rend} {replace(@rendition, '#', '')} {@place}"><xsl:apply-templates/></span>
     </xsl:template> -->
</xsl:stylesheet>
