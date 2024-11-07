<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl tei map" version="3.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:variable name="stylesheet_mappings" as="map(xs:string, xs:string*)">
        <xsl:map>
            <xsl:map-entry key="'index.xml'" select="('style')"/>
            <xsl:map-entry key="'projekt.xml'" select="('style')"/>
            <xsl:map-entry key="'annotierte_lesefassung.xml'" select="('style')"/>
            <xsl:map-entry key="'topographical.xml'" select="('style')"/>
            <xsl:map-entry key="'impressum.xml'" select="('style')"/>
            <xsl:map-entry key="'nutzungsbedingungen.xml'" select="('style')"/>
            <xsl:map-entry key="'register.xml'" select="('style')"/>
            <xsl:map-entry key="'notizen.xml'" select="('style')"/>
            <xsl:map-entry key="'kommentar.xml'" select="('style')"/>
            <xsl:for-each select="collection('../../data/editions?select=absatz*.xml|motti*.xml')">
                <xsl:map-entry key="tokenize(base-uri(current()),'/')[last()]" select="('style','micro-editor')"/>
            </xsl:for-each>
            <xsl:map-entry key="'biblindex_updated.xml'" select="('style')"/>
            <xsl:map-entry key="'personindex_updated.xml'" select="('style')"/>
            <xsl:map-entry key="'commentindex_updated.xml'" select="('style')"/>
            <xsl:map-entry key="'eventindex_updated.xml'" select="('style')"/>
            <xsl:map-entry key="'suche.xml'" select="('style')"/>
            <xsl:for-each select="collection('../../data/editions?select=idPb*.xml')">
                <xsl:map-entry key="tokenize(base-uri(current()),'/')[last()]" select="('style','micro-editor')"/>
            </xsl:for-each>
        </xsl:map>
    </xsl:variable>
    <xsl:template name="styles">
        <xsl:for-each select="map:get($stylesheet_mappings,tokenize(base-uri(),'/')[last()])">
            <xsl:variable name="stylesheet_src" select="json-doc('../../css_manifest.json')?*[matches(?file,current())]?file"/>
            <link rel="stylesheet" type="text/css" href="{'css/'||$stylesheet_src}"></link>
        </xsl:for-each> 
    </xsl:template>
</xsl:stylesheet>