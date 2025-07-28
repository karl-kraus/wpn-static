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
            <xsl:when test="parent::tei:restore">
                <span class="seg border rounded-pill {replace(@change, '#', '')}" id="{@xml:id}">
                    <span class="border-crossed-out"><xsl:apply-templates/></span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="seg border rounded-pill {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:seg[@type='transposition' and @subtype='implicit']">
        <xsl:choose>
            <xsl:when test="parent::tei:restore">
                <span class="seg {replace(@change, '#', '')}" id="{@xml:id}">
                <!--<span class="seg border-dashed rounded-pill {replace(@change, '#', '')}" id="{@xml:id}">
                    <span class="border-crossed-out"><xsl:apply-templates/></span>-->
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="seg {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
                <!-- <span class="seg border-dashed rounded-pill {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span> -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:seg[@type='relocation']">
        <span id="{if(not(@rend='line') and not(@rend='arrow'))then(@xml:id)else(concat('parent-', @xml:id))}">
            <xsl:if test="@rend='border'">
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('seg border border-1 border-secondary-subtle', replace(@change, '#', ' '))"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@rend='line' and not((@prev, @continued))"><span class="seg seg-inline"><span id="{@xml:id}" class="{replace(@change, '#', '')}">&#124;</span></span></xsl:if>
            <!-- special handling (rendered via span firstLast) for page 111 for arrow seg see https://github.com/karl-kraus/wpn-static/issues/208  -->
            <xsl:if test="@rend='arrow' and not((@prev, @continued)) and not(@xml:id='seg0111_01')"><span class="seg seg-inline"><span id="{@xml:id}" class="{@rend} {replace(@change, '#', '')}">&#8592;</span></span></xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:seg[@type='relocation' and @rend='arrow']" mode="render">
        <xsl:if test="not((@prev, @continued))">
            <div data-xmlid="{@xml:id}" class="d-flex w-100 position-relative">
                <div class="seg connect w-100">
                    <span class="seg seg-inline {replace(@change, '#', '')} {@rend}">&#8592;</span>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:seg[@rendition='#runningText1']">
        <span class="seg d-block runningText1  {if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@type='F890']">
        <span class="seg fackelrefs entity {substring-after(@rendition, '#')} {if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- <xsl:template match="tei:seg[@type=('transposition','relocation')]" mode="render">
    <xsl:apply-templates/>
    </xsl:template> -->
</xsl:stylesheet>
