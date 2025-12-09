<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    exclude-result-prefixes="#all" version="2.0">
<xsl:import href="wpn_utils.xsl"/>
<xsl:import href="person.xsl"/>
<xsl:import href="bibl.xsl"/>
<xsl:import href="seg.xsl"/>
<xsl:import href="icon.xsl"/>
<xsl:template match="tei:quote" mode="short_info">
  <xsl:variable name="xmlid" select="@xml:id"/>
  <xsl:variable name="type" select="@type"/>
  <xsl:for-each select="tokenize(@source,' ')">
    <xsl:variable name="source" select="substring-after(current(),'#')"/>
    <xsl:variable name="source_element" select="doc('../../data/indices/Register.xml')//(tei:bibl|tei:citedRange)[@xml:id=$source]"/>
    <div class="fs-6 ps-3 text-dark-grey d-none quote_signet_background bg-no-repeat bg-position-short-info" data-testid="{if ($source = 'DWbibl00211') then 'short_info_'||$xmlid else 'short_info_'||$xmlid||'_'||$source}" data-xmlid="{$xmlid}" data-entity-type="quts">
      <a class="text-dark-grey text-decoration-none text-wpn-quote-hover" href="{'#'||$xmlid||'_'||$source}">
        <xsl:apply-templates select="$source_element" mode="short_info">
          <xsl:with-param name="quotetype" select="if ($source = 'DWbibl00211') then () else if ($type = 'exemp') then 'z. B. ' else if ($type = 'else') then 'Berichterstattung dazu z. B. in: ' else ()"/>
        </xsl:apply-templates>
        <xsl:call-template name="icon">
          <xsl:with-param name="icon_name" select="'expand_info'"/>
        </xsl:call-template>
      </a>
    </div>
  </xsl:for-each>
</xsl:template>
<xsl:template match="tei:seg[@type='F890']" mode="short_info">
  <xsl:variable name="xmlid" select="@xml:id"/>
  <xsl:for-each select="tokenize(@corresp,' ')">
    <xsl:variable name="corresp" select="substring-after(current(),'#')"/>
    <xsl:variable name="source_element" select="doc('../../data/indices/Register.xml')//(tei:bibl|tei:citedRange)[@xml:id=$corresp]"/>
    <div class="fs-6 ps-3 text-dark-grey d-none fackel_signet_background bg-no-repeat bg-position-short-info" data-xmlid="{$xmlid}" data-entity-type="fkl">
      <a class="text-dark-grey text-decoration-none text-wpn-fackel-hover" href="{'#'||$xmlid||'_'||$corresp}">
      <xsl:apply-templates select="$source_element" mode="short_info">
      </xsl:apply-templates>
      <xsl:call-template name="icon">
        <xsl:with-param name="icon_name" select="'expand_info'"/>
      </xsl:call-template>
      </a>
    </div>
  </xsl:for-each>
</xsl:template>
<xsl:template match="tei:rs[@type=('person','personGroup')]" mode="short_info">
  <xsl:variable name="xmlid" select="@xml:id"/>
  <xsl:variable name="type" select="@type"/>
  <xsl:variable name="cert_subtype" select="@cert|@subtype"/>
    <xsl:for-each select="tokenize(@key,' ')">
      <xsl:variable name="key" select="substring-after(current(),'#')"/>
      <xsl:variable name="source_element" select="doc('../../data/indices/Register.xml')//(tei:person|tei:personGrp)[@xml:id=$key]"/>
  <div class="fs-6 ps-3 text-dark-grey d-none person_signet_background bg-no-repeat bg-position-short-info" data-testid="short_info_{if ($key = 'DWpers9999') then $xmlid else $xmlid||'_'||$key}" data-xmlid="{$xmlid}" data-entity-type="prs">
    <xsl:value-of select="if ($cert_subtype = 'exemp') then 'z. B. ' else if ($cert_subtype = 'medium') then 'wahrsch. ' else if ($cert_subtype = 'recte') then 'recte: ' else ()"/>
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
                  <xsl:call-template name="icon">
                    <xsl:with-param name="icon_name" select="'expand_info'"/>
                  </xsl:call-template>
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
            <xsl:call-template name="icon">
              <xsl:with-param name="icon_name" select="'expand_info'"/>
            </xsl:call-template>
          </a>
        </xsl:otherwise>
      </xsl:choose>
        </div>
    </xsl:for-each>
</xsl:template>
<xsl:template match="tei:pb[not(matches(@n,'.*_[a-z].*'))]" mode="short_info">
    <div class="fs-6 ps-3 text-dark-grey pagebreaks pb_signet_background bg-no-repeat bg-position-short-info" data-xmlid="{'pb'||@n}" style="display:none">
      <span>
      <xsl:value-of select="'Beginn Seite '||(if (@n castable as xs:integer) then number(@n) else replace(@n,'[_]',' '))"/>
     <xsl:text> | </xsl:text>
     <a class="text-dark-grey" target="_blank" rel="noopener noreferrer" href="{@xml:id || '.html'}">
      Topographische Umschrift 
     </a>
      </span>
    </div>
</xsl:template>
<xsl:template match="tei:metamark[@function='insertion' and matches(@target,'(note)+.*([a-z])_')][not(@change='#edACE')]" mode="short_info">
  <xsl:param name="reftype"/>
  <xsl:param name="target"/>
  <xsl:variable name="id" select="substring-after($target,$reftype||'_')"/>
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
  <!--<xsl:variable name="target" select="@target"/>-->
  <xsl:variable name="preceding_pb_val">
  <xsl:choose>
      <xsl:when test="$reftype='insertionstart'">
        <xsl:value-of select="doc('../../data/editions/Gesamt.xml')//tei:note[@xml:id=replace($id,'#','')]/preceding::tei:pb[1]/replace(replace(@n,'_',' '),'^0+','')"/>
      </xsl:when>
      <xsl:when test="$reftype='insertionend'">
        <xsl:value-of select="doc('../../data/editions/Gesamt.xml')//tei:metamark[contains(@target,$id)]/preceding::tei:pb[1]/replace(replace(@n,'_',' '),'^0+','')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
    <div class="fs-6 ps-3 text-dark-grey pagebreaks pb_signet_background bg-no-repeat bg-position-short-info" id="{$id}" data-xmlid="{replace($target,'#','')}" style="display:none">
      <span><xsl:value-of select="$description||' '||$preceding_pb_val"/></span>
    </div>
</xsl:template>
<xsl:template match="tei:app" mode="short_info">
    <xsl:variable name="xmlid" select="@xml:id"/>
    <div class="fs-6 ps-3 text-dark-grey d-none fackel_signet_background bg-no-repeat bg-position-short-info" data-xmlid="{$xmlid}" data-entity-type="fkl">
        <xsl:apply-templates mode='short_info'/>
    </div>
</xsl:template>
<xsl:template match="tei:rdg" mode="short_info">
  <xsl:variable name="source" select="@source"/>
  <div>
      <div>
        <xsl:choose>
          <xsl:when test="$source='Motti'">
              <xsl:text>Motti (1933):</xsl:text>
          </xsl:when>
          <xsl:when test="$source='DW'">
              <xsl:text>Dritte Walpurgisnacht (1933):</xsl:text>
          </xsl:when>
          <xsl:when test="$source='F890'">
              <xsl:text>F890 (1934):</xsl:text>
          </xsl:when>
          <xsl:when test="$source='F381'">
              <xsl:text>F381 (1913):</xsl:text>
          </xsl:when>
        </xsl:choose>
      </div>
      <div>
      <xsl:if test="not(node()/name() = 'pb')">
        <xsl:apply-templates/>
      </xsl:if>
        <xsl:call-template name="join-rdgs">
          <xsl:with-param name="element" select="parent::tei:app"/>
          <xsl:with-param name="source" select="$source"/>
        </xsl:call-template>
      </div>
  </div>
</xsl:template>
<xsl:template name="join-rdgs">
  <xsl:param name="element"/>
  <xsl:param name="source"/>
  <xsl:if test="$element/@next">
    <xsl:variable name="nextId" select="substring-after($element/@next,'#')"/>
    <xsl:variable name="nextElement" select="root()//tei:app[@xml:id=$nextId]"/>
    <xsl:choose>
      <xsl:when test="$source='DW'">
        <xsl:apply-templates select="$nextElement/tei:rdg[@source = $source]"/>
        <xsl:call-template name="join-rdgs">
          <xsl:with-param name="element" select="$nextElement"/>
          <xsl:with-param name="source" select="$source"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$nextElement/tei:rdg[@source = $source]" mode="show"/>
        <xsl:call-template name="join-rdgs">
          <xsl:with-param name="element" select="$nextElement"/>
          <xsl:with-param name="source" select="$source"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>
<xsl:template match="tei:ref[@type=('comment','glossary','event')]" mode="short_info">
  <xsl:variable name="xmlid" select="@xml:id"/>
  <xsl:variable name="type" select="@type"/>
  <xsl:for-each select="tokenize(@target,' ')">
    <xsl:variable name="target" select="substring-after(current(),'#')"/>
    <xsl:variable name="source_element" select="if ($type=('comment','glossary')) then doc('../../data/indices/Kommentar.xml')//tei:seg[@xml:id=$target] else doc('../../data/indices/Events.xml')//tei:event[@xml:id=$target] "/>
    <div data-testid="short_info_{$xmlid||'_'||$target}" class="fs-6 ps-3 text-dark-grey comments comment_signet_background bg-no-repeat bg-position-short-info" data-xmlid="{$xmlid}" style="display:none">
      <a class="text-dark-grey text-decoration-none text-wpn-comment-hover" href="{'#'||$xmlid||'_'||$target}">
        <xsl:apply-templates select="$source_element" mode="short_info">
          <xsl:with-param name="ref_type" select="$type"/>
        </xsl:apply-templates>
        <xsl:call-template name="icon">
          <xsl:with-param name="icon_name" select="'expand_info'"/>
        </xsl:call-template>
      </a>
    </div>
  </xsl:for-each>
</xsl:template>
<xsl:template match="tei:note[@type='relation']" mode="persgrpnote">
  <xsl:apply-templates mode="persgrpnote"/>
</xsl:template>
<xsl:template match="tei:note[@type='source']" mode="persgrpnote">
  <xsl:text> (lt. </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>)</xsl:text>  
  </xsl:template>
  <xsl:template match="text()" mode="persgrpnote">
    <xsl:value-of 
      select="normalize-space(.)"/>
  </xsl:template>
</xsl:stylesheet>