<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:import href="wpn_utils.xsl"/>
    <xsl:import href="person.xsl"/>
    <xsl:import href="bibl.xsl"/>
    <xsl:import href="seg.xsl"/>
    <xsl:import href="event.xsl"/>
    <xsl:template match="tei:quote" mode="detail_view_textpage">
        <xsl:variable name="xmlid" select="@xml:id"/>
        <xsl:variable name="type" select="@type"/>
        <xsl:for-each select="tokenize(@source, ' ')">
            <xsl:variable name="source" select="substring-after(current(), '#')"/>
            <xsl:variable name="source_element"
                select="doc('../../data/indices/Register.xml')//(tei:bibl | tei:citedRange)[@xml:id = $source]"/>
            <xsl:apply-templates select="$source_element" mode="detail_view_textpage">
                <xsl:with-param name="id_in_text" select="$xmlid"/>
                <xsl:with-param name="quotetype" select="
                        if ($type = 'exemp') then
                            'Siehe z. B.: '
                        else
                            if ($type = 'else') then
                                'Berichterstattung dazu z. B. in: '
                            else
                                ()"/>
            </xsl:apply-templates>

        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:seg[@type = 'F890']" mode="detail_view_textpage">
        <xsl:variable name="xmlid" select="@xml:id"/>
        <xsl:for-each select="tokenize(@corresp, ' ')">
            <xsl:variable name="corresp" select="substring-after(current(), '#')"/>
            <xsl:variable name="source_element"
                select="doc('../../data/indices/Register.xml')//(tei:bibl | tei:citedRange)[@xml:id = $corresp]"/>
           
                <xsl:apply-templates select="$source_element" mode="detail_view_textpage"
                > </xsl:apply-templates>
         
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:ref[@type=('comment','event','glossary')]" mode="detail_view_textpage">
        <xsl:variable name="xmlid" select="@xml:id"/>
        <xsl:variable name="type" select="@type"/>
        <xsl:for-each select="tokenize(@target, ' ')">
            <xsl:variable name="target" select="substring-after(current(), '#')"/>
            <xsl:variable name="source_element">
                <xsl:choose>
                    <xsl:when test="$type='event'">
                        <xsl:copy-of  select="doc('../../data/indices/Events.xml')//(tei:event)[@xml:id = $target]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of  select="doc('../../data/indices/Kommentar.xml')//(tei:seg)[@xml:id = $target]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
                <xsl:apply-templates select="$source_element" mode="detail_view_textpage"
                ><xsl:with-param name="id_in_text" select="$xmlid"/>
                </xsl:apply-templates>
         
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:rs[@type=('person','personGroup')]" mode="detail_view_textpage">
      <xsl:variable name="xmlid" select="@xml:id"/>
      <xsl:variable name="type" select="@type"/>
      <xsl:variable name="cert_subtype" select="@cert|@subtype"/>
      <xsl:for-each select="tokenize(@key,' ')">
        <xsl:variable name="key" select="substring-after(current(),'#')"/>
        <xsl:variable name="source_element" select="doc('../../data/indices/Register.xml')//(tei:person|tei:personGrp)[@xml:id=$key]"/>
        <xsl:choose>
            <xsl:when test="$source_element/name() = 'personGrp'">
                <xsl:for-each select="$source_element//tei:ptr">
                    <xsl:variable name="ref_id" select="replace(current()/@target,'#','')"/>
                    <xsl:variable name="referenced_element" select="doc('../../data/indices/Register.xml')//tei:person[@xml:id=$ref_id]"/>
                    <xsl:apply-templates select="$referenced_element" mode="detail_view_textpage">
                    <xsl:with-param name="group_id" select="$key"/>
                    <xsl:with-param name="ref_type" select="$type"/>
                    <xsl:with-param name="id_in_text" select="$xmlid"/>
                </xsl:apply-templates>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$source_element" mode="detail_view_textpage">
                    <xsl:with-param name="ref_type" select="$type"/>
                    <xsl:with-param name="id_in_text" select="$xmlid"/>
                    <xsl:with-param name="cert_subtype" select="
                            if ($cert_subtype = 'exemp') then 'z. B. ' else if ($cert_subtype = 'medium') then 'wahrsch. ' else if ($cert_subtype = 'recte') then 'recte: ' else ()"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
       
      </xsl:for-each>
  </xsl:template>
      <xsl:template match="tei:app" mode="detail_view_textpage"/>
  </xsl:stylesheet>
