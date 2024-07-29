<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" version="2.0" exclude-result-prefixes="wpn xsl xs tei">

    <xsl:output encoding="UTF-8" method="xml" version="1.0"
        omit-xml-declaration="yes"/>
    <xsl:mode on-no-match="deep-skip"/>
     <xsl:variable name="rs_elements">
            <xsl:for-each select="document('../data/editions/Gesamt.xml')//tei:rs[@type=('person','personGroup')]">
                 <xsl:variable name="current_rs" select="."/>
                <xsl:for-each select="tokenize(current()/@key,' ')">
                    <xsl:element name="rs" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="key" select="current()"/>
                        <xsl:copy-of
                            select="$current_rs/@*[not(./local-name() = 'key')]"
                        />
            </xsl:element>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
    <xsl:template match="/">
           
         <TEI>
            <listPerson>
                <xsl:apply-templates select="//tei:person[not(descendant::tei:note[@type='status'][@subtype='delete'])]"/>
            </listPerson>
         </TEI>
    </xsl:template>
    <xsl:template match="tei:person">
            <xsl:element name="person" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:variable name="id" select="@xml:id" as="xs:string"/>
                <xsl:copy-of
                    select="@*| node()"
                />
                <xsl:variable name="ids" select="($id,root()//tei:ptr[@target = '#'||$id]//ancestor::tei:personGrp/string(@xml:id))"/>
                <xsl:for-each select="$ids">
                    <listRef>
                        <xsl:copy-of select="$rs_elements//*[@key='#'||current()]"/>
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
