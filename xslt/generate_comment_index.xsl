<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" version="2.0" exclude-result-prefixes="wpn xsl xs tei">

    <xsl:output encoding="UTF-8" method="xml" version="1.0"
        omit-xml-declaration="yes"/>
    <xsl:mode on-no-match="deep-skip"/>
     <xsl:variable name="ref_elements">
            <xsl:for-each select="document('../data/editions/Gesamt.xml')//tei:ref[@type=('comment')]">
                 <xsl:variable name="current_ref" select="."/>
                <xsl:for-each select="tokenize(current()/@target,' ')">
                    <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="target" select="current()"/>
                        <xsl:copy-of
                            select="$current_ref/@*[not(./local-name() = 'target')]"
                        />
            </xsl:element>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
    <xsl:template match="/">
           
         <TEI>
            <xsl:copy-of select="tei:TEI/tei:teiHeader"/>
            <text>
                <body>
                    <p>
                        <xsl:copy-of select="tei:TEI//tei:listRef"/>
                    </p>
                    <p>
                        <xsl:apply-templates select="//tei:seg"/>
                    </p>
                </body>
            </text>
         </TEI>
    </xsl:template>
    <xsl:template match="tei:seg[not(ancestor::tei:seg)]">
            <xsl:element name="seg" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:variable name="ids" select="(for $id in (@xml:id,descendant::tei:seg/@xml:id) return '#'||$id)" as="xs:string*"/>
                <xsl:copy-of
                    select="@*| node()"
                />
                        <xsl:copy-of select="$ref_elements//*[@target=$ids]"/>
            </xsl:element>
    </xsl:template>
</xsl:stylesheet>
