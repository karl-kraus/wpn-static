<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:metamark[@function='progress'][@place]">
        <span class="position-relative">
            <span class="metamark position-absolute {replace(@change,'#','')} {@place} {@style}" id="{@xml:id}">
                <xsl:apply-templates/>
            </span>
        </span>
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
            <xsl:if test="not(id(data(replace(@target, '#', '')))[@rend='arrow'])">
                <span>&#124;</span>
            </xsl:if>
        </span>
     </xsl:template>
     <xsl:template match="tei:metamark[@function='relocation'][not(@change='#edACE')][@rend]">
        <span class="metamark mm-inline connect entity {replace(@change, '#', '')}" id="{@xml:id}">
            <xsl:if test="not(id(data(replace(@target, '#', '')))[@rend='arrow'])">
                <span>&#124;</span>
            </xsl:if>
            <xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if>
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
                <span class="metamark mm-inline connect entity {replace(@change, '#', '')}" id="{@xml:id}">
                    <xsl:if test="not(id(data(replace(@target, '#', '')))[@rend='arrow'])">
                        <span>&#124;</span>
                    </xsl:if>
                    <xsl:if test="@rend='inline'"><xsl:apply-templates/></xsl:if>
                </span>
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
                        <xsl:if test="not(id(data(replace(@target, '#', '')))[@rend='arrow'])">
                            <span>&#124;</span>
                        </xsl:if>
                        <xsl:apply-templates/>
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
                    <span class="{@rend} {if(parent::tei:restore)then(replace((parent::tei:restore/@change)[1], '#', ' restore '))else()}" style="font-size:1.25em;">
                        <xsl:if test="@target">
                            <xsl:variable name="targetList" select="tokenize(@target, ' ')"/>
                            <xsl:attribute name="data-target">
                                <xsl:value-of select="for $i in $targetList return concat('target-', substring-after($i, '#'))"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="parent::tei:restore">
                                <del><xsl:text>&#8766;</xsl:text></del>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#8766;</xsl:text>
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
                <xsl:if test="not(contains(@rend, 'Only'))">
                    <span class="metamark connect entity {replace(@change, '#', '')}" id="{@xml:id}">
                        <del>&#124;</del>
                    </span>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(contains(@rend, 'Only'))">
                    <span class="metamark connect entity {replace(@change, '#', '')}" id="{@xml:id}">&#124;</span>
                </xsl:if>
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
                                    <xsl:if test="not(.//text()) or not(self::tei:metamark[@function='progress'])">&#124;</xsl:if>
                                    <xsl:apply-templates/>
                                </del>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="not(.//text()) or not(self::tei:metamark[@function='progress'])">&#124;</xsl:if>
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
                                                <!-- <svg xmlns="http://www.w3.org/2000/svg" xmlns:dc="http://purl.org/dc/elements/1.1/" fill="currentColor" viewBox="0 0 8.99 16.04">
                                                    <metadata>
                                                    <dc:creator>Bernhard Oberreither</dc:creator>
                                                    <dc:creator>https://d-nb.info/gnd/1036708799</dc:creator>
                                                    </metadata>
                                                    <path d="M4.29,12.55c.08.14.16.26.24.39-.41.35-.47.8-.31,1.27.14.42.46.69.85.88.43.21.88.34,1.35.38.38.03.76,0,1.12-.17.46-.22.7-.6.77-1.1.1-.72.06-1.44-.04-2.15-.04-.29-.08-.59-.16-.87-.22-.81-.49-1.61-.88-2.36-.37-.72-.75-1.44-1.12-2.18-.02.02-.05.05-.07.09-.27.47-.53.94-.82,1.4-.34.54-.69,1.07-1.05,1.61-.06.09-.13.17-.22.27-.4-1.2-.79-2.38-1.18-3.57-.61.98-1.43,1.73-2.44,2.31-.09-.14-.17-.27-.26-.41,1.31-.74,2.25-1.82,2.82-3.22.01,0,.02,0,.03,0,.19.64.37,1.27.56,1.91.19.63.39,1.26.59,1.9.02,0,.03,0,.05,0,.15-.23.31-.46.45-.7.16-.25.31-.51.46-.76.26-.45.53-.89.78-1.34.03-.05.04-.14.02-.2-.36-1.11-.52-2.25-.49-3.41.01-.53.07-1.06.32-1.55.3-.57.78-.87,1.42-.9.39-.02.68.17.94.45.25.28.31.62.29.97-.02.32-.09.64-.17.96-.04.18-.14.34-.22.51-.26.58-.52,1.17-.8,1.75-.2.42-.43.84-.65,1.25-.04.07-.05.13-.01.21.19.43.37.86.58,1.28.3.61.62,1.21.92,1.82.4.8.62,1.66.76,2.53.12.78.17,1.58.08,2.37-.06.52-.22,1-.65,1.34-.33.25-.7.39-1.12.44-.62.07-1.21-.03-1.79-.24-.41-.15-.76-.38-1.08-.68-.61-.59-.65-1.53-.27-2.09.05-.08.11-.15.18-.21.06-.06.14-.1.23-.16ZM6.19,5.37s.03,0,.05,0c0-.01.02-.03.03-.04.29-.59.59-1.19.88-1.78.13-.28.25-.56.38-.85.2-.46.34-.93.29-1.45-.05-.48-.42-.79-.85-.71-.44.09-.73.37-.9.76-.1.22-.15.46-.18.7-.09.73-.06,1.46.06,2.19.07.4.17.79.25,1.18Z"/>
                                                </svg> -->
                                                <!-- <xsl:apply-templates select="$next" mode="manual_iter"/> -->
                                            </span>
                                        </del>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="{$next-rend} {replace($next-change,'#','')}">
                                            &#124;&#xA0;<span class="arimo">&#8368;</span>
                                            <!-- <svg xmlns="http://www.w3.org/2000/svg" xmlns:dc="http://purl.org/dc/elements/1.1/" fill="currentColor" viewBox="0 0 8.99 16.04">
                                                <metadata>
                                                <dc:creator>Bernhard Oberreither</dc:creator>
                                                <dc:creator>https://d-nb.info/gnd/1036708799</dc:creator>
                                                </metadata>
                                                <path d="M4.29,12.55c.08.14.16.26.24.39-.41.35-.47.8-.31,1.27.14.42.46.69.85.88.43.21.88.34,1.35.38.38.03.76,0,1.12-.17.46-.22.7-.6.77-1.1.1-.72.06-1.44-.04-2.15-.04-.29-.08-.59-.16-.87-.22-.81-.49-1.61-.88-2.36-.37-.72-.75-1.44-1.12-2.18-.02.02-.05.05-.07.09-.27.47-.53.94-.82,1.4-.34.54-.69,1.07-1.05,1.61-.06.09-.13.17-.22.27-.4-1.2-.79-2.38-1.18-3.57-.61.98-1.43,1.73-2.44,2.31-.09-.14-.17-.27-.26-.41,1.31-.74,2.25-1.82,2.82-3.22.01,0,.02,0,.03,0,.19.64.37,1.27.56,1.91.19.63.39,1.26.59,1.9.02,0,.03,0,.05,0,.15-.23.31-.46.45-.7.16-.25.31-.51.46-.76.26-.45.53-.89.78-1.34.03-.05.04-.14.02-.2-.36-1.11-.52-2.25-.49-3.41.01-.53.07-1.06.32-1.55.3-.57.78-.87,1.42-.9.39-.02.68.17.94.45.25.28.31.62.29.97-.02.32-.09.64-.17.96-.04.18-.14.34-.22.51-.26.58-.52,1.17-.8,1.75-.2.42-.43.84-.65,1.25-.04.07-.05.13-.01.21.19.43.37.86.58,1.28.3.61.62,1.21.92,1.82.4.8.62,1.66.76,2.53.12.78.17,1.58.08,2.37-.06.52-.22,1-.65,1.34-.33.25-.7.39-1.12.44-.62.07-1.21-.03-1.79-.24-.41-.15-.76-.38-1.08-.68-.61-.59-.65-1.53-.27-2.09.05-.08.11-.15.18-.21.06-.06.14-.1.23-.16ZM6.19,5.37s.03,0,.05,0c0-.01.02-.03.03-.04.29-.59.59-1.19.88-1.78.13-.28.25-.56.38-.85.2-.46.34-.93.29-1.45-.05-.48-.42-.79-.85-.71-.44.09-.73.37-.9.76-.1.22-.15.46-.18.7-.09.73-.06,1.46.06,2.19.07.4.17.79.25,1.18Z"/>
                                            </svg> -->
                                            <!-- <xsl:apply-templates select="$next" mode="manual_iter"/> -->
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

    <xsl:template match="tei:metamark" mode="manual_iter">
        <xsl:if test="not(@function='progress')">
            &#124;&#xA0;
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
