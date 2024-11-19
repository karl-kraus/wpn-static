<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" exclude-result-prefixes="xs tei wpn" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" name="xml"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:*[@rend='marginInnerRight']">
        <xsl:variable name="page" select="preceding::tei:lb[1]/@xml:id"/>
        <xsl:variable name="next" select="following::*[@rend='marginRight'][preceding::tei:lb[1]/@xml:id = $page]/@xml:id"/>
        <xsl:variable name="outerNext" select="following::*[@rend='marginOuterRight'][preceding::tei:lb[1]/@xml:id = $page]/@xml:id"/>
        <xsl:copy>
            <xsl:attribute name="xml:data">
                <xsl:value-of select="concat($next, '/', $outerNext)"/>
            </xsl:attribute>
            <xsl:attribute name="xml:rend">
                <xsl:text>no</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:*[@rend='marginInnerLeft']">
        <xsl:variable name="page" select="preceding::tei:lb[1]/@xml:id"/>
        <xsl:variable name="next" select="following::*[@rend='marginLeft'][preceding::tei:lb[1]/@xml:id = $page]/@xml:id"/>
        <xsl:variable name="outerNext" select="following::*[@rend='marginOuterLeft'][preceding::tei:lb[1]/@xml:id = $page]/@xml:id"/>
        <xsl:copy>
            <xsl:attribute name="xml:data">
                <xsl:value-of select="concat($next, '/', $outerNext)"/>
            </xsl:attribute>
            <xsl:attribute name="xml:rend">
                <xsl:text>no</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:*[contains(@rend, 'marginOuter')]">
        <xsl:copy>
            <xsl:attribute name="xml:rend">
                <xsl:text>no</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:*[@rend = 'marginLeft' or @rend = 'marginRight']">
        <xsl:variable name="page" select="preceding::tei:lb[1]/@xml:id"/>
        <xsl:variable name="prev" select="preceding::*[contains(@rend, 'marginInner')][preceding::tei:lb[1]/@xml:id = $page]/@xml:id"/>
        <xsl:copy>
            <xsl:if test="$prev">
                <xsl:attribute name="xml:rend">
                    <xsl:text>no</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
