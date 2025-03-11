<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template match="tei:seg">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:seg[@type='transposition' and not(@subtype='implicit') and not(parent::tei:restore)]">
        <span class="border rounded-pill {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@type='transposition' and not(@subtype='implicit') and parent::tei:restore]">
        <span class="border-dotted rounded-pill {replace(@change, '#', '')}" id="{@xml:id}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@type='relocation']">
        <span id="{if(not(@rend='line') and not(@rend='arrow'))then(@xml:id)else(concat('parent-', @xml:id))}">
            <xsl:if test="@rend='border'">
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('border border-1 border-secondary-subtle', replace(@change, '#', ''))"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@rend='line'"><span class="seg seg-inline"><span id="{@xml:id}">&#124;</span></span></xsl:if>
            <xsl:if test="@rend='arrow'"><span class="seg seg-inline"><span id="{@xml:id}">&#8592;</span></span></xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:seg[@rendition='#runningText1']">
        <span class="d-block runningText1  {if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@type='F890']">
        <span class="fackelrefs entity {substring-after(@rendition, '#')} {if(@prev)then(' no-indent')else()} {replace(@change, '#', '')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- <xsl:template match="tei:seg[@type=('transposition','relocation')]" mode="render">
    <xsl:apply-templates/>
    </xsl:template> -->
</stylesheet>