<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" exclude-result-prefixes="xs tei wpn" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" name="xml"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:*[contains(@rend, 'margin')]">
        <xsl:variable name="page" select="preceding::tei:lb[1]/@xml:id"/>
        <xsl:choose>
            <xsl:when test="not(preceding::tei:*[contains(@rend, 'margin')][preceding::tei:lb[1]/@xml:id = $page])">
                <xsl:variable name="next" select="following::tei:*[contains(@rend, 'margin')][preceding::tei:lb[1]/@xml:id = $page][1]/@xml:id"/>
                <xsl:variable name="outerNext" select="following::tei:*[contains(@rend, 'margin')][preceding::tei:lb[1]/@xml:id = $page][2]/@xml:id"/>
                <xsl:copy>
                    <xsl:attribute name="xml:data">
                        <xsl:value-of select="concat($next, '/', $outerNext)"/>
                    </xsl:attribute>
                    <xsl:attribute name="xml:rend">
                        <xsl:text>yes</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:attribute name="xml:rend">
                        <xsl:text>no</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
