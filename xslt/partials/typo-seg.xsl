<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:seg">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:seg[@type='transposition' and not(@subtype='implicit')]">
        <xsl:choose>
             <!-- experimental: -->
            <xsl:when test="parent::tei:restore">
                
                <xsl:variable name="visible-text" select="descendant::text()[not(ancestor::tei:add)]"/>
                
                <xsl:if test="starts-with($visible-text[1], ' ')">
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
                
                <span class="seg transposition border {replace(@change, '#', '')}">
                    <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="border-crossed-out">
                         <xsl:apply-templates mode="trim-edge-spaces"/>
                    </span>
                </span>
                
                <xsl:if test="ends-with($visible-text[last()], ' ')">
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
                
            </xsl:when>
            
            <!-- experimental: -->
            <xsl:otherwise>
                <xsl:variable name="visible-text"
                    select="descendant::text()[not(ancestor::tei:add)]"/>
                
                <xsl:if test="starts-with($visible-text[1], ' ')">
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
            
                <span class="seg transposition border {replace(@change, '#', '')}"
                      data-hand="{replace(@change,'#','')}"
                      data-anchor="{@xml:id}">
                    <xsl:apply-templates mode="trim-edge-spaces"/>
                </span>
            
                <xsl:if test="ends-with($visible-text[last()], ' ')">
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
            </xsl:otherwise>
            <!-- original: <xsl:otherwise>
                <span class="seg transposition border {replace(@change, '#', '')}" data-hand="{replace(@change,'#','')}" data-anchor="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:otherwise> -->
        </xsl:choose>
    </xsl:template>
    <!-- also part of the experimental solution, start: -->
    <xsl:template match="text()" mode="trim-edge-spaces">
        <xsl:variable name="seg-root"
            select="ancestor::tei:seg[@type='transposition' or @type='relocation'][1]"/>
        <xsl:variable name="visible-text"
            select="$seg-root/descendant::text()[not(ancestor::tei:add)]"/>
        <xsl:variable name="t0" select="."/>
        <xsl:variable name="t1"
            select="if (. is $visible-text[1])
                    then replace($t0, '^\s+', '')
                    else $t0"/>
        <xsl:variable name="t2"
            select="if (. is $visible-text[last()])
                    then replace($t1, '\s+$', '')
                    else $t1"/>
        <xsl:value-of select="$t2"/>
    </xsl:template>
    
    <xsl:template match="*" mode="trim-edge-spaces">
        <xsl:apply-templates select="."/>
    </xsl:template>
    
    <xsl:template match="@*|processing-instruction()|comment()" mode="trim-edge-spaces">
        <xsl:copy/>
    </xsl:template>
    <!-- end -->
    
    <xsl:template match="tei:seg[@type='transposition' and @subtype='implicit']">
       <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:seg[@type='marked' and @rend]">
         <span class="seg marked {@rend}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
              <xsl:apply-templates/>
         </span>
    </xsl:template>
    <xsl:template match="tei:seg[@type='relocation']">
        
        <!-- experimental: -->
        <xsl:variable name="visible-text"
            select="descendant::text()[not(ancestor::tei:add)]"/>
        
        <xsl:if test="starts-with($visible-text[1], ' ')">
            <xsl:text>&#160;</xsl:text>
        </xsl:if>
        <!-- /experimental -->
        
        <span class="entity">
            <xsl:if test="not(@rend='line')">
                <xsl:attribute name="data-anchor">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="not(@rend='line') and not(@rend='arrow') and not(@rend='none')">
                <xsl:attribute name="data-target">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:text>seg</xsl:text>
                <xsl:if test="@rend='border'">
                    <xsl:text> border border-1 border-secondary-subtle</xsl:text>
                </xsl:if>
                <xsl:if test="not(@rend='line') and not(@rend='arrow')">
                    <xsl:value-of select="replace(@change, '#', ' ')"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:if test="@rend='line' and not((@prev, @continued))">
                <xsl:choose>
                    <xsl:when test="parent::tei:restore">
                        <span class="seg entity seg-inline"><del data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="{replace(@change, '#', '')}"><xsl:text>&#124;</xsl:text></del></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="seg entity seg-inline"><span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="{replace(@change, '#', '')}"><xsl:text>&#124;</xsl:text></span></span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <!-- special handling (rendered via span firstLast) for page 111 for arrow seg see https://github.com/karl-kraus/wpn-static/issues/208  -->
            <xsl:if test="@rend='arrow' and not((@prev, @continued)) and not(@xml:id='seg0111_01')">
                <span  id="{@xml:id}" class="seg entity seg-inline">
                    <span class="{@rend} {replace(@change, '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change, '#', '')}">
                        <xsl:text>&#8592;</xsl:text>
                    </span>
                </span>
            </xsl:if>
            <xsl:if test="@rend='border'">
                <xsl:attribute name="data-hand">
                    <xsl:value-of select="replace(@change, '#', '')"/>
                </xsl:attribute>
            </xsl:if>
             <!-- experimental (the mode): -->
            <xsl:apply-templates mode="trim-edge-spaces"/>
        </span>
        
       <!-- experimental: -->
        <xsl:if test="ends-with($visible-text[last()], ' ')">
            <xsl:text>&#160;</xsl:text>
        </xsl:if>
        <!-- /experimental -->
        
    </xsl:template>
    <xsl:template match="tei:seg[@type='relocation' and @rend='arrow']" mode="render">
        <xsl:if test="not((@prev, @continued))">
            <div data-xmlid="{@xml:id}" class="d-flex w-100 position-relative">
                <div class="w-100">
                    <span data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}" class="seg seg-inline {replace(@change, '#', '')} {@rend}"><xsl:text>&#8592;</xsl:text></span>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:seg[@rendition='#runningText1']">
        <span data-hand="{replace(@change,'#','')}" class="seg d-block runningText1  {if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@type='F890']">
        <span class="seg fackelrefs entity {substring-after(@rendition, '#')} {if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}" data-anchor="{@xml:id}" data-hand="{replace(@change,'#','')}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- <xsl:template match="tei:seg[@type=('transposition','relocation')]" mode="render">
    <xsl:apply-templates/>
    </xsl:template> -->
    <xsl:template match="tei:seg[@rendition='#typescriptFloatRight']">
        <span class="{replace(@rendition, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    
</xsl:stylesheet>
