<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    exclude-result-prefixes="#all" version="2.0">
<xsl:import href="wpn_utils.xsl"/>
<xsl:import href="person.xsl"/>
<xsl:template match="tei:quote" mode="short_info">
  <xsl:variable name="xmlid" select="@xml:id"/>
  <xsl:variable name="type" select="@type"/>
  <xsl:for-each select="tokenize(@source,' ')">
    <xsl:variable name="source" select="substring-after(current(),'#')"/>
    <xsl:variable name="source_element" select="doc('../../data/indices/Register.xml')//(tei:bibl|tei:citedRange)[@xml:id=$source]"/>
    <div class="fs-6 ps-3 text-dark-grey d-none" data-xmlid="{$xmlid}" data-entity-type="quts">
      <a class="text-dark-grey text-decoration-none text-wpn-quote-hover" href="{'#'||$xmlid||'_'||$source}">
        <xsl:apply-templates select="$source_element" mode="short_info">
          <xsl:with-param name="quotetype" select="if ($type = 'exemp') then 'z. B. ' else if ($type = 'else') then 'Berichterstattung dazu z. B. in: ' else ()"/>
        </xsl:apply-templates>
      </a>
    </div>
  </xsl:for-each>
</xsl:template>
<xsl:template match="tei:seg[@type='F890']" mode="short_info">
  <xsl:variable name="xmlid" select="@xml:id"/>
  <xsl:for-each select="tokenize(@corresp,' ')">
    <xsl:variable name="corresp" select="substring-after(current(),'#')"/>
    <xsl:variable name="source_element" select="doc('../../data/indices/Register.xml')//(tei:bibl|tei:citedRange)[@xml:id=$corresp]"/>
    <div class="fs-6 ps-3 text-dark-grey d-none" data-xmlid="{$xmlid}" data-entity-type="fkl">
      <xsl:apply-templates select="$source_element" mode="short_info">
        
      </xsl:apply-templates>
    </div>
  </xsl:for-each>
</xsl:template>
<xsl:template match="tei:rs[@type=('person','personGroup')]" mode="short_info">
  <xsl:variable name="xmlid" select="@xml:id"/>
  <xsl:variable name="type" select="@type"/>
  <xsl:variable name="cert_subtype" select="@cert|@subtype"/>
  <div class="fs-6 ps-3 text-dark-grey d-none" data-xmlid="{$xmlid}" data-entity-type="prs">
    <xsl:value-of select="if ($cert_subtype = 'exemp') then 'z. B. ' else if ($cert_subtype = 'medium') then 'wahrsch. ' else if ($cert_subtype = 'recte') then 'recte: ' else ()"/>
    <xsl:for-each select="tokenize(@key,' ')">
      <xsl:variable name="key" select="substring-after(current(),'#')"/>
      <xsl:variable name="source_element" select="doc('../../data/indices/Register.xml')//(tei:person|tei:personGrp)[@xml:id=$key]"/>
      <xsl:choose>
        <xsl:when test="$source_element/name() = 'personGrp'">
          <p class="mb-0">
            <xsl:apply-templates select="$source_element/tei:note" mode="persgrpnote"/>
          </p>
          <ul class="list-unstyled ps-1 my-0">
            <xsl:for-each select="$source_element//tei:ptr">
              <xsl:variable name="ref_id" select="replace(current()/@target,'#','')"/>
              <xsl:variable name="referenced_element" select="doc('../../data/indices/Register.xml')//tei:person[@xml:id=$ref_id]"/>
              <li>
                <a class="text-dark-grey text-decoration-none text-wpn-person-hover" href="{'#'||$xmlid||'_'||$key||'_'||$ref_id}">
                  <xsl:apply-templates select="$referenced_element" mode="short_info">
                    <xsl:with-param name="ref_type" select="$type"/>
                  </xsl:apply-templates>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:when>
        <xsl:otherwise>
          <a class="text-dark-grey text-decoration-none text-wpn-person-hover" href="{'#'||$xmlid||'_'||$key}">
            <xsl:apply-templates select="$source_element" mode="short_info">
              <xsl:with-param name="ref_type" select="$type"/>
            </xsl:apply-templates>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </div>
</xsl:template>
<xsl:template match="tei:pb[not(matches(@n,'.*_[a-z].*'))]" mode="short_info">
    <div class="fs-6 ps-3 text-dark-grey pagebreaks" data-xmlid="{'pb'||@n}" style="display:none">
      <span><xsl:value-of select="'Beginn Seite '||(if (@n castable as xs:integer) then number(@n) else replace(@n,'[_]',' '))"/></span>
    </div>
</xsl:template>
<xsl:template match="tei:metamark[@function='insertion' and matches(@target,'(note)+.*([a-z])_')]" mode="short_info">
  <xsl:param name="reftype"/>
  <xsl:variable name="description">
    <xsl:choose>
      <xsl:when test="$reftype='insertionstart'">
        <xsl:text>Beginn des Einschubs von Seite</xsl:text>
      </xsl:when>
      <xsl:when test="$reftype='insertionend'">
        <xsl:text>Fortsetzung Seite</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="target" select="@target"/>
  <xsl:variable name="preceding_pb_val">
  <xsl:choose>
      <xsl:when test="$reftype='insertionstart'">
        <xsl:value-of select="doc('../../data/editions/Gesamt.xml')//tei:note[@xml:id=replace($target,'#','')]/preceding::tei:pb[1]/replace(replace(@n,'_',' '),'^0+','')"/>
      </xsl:when>
      <xsl:when test="$reftype='insertionend'">
        <xsl:value-of select="doc('../../data/editions/Gesamt.xml')//tei:metamark[@target=$target]/preceding::tei:pb[1]/replace(replace(@n,'_',' '),'^0+','')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
    <div class="fs-6 ps-3 text-dark-grey pagebreaks" data-xmlid="{$reftype||'_'||replace($target,'#','')}" style="display:none">
      <span><xsl:value-of select="$description||' '||$preceding_pb_val"/></span>
    </div>
</xsl:template>
<xsl:template match="tei:app" mode="short_info">
    <xsl:variable name="xmlid" select="@xml:id"/>
    <div class="fs-6 ps-3 text-dark-grey d-none" data-xmlid="{$xmlid}" data-entity-type="fkl">
        <xsl:apply-templates mode='short_info'/>
    </div>
</xsl:template>
<xsl:template match="tei:rdg" mode="short_info">
  <div>
      <div>
        <xsl:choose>
          <xsl:when test="@source='Motti'">
              <xsl:text>Motti (1933):</xsl:text>
          </xsl:when>
          <xsl:when test="@source='DW'">
              <xsl:text>Dritte Walpurgisnacht (1933):</xsl:text>
          </xsl:when>
          <xsl:when test="@source='F890'">
              <xsl:text>F890 (1934):</xsl:text>
          </xsl:when>
        </xsl:choose>
      </div>
      <div>
        <xsl:apply-templates/>
      </div>
  </div>
</xsl:template>
<xsl:template match="tei:ref[@type=('comment','glossary','event')]" mode="short_info">
  <xsl:variable name="xmlid" select="@xml:id"/>
  <xsl:variable name="type" select="@type"/>
  <xsl:for-each select="tokenize(@target,' ')">
    <xsl:variable name="target" select="substring-after(current(),'#')"/>
    <xsl:variable name="source_element" select="if ($type=('comment','glossary')) then doc('../../data/indices/Kommentar.xml')//tei:seg[@xml:id=$target] else doc('../../data/indices/Events.xml')//tei:event[@xml:id=$target] "/>
    <div class="fs-6 ps-3 text-dark-grey comments" data-xmlid="{$xmlid}" style="display:none">
      <xsl:apply-templates select="$source_element" mode="short_info">
      </xsl:apply-templates>
    </div>
  </xsl:for-each>
</xsl:template>
<xsl:template match="tei:citedRange" mode="short_info">
  <xsl:apply-templates select="./ancestor::tei:bibl" mode="short_info">

  </xsl:apply-templates>
</xsl:template>
<xsl:template match="tei:bibl" mode="short_info">
<xsl:param name="quotetype"/>
<xsl:param name="nonexcl"/>
<xsl:param name="linktext" as="xs:boolean" required="no" select="false()"/>
  <xsl:choose>
      <xsl:when test="tei:title[@level = 'j']">
        <xsl:variable name="papertitleshort">
          <xsl:choose>
            <xsl:when test="tei:title[@level = 'j'][@type = 'short']">
              <xsl:copy-of select="tei:title[@level = 'j'][@type = 'short']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="tei:title[@level = 'j']"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$nonexcl"/>
        <xsl:if test="not($nonexcl = $quotetype)">
          <xsl:value-of select="$quotetype"/>
        </xsl:if>
        <xsl:copy-of select="wpn:bold-italic($papertitleshort)"/>
        <xsl:if test="tei:date">
          <xsl:if test="tei:date[@from]">
            <xsl:text>. </xsl:text>
          </xsl:if>
          <xsl:value-of select="wpn:preposition(tei:date)"/>
          <xsl:value-of select="tei:date/text()"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nonexcl"/>
        <xsl:if test="not($nonexcl = $quotetype)">
          <xsl:value-of select="$quotetype"/>
        </xsl:if>

        <xsl:if test="$linktext = false()">
          <xsl:copy-of select="wpn:group-authors-bold(tei:author, false())"/>
        </xsl:if>
        <xsl:choose>

          <xsl:when test="tei:title[@level = 'a']">
            <xsl:value-of select="tei:title[@level = 'a'][not(@type)]"/>
          </xsl:when>
          <xsl:when test="tei:title[@level='a'] and $linktext = true()">
            <xsl:value-of select="tei:title[@level = 'm'][not(@type)]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="wpn:bold(tei:title[@level = 'm'][not(@type)])"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="note">
          <xsl:if test="tei:date/tei:note">
            <xsl:value-of select="tei:date/tei:note || ' '"/>
          </xsl:if>
        </xsl:variable>
        <xsl:if test="$linktext = false()">
          <xsl:value-of select="wpn:brackets($note || tei:date/text())"/>
        </xsl:if>
      </xsl:otherwise>

    </xsl:choose>
</xsl:template>
<xsl:template match="tei:seg" mode="short_info">
  <xsl:param name="ref_type"/>
  <span class="fw-bold">
    <xsl:value-of select="(if ($ref_type='comment') then 'Kommentar' else 'Glossar')||': '"/>
    <xsl:apply-templates select="tei:label" mode="comment"/></span>
</xsl:template>
<xsl:template match="tei:event" mode="short_info">
  <span class="fw-bold"><xsl:text>Ereignis: </xsl:text><xsl:apply-templates select="tei:label" mode="comment"/></span>
</xsl:template>
<xsl:template match="tei:label" mode="comment">
  <xsl:apply-templates mode="comment"/>
</xsl:template>
<xsl:template match="tei:title" mode="comment">
  <i><xsl:apply-templates mode="comment"/></i>
</xsl:template>
<xsl:template match="text()" mode="comment">
  <xsl:value-of select="."/>
</xsl:template>
<xsl:template match="tei:note[@type='relation']" mode="persgrpnote">
  <xsl:apply-templates/>
</xsl:template>
<xsl:template match="tei:note[@type='source']" mode="persgrpnote">
  <xsl:text> (lt. </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>)</xsl:text>  
  </xsl:template>
</xsl:stylesheet>