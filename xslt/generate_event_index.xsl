<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" version="2.0" exclude-result-prefixes="wpn xsl xs tei">

    <xsl:output encoding="UTF-8" method="xml" version="1.0"
        omit-xml-declaration="yes"/>
    <xsl:mode on-no-match="deep-skip"/>
     <xsl:variable name="ref_elements">
            <xsl:for-each select="document('../data/editions/Gesamt.xml')//tei:ref[@type=('event')]">
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
                    <listEvent>
                        <xsl:apply-templates select="//tei:event"/>
                    </listEvent>
                </body>
            </text>
         </TEI>
    </xsl:template>
    <xsl:template match="tei:event">
            <xsl:element name="event" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:variable name="id" select="@xml:id" as="xs:string"/>
                <xsl:copy-of
                    select="@*| node()"
                />
                <note>
                    <xsl:copy-of select="$ref_elements//*[@target='#'||$id]"/>
                    <xsl:if test="not(document('../data/editions/Gesamt.xml')//tei:ref[@type='event'][contains(@target,$id)])">
                        <xsl:variable name="indirect_event_or_comment_references" as="xs:string*">
                            <xsl:sequence>
                                <xsl:sequence select="root()//tei:ref[@target='#'||$id]/ancestor::tei:event/@xml:id"/>
                                <xsl:sequence select="document('../data/indices/Kommentar.xml')//tei:ref[@target='#'||$id]/parent::tei:seg/@xml:id"/>
                            </xsl:sequence>
                        </xsl:variable>
                        <xsl:for-each select="$indirect_event_or_comment_references[.!='']">
                            <xsl:for-each select="document('../data/editions/Gesamt.xml')//tei:ref[@type=('event','comment')][contains(@target,'#'||current())]">
                                <xsl:variable name="current_ref" select="current()"/>
                                    <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="target" select="current()"/>
                                        <xsl:copy-of select="$current_ref/@*[not(./local-name() = 'target')]"/>
                                    </xsl:element>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:if>
                </note>
            </xsl:element>
    </xsl:template>
</xsl:stylesheet>
