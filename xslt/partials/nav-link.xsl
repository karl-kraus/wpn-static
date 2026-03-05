<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:template name="nav-link">
    <xsl:param name="href"/>
    <xsl:param name="label"/>
    <xsl:param name="level"/>
    <a class="nav-link text-nowrap {$level}" href="{$href}"><xsl:value-of select="$label"/><svg class="ms-2" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 12 12">
    <defs>
        <style>.a{fill:none;stroke:#d8d8d8;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;}</style>
    </defs>
    <path class="a" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"/>
</svg></a>
    </xsl:template>
</xsl:stylesheet>
