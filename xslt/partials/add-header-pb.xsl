<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" exclude-result-prefixes="xs tei wpn" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" name="xml"/>

    <xsl:variable name="facsimile">
        <xsl:value-of select="'idfacs'||replace(substring-after(data(//tei:pb[1]/@xml:id), 'idPb'), '.xml', '')"/>
    </xsl:variable>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:TEI">
        <xsl:copy>
            <xsl:copy-of select="doc('../../data/editions/Gesamt.xml')//tei:teiHeader"/>
            <facsimile xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:copy-of select="doc('../../data/editions/Gesamt.xml')//tei:facsimile/tei:surface[@xml:id = $facsimile]"/>
            </facsimile>
            <xsl:apply-templates />
        </xsl:copy> 
    </xsl:template>
    <xsl:template match="tei:lb[preceding-sibling::*[1][local-name()='quote'][child::tei:p[@rendition='#longQuote']|child::tei:seg[child::tei:lg[@rendition]]|child::tei:lg[@rendition]]]">
        <xsl:copy>
            <xsl:attribute name="n">
                <xsl:text>first</xsl:text>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:lb[preceding-sibling::*[1][local-name()=('p')]]">
        <xsl:copy>
            <xsl:attribute name="n">
                <xsl:text>first</xsl:text>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:lb[preceding-sibling::*[1][local-name()=('lg')]]">
        <xsl:copy>
            <xsl:attribute name="n">
                <xsl:text>first</xsl:text>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:lb[parent::tei:p[@rendition]][position() = 1][preceding-sibling::tei:quote[not(child::tei:p[@rendition])]|preceding-sibling::tei:lg]">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
