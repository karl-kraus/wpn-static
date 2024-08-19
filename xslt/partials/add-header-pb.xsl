<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" exclude-result-prefixes="xs tei wpn" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no" name="xml"/>

    <xsl:variable name="teiHeader">
        <xsl:copy-of select="doc('../../data/editions/Gesamt.xml')//tei:teiHeader"/>
    </xsl:variable>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:TEI">
        <xsl:copy>
            <xsl:copy-of select="doc('../../data/editions/Gesamt.xml')//tei:teiHeader"/>
            <xsl:apply-templates />
        </xsl:copy> 
    </xsl:template>
</xsl:stylesheet>
