<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl tei map" version="3.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:variable name="script_mappings" as="map(xs:string, xs:string*)">
        <xsl:map>
            <xsl:map-entry key="'index.xml'" select="('wpn-header','wpn-scroll-button')"/>
            <xsl:map-entry key="'projekt.xml'" select="('wpn-header','wpn-toggle-text-button')"/>
            <xsl:map-entry key="'annotierte_lesefassung.xml'" select="('wpn-header','wpn-toggle-text-button')"/>
            <xsl:map-entry key="'impressum.xml'" select="('wpn-header','wpn-toggle-text-button')"/>
            <xsl:map-entry key="'nutzungsbedingungen.xml'" select="('wpn-header','wpn-toggle-text-button')"/>
            <xsl:map-entry key="'register.xml'" select="('wpn-header','wpn-toggle-text-button')"/>
            <xsl:map-entry key="'kommentar.xml'" select="('wpn-header','wpn-toggle-text-button')"/>
            <xsl:map-entry key="'notizen.xml'" select="('wpn-header','init-mirador')"/>
            <xsl:for-each select="collection('../../data/editions?select=absatz*.xml|motti*.xml')">
                <xsl:map-entry key="tokenize(base-uri(current()),'/')[last()]" select="('wpn-header','init-micro-editor','wpn-text-view','wpn-entity','wpn-text-zoom-button','wpn-pagination','init-mark','wpn-detail-view','wpn-scans')"/>
            </xsl:for-each>
            <xsl:map-entry key="'biblindex_updated.xml'" select="('wpn-header','wpn-detail-view','wpn-reg-entry','wpn-reg-tabs','wpn-scans')"/>
            <xsl:map-entry key="'personindex_updated.xml'" select="('wpn-header','wpn-detail-view','wpn-reg-entry','wpn-reg-tabs')"/>
            <xsl:map-entry key="'commentindex_updated.xml'" select="('wpn-header','wpn-detail-view','wpn-reg-entry','wpn-toggle-text-button')"/>
            <xsl:map-entry key="'eventindex_updated.xml'" select="('wpn-header','wpn-detail-view','wpn-reg-entry','wpn-timeline')"/>
            <xsl:map-entry key="'suche.xml'" select="('wpn-header','wpn-detail-view','init-typesense')"/>
            <xsl:for-each select="collection('../../data/editions?select=idPb*.xml')">
                <xsl:map-entry key="tokenize(base-uri(current()),'/')[last()]" select="('wpn-header','wpn-page-view','wpn-entity', 'init-openseadragon', 'wpn-hf-height', 'wpn-typo-connections')"/>
            </xsl:for-each>
        </xsl:map>
    </xsl:variable>
    <xsl:template name="scripts">
        <xsl:for-each select="map:get($script_mappings,tokenize(base-uri(),'/')[last()])">
            <xsl:variable name="script_src" select="json-doc('../../manifest.json')?*[matches(?file,current())]?file"/>
            <script src="{'js/wpn_utils/'||$script_src}">
                <xsl:choose>
                    <xsl:when test="contains($script_src,'init-micro-editor') or contains($script_src,'init-openseadragon') or contains($script_src,'wpn-timeline') or contains($script_src, 'init-typesense') or contains($script_src, 'wpn-scans')">
                        <xsl:attribute name="type">module</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="type">text/javascript</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </script>
        </xsl:for-each> 
    </xsl:template>
</xsl:stylesheet>