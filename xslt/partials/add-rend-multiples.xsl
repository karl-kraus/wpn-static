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
        <xsl:variable name="left-right">
            <xsl:choose>
                <xsl:when test="contains(@rend, 'Left')">
                    <xsl:text>Left</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Right</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="line" select="if(ancestor::tei:l[1])then(ancestor::tei:l[1]/@xml:id)else(preceding::tei:lb[1]/@xml:id)"/>
        <xsl:variable name="next" select="following::tei:*[
                                                    @rend
                                                    and contains(@rend, $left-right)
                                                    and not(ancestor::tei:lg[@rendition='#longQuoteVerse'])
                                                ][1]"/>
        <xsl:variable name="outerNext" select="following::tei:*[
                                                @rend 
                                                and contains(@rend, $left-right)
                                                and not(ancestor::tei:lg[@rendition='#longQuoteVerse'])
                                            ][2]"/>
        <xsl:choose>
            <xsl:when test="$next[ancestor::tei:l and ancestor::tei:l[1]/@xml:id = $line]">
                <xsl:copy>
                    <xsl:choose>
                        <xsl:when test="not(preceding::tei:*[
                                            @rend
                                            and contains(@rend, $left-right)
                                            and (ancestor::tei:l[1]/@xml:id = $line)
                                        ])">
                            <xsl:choose>
                                <xsl:when test="$outerNext[ancestor::tei:l and ancestor::tei:l[1]/@xml:id = $line]">
                                    <xsl:attribute name="xml:data">
                                        <xsl:value-of select="concat($next, ' ', $outerNext)"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="xml:data">
                                        <xsl:value-of select="$next"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:attribute name="xml:rend">
                                <xsl:text>yes</xsl:text>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="xml:rend">
                                <xsl:text>no</xsl:text>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$next[not(ancestor::tei:l and preceding::tei:lb[1]/@xml:id = $line)]">
                <xsl:copy>
                    <xsl:choose>
                        <xsl:when test="not(preceding::tei:*[
                                            @rend
                                            and contains(@rend, $left-right)
                                            and (preceding::tei:lb[1]/@xml:id = $line)
                                        ])">
                            <xsl:choose>
                                <xsl:when test="$outerNext[not(ancestor::tei:l) and preceding::tei:lb[1]/@xml:id = $line]">
                                    <xsl:attribute name="xml:data">
                                        <xsl:value-of select="concat($next, ' ', $outerNext)"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="xml:data">
                                        <xsl:value-of select="$next"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:attribute name="xml:rend">
                                <xsl:text>yes</xsl:text>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="xml:rend">
                                <xsl:text>no</xsl:text>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
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
