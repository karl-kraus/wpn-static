<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:metamark[@function='progress'][@place]">
        <span class="metamark {replace(@change,'#','')} {@place} {@style}" id="{@xml:id}"><xsl:apply-templates/></span>
     </xsl:template>
    <xsl:template match="tei:metamark[@function='progress'][@rend]">
        <span class="metamark mm-inline connect entity {replace(@change,'#','')}" id="{@xml:id}">
           <xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if>
        </span>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='progress' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}"><xsl:apply-templates/></span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='progress' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {replace(@change,'#','')} ms-1" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}"><xsl:apply-templates/></span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='relocation'][@change='#edACE']"/>
     <xsl:template match="tei:metamark[@function='relocation'][not(@change='#edACE')][@place]">
        <span class="metamark mm-inline {@place} {@style} {replace(@change, '#', '')}" id="{@xml:id}">
            <span>&#124;</span>
        </span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='relocation'][not(@change='#edACE')][@rend]">
        <span class="metamark mm-inline connect entity {replace(@change, '#', '')}" id="{@xml:id}">
            <span>&#124;<xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if></span>
        </span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='relocation'][not(@change='#edACE')][not(@rend) and not(@place)]">
        <span class="metamark mm-inline connect {if(@target)then('target')else()} {replace(@change, '#', '')}" id="{@xml:id}">
            <span>
                <xsl:if test="@target">
                    <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                    <xsl:attribute name="data-target">
                        <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                    </xsl:attribute>
                </xsl:if>
                &#124;<xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if>
            </span>
        </span>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {if(@target)then('target')else()} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#124;<xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[not(@change='#edACE')][@function='relocation' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {if(@target)then('target')else()} {replace(@change,'#','')} ms-1" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#124;<xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='printInstruction'][@place]">
        <span class="metamark position-absolute {replace(@rendition,'#','')} {replace(@change,'#','')} {@place} {@style}" id="{@xml:id}"><xsl:apply-templates/></span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='printInstruction'][@rend]">
        <span class="metamark connect entity {replace(@change,'#','')}" id="{@xml:id}">
            <xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if>
        </span>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='printInstruction' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="metamark {if(@spanTo)then('spanto')else()} connect {replace(@change,'#','')} {replace(@rendition,'#','')}" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend} {@style}">
                    <xsl:if test="@spanTo">
                        <xsl:variable name="spanToList" select="tokenize(@spanTo, ' ')"/>
                        <xsl:attribute name="data-spanto">
                            <xsl:value-of select="for $i in $spanToList return concat('spanto-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    <span class="fade">&#124;</span><xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='printInstruction' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="metamark {if(@spanTo)then('spanto')else()} connect {replace(@change,'#','')} {replace(@rendition,'#','')} ms-1" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend} {@style}">
                    <xsl:if test="@spanTo">
                        <xsl:variable name="spanToList" select="tokenize(@spanTo, ' ')"/>
                        <xsl:attribute name="data-spanto">
                            <xsl:value-of select="for $i in $spanToList return concat('spanto-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    <span class="fade">&#124;</span><xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='printInstruction'][@rendition]">
        <span class="metamark {replace(@rendition,'#','')} {replace(@change,'#','')}" id="{@xml:id}"><xsl:apply-templates/></span>
     </xsl:template>

     <xsl:template match="tei:metamark[@function='transposition'][@place]">
        <span class="metamark {replace(@change,'#','')} {@place} {@style}" id="{@xml:id}"><xsl:apply-templates/></span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='transposition'][@rend]">
        <span class="metamark entity connect {replace(@change,'#','')}" id="{@xml:id}"><xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if></span>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='transposition' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {if(@target)then('target')else()} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}" style="font-size:1.25em;">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#423;
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='transposition' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {if(@target)then('target')else()} {replace(@change,'#','')} ms-1" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}" style="font-size:1.25em;">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    &#423;
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='insertion'][@place]">
        <span class="metamark {@style} {@place} {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='insertion'][@rend]">
        <span class="metamark connect entity {replace(@change, '#', '')}" id="{@xml:id}">&#124;</span>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='insertion' and contains(@rend, 'Left')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {if(@target)then('target')else()} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="not(.//text())">&#124;</xsl:if>
                    <xsl:apply-templates/>
                </span>
            </div>
        </div>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='insertion' and contains(@rend, 'Right')]" mode="render">
        <div id="container-{@xml:id}" class="metamark connect {if(@target)then('target')else()} {replace(@change,'#','')} ms-1" data-xmlid="{@xml:id}">
            <div class="position-relative">
                <span class="{@rend}">
                    <xsl:if test="@target">
                        <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                        <xsl:attribute name="data-target">
                            <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="not(.//text())">&#124;</xsl:if>
                    <xsl:apply-templates/>
                </span>
            </div>
        </div>
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