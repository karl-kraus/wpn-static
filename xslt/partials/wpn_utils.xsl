<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:wpn="https://wpn.acdh.oeaw.ac.at" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
  <xsl:function name="wpn:hascontent">
    <xsl:param name="input"/>
    <xsl:value-of select="string-length(normalize-space(string-join($input, ''))) &gt; 0"/>
  </xsl:function>
  <xsl:function name="wpn:genregisterletter">
    <xsl:param name="input"/>
    <xsl:value-of select="replace(normalize-unicode(upper-case(substring($input,1,1)),'NFKD'),'\P{IsBasicLatin}','')"/>
  </xsl:function>
  <xsl:function name="wpn:monthfromnumber">
    <xsl:param name="input"/>
    <xsl:choose>
      <xsl:when test="$input='01'">Januar</xsl:when>
      <xsl:when test="$input='02'">Februar</xsl:when>
      <xsl:when test="$input='03'">März</xsl:when>
      <xsl:when test="$input='04'">April</xsl:when>
      <xsl:when test="$input='05'">Mai</xsl:when>
      <xsl:when test="$input='06'">Juni</xsl:when>
      <xsl:when test="$input='07'">Juli</xsl:when>
      <xsl:when test="$input='08'">August</xsl:when>
      <xsl:when test="$input='09'">September</xsl:when>
      <xsl:when test="$input='10'">Oktober</xsl:when>
      <xsl:when test="$input='11'">November</xsl:when>
      <xsl:when test="$input='12'">Dezember</xsl:when>
      <xsl:otherwise/>
    </xsl:choose>

  </xsl:function>
  <xsl:function name="wpn:date">
    <xsl:param name="format"/>
    <xsl:param name="input"/>
    <xsl:value-of select="(if ($input castable as xs:date and not(starts-with($input,'-') or starts-with($input,'0'))) then format-date($input,$format) else if (starts-with($input, '-')) then (xs:integer(substring(substring-after($input,'-'),1,4)) || ' v. Chr.')             else if (starts-with($input, '0')) then (xs:integer(substring($input,1,4)) || ' n. Chr.')             else if (matches($input,'[0-9]{4}-[0-9]{2}$')) then if ($format = '[Y]') then substring($input,1,4) else (wpn:monthfromnumber(substring-after($input,'-'))||' '||substring-before($input,'-')) else substring($input, 1, 4))"/>
  </xsl:function>
  <xsl:function name="wpn:preposition">
    <xsl:param name="input"/>
    <xsl:choose>
      <xsl:when test="matches($input, '^(Anfang|Mitte|Ende)')">
        <xsl:text>von</xsl:text>
      </xsl:when>
      <xsl:when test="$input[@from]">
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>vom</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xsl:function name="wpn:punctuation">
    <xsl:param name="input"/>
    <xsl:param name="addspace"/>
    <xsl:if test="matches($input, '.+[^\\:|\.|\?|\\!]$') and not($input='Die Bibel') and not(ends-with($input,'.“'))">
      <xsl:text>.</xsl:text>
    </xsl:if>
    <xsl:if test="$addspace and not($input='Die Bibel')">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:function>
  <xsl:function name="wpn:brackets">
    <xsl:param name="input"/>
    <xsl:if test="wpn:hascontent($input) = true()">
      <xsl:value-of select="' (' || $input || ')'"/>
    </xsl:if>
  </xsl:function>
  <xsl:function name="wpn:italic">
    <xsl:param name="input"/>
    <xsl:if test="wpn:hascontent($input) = true()">
      <i>
        <xsl:value-of select="$input"/>
      </i>
    </xsl:if>
  </xsl:function>
  <xsl:function name="wpn:bold">
    <xsl:param name="input"/>
    <xsl:if test="wpn:hascontent($input) = true()">
      <b>
        <xsl:value-of select="$input"/>
      </b>
    </xsl:if>
  </xsl:function>
  <xsl:function name="wpn:bold-italic">
    <xsl:param name="input"/>
    <xsl:if test="wpn:hascontent($input) = true()">
      <b>
        <i>
          <xsl:value-of select="$input"/>
        </i>
      </b>
    </xsl:if>
  </xsl:function>
  <xsl:function name="wpn:initials">
    <xsl:param name="input"/>
    <xsl:for-each select="tokenize($input,' ')">
      <xsl:value-of select="substring(current(),1,1)||'.'"/>
      <xsl:if test="position()!=last()">
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:function>
  <xsl:function name="wpn:group-authors">
    <xsl:param name="input"/>
    <xsl:param name="initials"/>
    <xsl:if test="wpn:hascontent($input) = true()">
      <xsl:for-each select="$input">
        <xsl:value-of select="if ($initials = true()) then wpn:initials(current()) else current()"/>
        <xsl:if test="current()[@role]">
          <xsl:value-of select="' ' || wpn:brackets(current()/@role)"/>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="position() != last()">
            <xsl:text>, </xsl:text>
          </xsl:when>
          <xsl:when test="$input/following-sibling::*[1]/local-name()='citedRange'">.</xsl:when>
          <xsl:otherwise>
            <xsl:text>: </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:function>
  <xsl:function name="wpn:group-authors-bold">
    <xsl:param name="input"/>
    <xsl:param name="initials"/>
    <xsl:if test="wpn:hascontent($input) = true()">
      <b>
        <xsl:for-each select="$input">
          <xsl:value-of select="if ($initials = true()) then wpn:initials(current()) else current()"/>
          <xsl:if test="current()[@role]">
            <xsl:value-of select="' ' || wpn:brackets(current()/@role)"/>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$input/following-sibling::*[1]/local-name()='citedRange'">.</xsl:when>
            <xsl:otherwise>
              <xsl:text>: </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </b>
    </xsl:if>
  </xsl:function>
  <xsl:function name="wpn:get-event-date">
        <xsl:param name="event" as="node()"/>
        <xsl:param name="categories"/>
            <xsl:if test="$event[@when|@notBefore|@from]">
                (<xsl:value-of select="string-join(reverse(for $t in tokenize(data($event/(@when|@notBefore|@from)),'-') return number($t)),'. ')"/>
                <xsl:if test="$event[@notAfter|@to]">
                    <xsl:text> – </xsl:text>
                    <xsl:value-of select="string-join(reverse(for $t in tokenize(data($event/(@when|@notAfter|@to)),'-') return number($t)),'. ')"/>
                </xsl:if>
              <xsl:if test="count($categories) &gt; 0">
                <xsl:value-of select="if (count($categories) &gt; 1) then ', Kategorien: ' else ', Kategorie: '"/>
                <xsl:for-each select="$categories">
                  <span part="event_cat" onmouseover="hoverEvents('{current()}')" onmouseout="unhoverEvents()"><xsl:value-of select="current()"/></span>
                  <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
              </xsl:if>)
            </xsl:if>
    </xsl:function>
    <xsl:function name="wpn:capitalize">
    <xsl:param name="date" as="xs:string"/>
    <xsl:choose>
        <xsl:when test="$date[matches(.,'^[a-z]')]">
          <xsl:value-of select="(upper-case(substring($date,1,1))||substring($date,2))"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$date"/>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:function>
    <xsl:function name="wpn:parse-page-name">
    <xsl:param name="page" as="xs:string"/>
    <xsl:param name="output" as="xs:string"/>
    <xsl:choose>
        <xsl:when test="$page[matches(.,'[0-9]+')]">
          <xsl:choose>
            <xsl:when test="$output = 'label'">
              <xsl:value-of select="'Absatz ' || number($page)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'absatz_'||number($page)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$output = 'label'">
              <xsl:value-of select="$page"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="replace(lower-case($page),'\p{P}','')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:function>
    <xsl:function name="wpn:normalizePagename">
        <xsl:param name="page"/>
        <xsl:param name="type"/>
        <xsl:variable name="normalized">
            <xsl:value-of select="replace($page,'[^A-Za-z,0-9]','')"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$type='link'">
                <xsl:value-of select="if (matches($normalized,'[0-9]')) then 'absatz_'||number($normalized) else lower-case($normalized)" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="if (matches($normalized,'[0-9]')) then 'Absatz '||number($normalized) else $page" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>