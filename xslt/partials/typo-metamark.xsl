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
     <xsl:template match="tei:metamark[@function='progress']" mode="render">
        <xsl:variable name="xmlrend" select="if(parent::tei:subst[@xml:rend])then(parent::tei:subst/@xml:rend)else(@xml:rend)"/>
        <xsl:if test="$xmlrend = 'yes'">
            <div id="container-{@xml:id}" class="d-flex metamark connect w-100 position-relative {replace(@change,'#','')}" data-xmlid="{@xml:id}">
                <div class="w-100">
                    <span class="{@rend}"><xsl:apply-templates/></span>
                </div>
            
                <xsl:call-template name="wrapper-iter">
                    <xsl:with-param name="xmldata" select="tokenize(@xml:data, '/')"/>
                </xsl:call-template>
            </div>
        </xsl:if>
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
     <xsl:template match="tei:metamark[not(@change='#edACE')][@function='relocation']" mode="render">
        <xsl:variable name="xmlrend" select="if(parent::tei:subst[@xml:rend])then(parent::tei:subst/@xml:rend)else(@xml:rend)"/>
        <xsl:if test="$xmlrend = 'yes'">
            <div id="container-{@xml:id}" class="d-flex metamark connect w-100 position-relative  {if(@target)then('target')else()} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
                <div class="w-100">
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
                <xsl:call-template name="wrapper-iter">
                    <xsl:with-param name="xmldata" select="tokenize(@xml:data, '/')"/>
                </xsl:call-template>
            </div>
        </xsl:if>
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
     <xsl:template match="tei:metamark[@function='printInstruction']" mode="render">
        <xsl:variable name="xmlrend" select="if(parent::tei:subst[@xml:rend])then(parent::tei:subst/@xml:rend)else(@xml:rend)"/>
        <xsl:if test="$xmlrend = 'yes'">
            <div id="container-{@xml:id}" class="d-flex metamark w-100 position-relative {if(@spanTo)then('spanto')else()} connect {replace(@change,'#','')} {replace(@rendition,'#','')}" data-xmlid="{@xml:id}">
                <div class="w-100">
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
                <xsl:call-template name="wrapper-iter">
                    <xsl:with-param name="xmldata" select="tokenize(@xml:data, '/')"/>
                </xsl:call-template>
            </div>
        </xsl:if>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='printInstruction'][@rendition]">
        <span class="metamark {replace(@rendition,'#','')} {replace(@change,'#','')}" id="{@xml:id}"><xsl:apply-templates/></span>
     </xsl:template>

     <xsl:template match="tei:metamark[@function='transposition'][@place]">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="metamark {replace(@change,'#','')} {@place} {@style}" id="{@xml:id}">
                    <del><xsl:apply-templates/></del>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="metamark {replace(@change,'#','')} {@place} {@style}" id="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='transposition'][@rend]">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="metamark entity connect {replace(@change,'#','')}" id="{@xml:id}">
                    <del><xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if></del>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="metamark entity connect {replace(@change,'#','')}" id="{@xml:id}"><xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if></span>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='transposition']" mode="render">
        <xsl:variable name="xmlrend" select="if(parent::tei:subst[@xml:rend])then(parent::tei:subst/@xml:rend)else(@xml:rend)"/>
        <xsl:if test="$xmlrend = 'yes'">
            <div id="container-{@xml:id}" class="d-flex metamark connect w-100 position-relative {if(@target)then('target')else()} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
                <div class="w-100">
                    <span class="{@rend}{if(parent::tei:restore)then(replace((parent::tei:restore/@change)[1], '#', ' restore '))else()}" style="font-size:1.25em;">
                        <xsl:if test="@target">
                            <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                            <xsl:attribute name="data-target">
                                <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="parent::tei:restore">
                                <del><xsl:text>&#423;</xsl:text></del>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#423;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>
                </div>
                <xsl:call-template name="wrapper-iter">
                    <xsl:with-param name="xmldata" select="tokenize(@xml:data, '/')"/>
                </xsl:call-template>
            </div>
        </xsl:if>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='insertion'][@place]">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="metamark {@style} {@place} {replace(@change, '#', '')}" id="{@xml:id}">
                    <del><xsl:apply-templates/></del>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="metamark {@style} {@place} {replace(@change, '#', '')}" id="{@xml:id}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='insertion'][@rend]">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="metamark connect entity {replace(@change, '#', '')}" id="{@xml:id}">
                    <del>&#124;</del>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="metamark connect entity {replace(@change, '#', '')}" id="{@xml:id}">&#124;</span>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>
     <!-- margin container elements -->
     <xsl:template match="tei:metamark[@function='insertion']" mode="render">
        <xsl:variable name="xmlrend" select="if(parent::tei:subst[@xml:rend])then(parent::tei:subst/@xml:rend)else(@xml:rend)"/>
        <xsl:if test="$xmlrend = 'yes'">
            <div id="container-{@xml:id}" class="d-flex metamark connect w-100 position-relative {if(@target)then('target')else()} {replace(@change,'#','')}" data-xmlid="{@xml:id}">
                <div class="w-100">
                    <span class="{@rend}{if(parent::tei:restore)then(replace((parent::tei:restore/@change)[1], '#', ' restore '))else()}">
                        <xsl:if test="@target">
                            <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                            <xsl:attribute name="data-target">
                                <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="parent::tei:restore">
                                <del>
                                    <xsl:if test="not(.//text())">&#124;</xsl:if>
                                    <xsl:apply-templates/>
                                </del>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="not(.//text())">&#124;</xsl:if>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>
                </div>
                <xsl:call-template name="wrapper-iter">
                    <xsl:with-param name="xmldata" select="tokenize(@xml:data, '/')"/>
                </xsl:call-template>
            </div>
        </xsl:if>
     </xsl:template>

    <xsl:template name="wrapper-iter">
        <xsl:param name="xmldata" />
        <xsl:variable name="tei" select="ancestor::tei:TEI"/>
        <xsl:iterate select="$xmldata">
            <xsl:if test="string-length(current()) != 0">
                <xsl:variable name="next" select="$tei//tei:*[@xml:id=current()]" as="element()"/>
                <xsl:variable name="next-change" select="if($next[parent::tei:subst[@change]])then($next/parent::tei:subst/@change)else($next/@change)"/>
                <xsl:variable name="next-rend" select="if($next[parent::tei:subst[@rend]])then($next/parent::tei:subst/@rend)else($next/@rend)"/>
                <xsl:variable name="subornot" select="if(contains($next/@xml:id, '-sub-'))then($next/tei:add/@xml:id)else($next/@xml:id)"/>
                <div id="container-{$subornot}" class="ms-1 del connect w-100 {replace($next-change,'#','')}">
                    <div class="w-100">
                        <xsl:choose>
                            <xsl:when test="contains($next/@xml:id, 'add')">
                                <span class="{$next-rend}">
                                    &#124;&#xA0;<xsl:apply-templates select="$next" mode="manual_iter"/>
                                </span>
                            </xsl:when>
                            <xsl:when test="contains($next/@xml:id, 'del')">
                                <span class="{$next-rend}">
                                    &#124;&#xA0;<xsl:apply-templates select="$next" mode="manual_iter"/>
                                </span>
                            </xsl:when>
                            <xsl:when test="contains($next/@xml:id, '-sub-')">
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

    <xsl:template match="tei:metamark" mode="manual_iter">
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