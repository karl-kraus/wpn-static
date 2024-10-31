<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" exclude-result-prefixes="xs tei wpn" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" name="xml"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:pb">
        <xsl:choose>
            <xsl:when test="not(contains(@n, '_')) and @n != '0196' and following-sibling::tei:lb[1][@rendition='no']">
                <span xmlns="http://www.tei-c.org/ns/1.0" n="lb-dash">-</span>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:note[@xml:id='note0195_4']">
        <span xmlns="http://www.tei-c.org/ns/1.0" n="lb-dash">-</span>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
