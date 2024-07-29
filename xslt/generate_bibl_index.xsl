<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" version="2.0" exclude-result-prefixes="wpn xsl xs tei">

    <xsl:output encoding="UTF-8" method="xml" version="1.0"
        omit-xml-declaration="yes"/>
    <xsl:mode on-no-match="deep-skip"/>
     <xsl:variable name="quotes">
            <xsl:for-each select="document('../data/editions/Gesamt.xml')//tei:quote">
                 <xsl:variable name="current_quote" select="."/>
                <xsl:for-each select="tokenize(current()/@source,' ')">
                    <xsl:element name="quote" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="source" select="current()"/>
                        <xsl:copy-of
                            select="$current_quote/@*[not(./local-name() = 'source')]"
                        />
            </xsl:element>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
    <xsl:template match="/">
           
         <TEI>
            <listBibl>
                <xsl:apply-templates select="//tei:bibl"/>
            </listBibl>
         </TEI>
    </xsl:template>
    <xsl:template match="tei:bibl">
            <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:copy-of
                    select="@*| node()"
                />
                <xsl:for-each select="tei:citedRange">
                    <listRef>
                        <xsl:copy-of select="$quotes//*[@source='#'||current()/@xml:id]"/>
                    </listRef>
                </xsl:for-each>
                <index>
                <xsl:for-each select="tokenize(@sortKey,'#')">
                    <term key="{upper-case(substring(current(),1,1))}"><xsl:value-of select="current()"/></term>
                </xsl:for-each>
                </index>
            </xsl:element>
    </xsl:template>
</xsl:stylesheet>
