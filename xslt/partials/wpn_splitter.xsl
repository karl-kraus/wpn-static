<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" exclude-result-prefixes="xs tei wpn" version="2.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no" name="xml"/>
    <xsl:import href="wpn_utils.xsl"/>
     <xsl:variable name="teiHeader">
        <xsl:copy-of select="tei:teiHeader"/>
    </xsl:variable>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:rs[@type=('person','personGroup')][@prev]"/>
    <xsl:template match="tei:rs[@type=('person','personGroup')][@next]">
        <xsl:variable name="next">
            <xsl:value-of select="replace(@next,'#','')"/>
        </xsl:variable>
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:copy-of select="node()"/>
            <xsl:value-of select="' '"/>
            <xsl:copy-of select="root()//tei:rs[@xml:id = $next]/node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:p[@n]|tei:mod[@n]">
        <xsl:variable name="pagename" select="wpn:normalizePagename(@n,'link')||'.xml'"/>
        <xsl:variable name="prev" select="(preceding::*[self::tei:p|self::tei:mod][@n]|ancestor::*[self::tei:p|self::tei:mod][@n])[last()]"/>
        <xsl:variable name="next" select="(following::*[self::tei:p|self::tei:mod][@n]|descendant::*[self::tei:p|self::tei:mod][@n])[1]"/>
        <xsl:result-document href="{$pagename}" format="xml">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="prev" select="wpn:normalizePagename($prev/@n,'link')"/>
            <xsl:attribute name="id" select="wpn:normalizePagename(@n,'link')"/>
            <xsl:attribute name="next" select="wpn:normalizePagename($next/@n,'link')"/>
            <xsl:copy select=".">
            <xsl:attribute name="rendition" select="@rendition"/>
             <xsl:attribute name="n" select="@n"/>
                <xsl:apply-templates/>
            </xsl:copy>
        </TEI>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
