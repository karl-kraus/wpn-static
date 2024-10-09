<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:map="http://www.w3.org/2005/xpath-functions/map" exclude-result-prefixes="xs tei"
    version="3.0">
    <xsl:variable name="iiif_endpoint"
        select="'https://iiif.acdh.oeaw.ac.at/iiif/images/walpurgisnacht/'"/>
    <xsl:output method="json" indent="yes"/>
    <xsl:mode on-no-match="shallow-skip"/>
    <xsl:template match="/">
        <xsl:variable name="result" as="map(*)*">
            <xsl:apply-templates select="//(tei:bibl[@corresp] | tei:citedRange[@corresp])"/>
        </xsl:variable>
        <xsl:copy-of select="map:merge($result)"/>
    </xsl:template>
    <xsl:variable name="root" select="root()"/>
    <xsl:template match="tei:bibl | tei:citedRange">
        <xsl:variable name="scan_related" as="map(*)*">
            <xsl:for-each select="tokenize(@corresp, ' ')">
                <xsl:variable name="refId" select="replace(current(), '#', '')"/>
                <xsl:variable name="refNode" select="$root//*[@xml:id = $refId]"/>
                <xsl:apply-templates select="$refNode"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="scan_data" as="item()*">
            <xsl:for-each-group select="$scan_related" group-by="?url">
                <xsl:variable name="coords" as="item()*">
                    <xsl:for-each select="current-group()?overlay">
                        <xsl:map>
                            <xsl:map-entry key="'overlays'" select="current()"/>
                        </xsl:map>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:map>
                    <xsl:map-entry key="'url'" select="current-grouping-key()"/>
                    <xsl:map-entry key="'overlays'">
                        <xsl:copy-of select="array {$coords?overlays}"/>
                    </xsl:map-entry>
                   <xsl:map-entry key="'note_short'" select="current-group()?note_short[1]"/>
                    <xsl:map-entry key="'note_full'" select="current-group()?note_full[1]"/>
                </xsl:map>
            </xsl:for-each-group>
        </xsl:variable>
        <xsl:map>
            <xsl:map-entry key="data(@xml:id)" select="array {$scan_data}"/>
        </xsl:map>
    </xsl:template>
    <xsl:template match="tei:zone">
        <xsl:variable name="facswidth" as="xs:decimal">
            <xsl:value-of select="substring-before(preceding-sibling::tei:graphic/@width, 'px')"/>
        </xsl:variable>
        <xsl:variable name="x" as="xs:decimal">
            <xsl:value-of select="xs:decimal(@ulx) div $facswidth"/>
        </xsl:variable>
        <xsl:variable name="y" as="xs:decimal">
            <xsl:value-of select="xs:decimal(@uly) div $facswidth"/>
        </xsl:variable>
        <xsl:variable name="width" as="xs:decimal">
            <xsl:value-of select="(xs:decimal(@lrx) - xs:decimal(@ulx)) div $facswidth"/>
        </xsl:variable>
        <xsl:variable name="height" as="xs:decimal">
            <xsl:value-of select="(xs:decimal(@lry) - xs:decimal(@uly)) div $facswidth"/>
        </xsl:variable>
        <xsl:map>
            <xsl:map-entry key="'url'"
                select="$iiif_endpoint || replace(data(parent::tei:surface/@facs), '.jpg', '.jp2/info.json')"/>
            <xsl:map-entry key="'overlay'">
                <xsl:map>
                    <xsl:map-entry key="'x'" select="$x"/>
                    <xsl:map-entry key="'y'" select="$y"/>
                    <xsl:map-entry key="'width'" select="$width"/>
                    <xsl:map-entry key="'height'" select="$height"/>
                </xsl:map>
            </xsl:map-entry>
            <xsl:map-entry key="'note_short'" select="data(parent::tei:surface/tei:note[@type='source'][@subtype='short'])"/>
            <xsl:map-entry key="'note_full'" select="data(parent::tei:surface/tei:note[@type='source'][@subtype='full'])"/>
        </xsl:map>
    </xsl:template>
    <xsl:template match="tei:surface">
        <xsl:map>
            <xsl:map-entry key="'url'" select="$iiif_endpoint || replace(data(@facs), '.jpg', '.jp2/info.json')"/>
            <xsl:map-entry key="'note_short'" select="data(tei:note[@type='source'][@subtype='short'])"/>
            <xsl:map-entry key="'note_full'" select="data(tei:note[@type='source'][@subtype='full'])"/>
        </xsl:map>
    </xsl:template>
</xsl:stylesheet>
