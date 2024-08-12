<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:wpn="https://wpn.acdh.oeaw.ac.at" exclude-result-prefixes="xs xsl tei wpn" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
<xsl:import href="./wpn_utils.xsl"/>
<xsl:template name="pagination">
  <xsl:param name="current-page"/>
  <xsl:param name="prev-page"/>
  <xsl:param name="next-page"/>
  <div class="dropdown ff-ubuntu">
    <a href="{$prev-page}" title="zu seite {$prev-page} gehen">
      <svg width="24" height="24" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false"><g><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path></g></svg>
    </a>
    <button class="btn btn-secondary dropdown-toggle fs-9_38 border-0 px-05" type="button" data-bs-toggle="dropdown" aria-expanded="false">
      <xsl:value-of select="wpn:parse-page-name(replace($current-page,'absatz_',''),'label')"/>
    </button>
    <ul class="dropdown-menu z-3 rounded-0">
    <xsl:for-each select="doc('../../data/editions/Gesamt.xml')//(tei:p[@n]|tei:mod[@n])">
      <li><a class="dropdown-item fs-9_38 py-0" href="{wpn:parse-page-name(current()/@n,'')||'.html'}"><xsl:value-of select="wpn:parse-page-name(current()/@n,'label')"/></a></li>
    </xsl:for-each>
    </ul>
    <a href="{$next-page}" title="zu seite {$next-page} gehen">
      <svg width="24" height="24" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false"><g><path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"></path></g></svg>
    </a>
  </div>
</xsl:template>
</xsl:stylesheet>