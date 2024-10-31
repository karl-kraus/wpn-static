<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl xs">
    <xsl:template name="icon">
        <xsl:param name="icon_name"/>
        <xsl:choose>
            <xsl:when test="$icon_name = 'expand_info'">
                <svg class="stroke-black-grey stroke-wpn-red-hover  align-baseline ms-2" width="10"
                    height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 8 8">
                    <g transform="translate(0.53 0.75)">
                        <path style="fill:none;stroke-width:1.5px;stroke-linejoin:round;"
                            d="M0,6V0H6" transform="translate(6) rotate(90)"/>
                        <line style="fill:none;stroke-width:1.5px;" y1="6" x2="6"/>
                    </g>
                </svg>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>