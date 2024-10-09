<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" 
    version="2.0" exclude-result-prefixes="xsl tei xs wpn">
    <xsl:import href="./wpn_utils.xsl"/>
    <xsl:template match="tei:person" mode="detail_view">
      <!--<xsl:result-document href="{@xml:id||'.html'}" method="html">-->
        <div class="d-none p-1 ps-0 pt-0 overflow-visible ls-2" id="{'details_'||@xml:id}">   
            <div class="person_signet_background my-0 mw-100 top-18 px-2 ps-3 pt-2">
                <div class="border-0 d-flex flex-column">
                    <div class="d-flex justify-content-between">
                        <h2 class="fs-8_75 text-black-grey fw-normal">Registereintrag</h2>
                        <button class="border-0 bg-transparent">
                            <svg class="align-top" width="10" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 7.778 7.778"><defs><style>.a{fill:none;stroke:#d8d8d8;stroke-width:2px;}</style></defs><g transform="translate(0.707 0.707)"><line class="a" x2="9" transform="translate(0 0) rotate(45)"></line><line class="a" x2="9" transform="translate(0 6.364) rotate(-45)"></line></g></svg>
                        </button>
                    </div>
                    <div class="fs-6 text-dark-grey p-0">
                        <div class="mb-2_5">
                            <xsl:apply-templates select="."/>
                        </div>
                        <div class="d-flex justify-content-end">
                            <xsl:apply-templates select="tei:note[@type='source'][@subtype='publ']" mode="detail_view_reg"/>
                        </div>
                        <xsl:apply-templates select="tei:ref[@type='gen']" mode="detail_view_reg"/>
                        <xsl:apply-templates select="@corresp" mode="detail_view_reg"/>
                        <xsl:apply-templates select="tei:idno[@type='GND']" mode="detail_view_reg"/>
                        <xsl:apply-templates select="." mode="kwic"/>
                    </div>
                </div>
            </div>
        </div>
<!--</xsl:result-document>-->
    </xsl:template>
    <xsl:template match="tei:person" mode="detail_view_textpage">
        <xsl:param name="id" />
        <xsl:param name="id_in_text" />
        <xsl:param name="cert_subtype" />
        <xsl:param name="group_id" />
        <!--<xsl:result-document
        href="{@xml:id||'.html'}" method="html">-->
        <div class="d-none p-1 ps-0 pt-0 overflow-visible ls-2"
        id="{'details_'||$id_in_text||(if ($group_id) then ('_'||$group_id) else ())||'_'||(if ($id) then $id else @xml:id)}">
            <div class="person_signet_background my-0 mw-100 top-18 px-2 ps-2 pt-1">
                <div class="border-0">
                <button class="float-end border-0 bg-transparent close-button">
                    <svg class="align-top" width="10" height="10" xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 7.778 7.778">
                    <defs>
                        <style>.a{fill:none;stroke:#d8d8d8;stroke-width:2px;}</style>
                    </defs>
                    <g transform="translate(0.707 0.707)">
                        <line class="a" x2="9" transform="translate(0 0) rotate(45)"></line>
                        <line class="a" x2="9" transform="translate(0 6.364) rotate(-45)"></line>
                    </g>
                    </svg>
                </button>
                <div class="fs-6 text-dark-grey p-0 pt-1">
                    <div class="mb-2_5">
                    <span>
                        <xsl:if test="not($group_id)">
                        <xsl:value-of select="$cert_subtype" />
                        </xsl:if>
                    </span>
                    <xsl:apply-templates select="." />
                    </div>
                    <div class="d-flex justify-content-end">
                    <xsl:apply-templates select="tei:note[@type='source'][@subtype='publ']"
                        mode="detail_view_reg" />
                    </div>
                    <xsl:apply-templates select="tei:ref[@type='gen']" mode="detail_view_reg" />
                    <xsl:apply-templates select="@corresp" mode="detail_view_reg" />
                    <xsl:apply-templates select="tei:idno[@type='GND']" mode="detail_view_reg" />
                    <div class="py-1 border-bottom border-light-grey">
                    <span>Register</span>
                    <a class="text-decoration-none text-dark-grey ps-2"
                        href="{'register_personen.html#'||@xml:id}" target="_blank">
                        <xsl:apply-templates select="." mode="short_name_only" />
                        <svg class="ms-2 align-baseline" width="5" height="10"
                        xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                        <defs>
                            <style>
                            .b{fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;}</style>
                        </defs>
                        <path class="b" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path>
                        </svg>
                    </a>
                    </div>
                </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:person" mode="kwic">
    <details class="border-bottom border-light-grey pb-1 mt-1">
        <summary class="d-flex align-items-baseline">Textstellen</summary>
        <div id="{'kwics_'||@xml:id}">
            <xsl:for-each select="descendant::tei:rs">
                <xsl:variable name="kwic_hit" select="collection('../../data/merged?select=*.html')//span[@id=current()/@xml:id]"/>
                <xsl:variable name="prev_text" select="string($kwic_hit/string-join(preceding::text()))"/>
                <xsl:variable name="following_text" select="string($kwic_hit/string-join(following::text()))"/>
                <xsl:variable name="kwic_left" select="substring($prev_text, string-length($prev_text) - 56)"/>
                <xsl:variable name="kwic_right" select="substring($following_text, 1, 56)"/>
                <div class="text-kwic-grey d-flex justify-content-between align-items-end position-relative">
                    <div class="kwic-wrapper w-80 ff-century-old-style p-08">
                        <xsl:if test="string-length($kwic_left) > 0">
                            <span class="text-light-grey"><xsl:copy-of select="'...'||$kwic_left"/></span>
                        </xsl:if>
                        <span class="text-kwic-grey"><xsl:copy-of select="$kwic_hit"/></span>
                        <xsl:if test="string-length($kwic_right) > 0">
                            <span class="text-light-grey"><xsl:copy-of select="$kwic_right||'...'"/></span>
                        </xsl:if>
                    </div>
                    <div>
                        <a href="{$kwic_hit/ancestor::body/@data-teiid||'.html#'||current()/@xml:id}" class="text-decoration-none link-dark-grey stretched-link ff-ubuntu m-0 p-08">
                            <xsl:value-of select="$kwic_hit/ancestor::body/@data-label"/>
                        </a>
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </details>
    </xsl:template>
    <xsl:template match="tei:person" mode="list_view">
    <div  id="{@xml:id}" class="py-1_5 px-2_5 fs-8_75 border-bottom border-light-grey lh-1625">
         <a class="text-black-grey text-decoration-none text-blacker-grey-hover ff-ubuntu-500-hover" href="{'#'||@xml:id}">
                <xsl:apply-templates select="." mode="short"/>
         </a>
    </div>
    </xsl:template>
    <xsl:template match="tei:person">
        <xsl:choose>
            <xsl:when test="tei:persName[@full]">
                <xsl:apply-templates select="tei:persName[@full]" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="tei:persName[not(@type='pseud')]" />
                <xsl:if test="tei:persName[@type='pseud']">
                <xsl:text> (Pseud. </xsl:text>
                <xsl:apply-templates select="tei:persName[@type='pseud']" />
                <xsl:text>)</xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="tei:birth"/>
        <xsl:apply-templates select="tei:death"/>
        <xsl:apply-templates select="tei:occupation">
            <xsl:sort select="@type" order="descending"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="tei:affiliation"/>
    </xsl:template>
    <xsl:template match="tei:person" mode="short">
        <xsl:apply-templates select="tei:persName[not(@full)][not(@type)]" mode="short"/>
        <xsl:apply-templates select="tei:birth" mode="short"/>
        <xsl:apply-templates select="tei:death" mode="short"/>
        <xsl:apply-templates select="tei:occupation[@type='prim']" mode="short"/>
        <xsl:for-each select="tei:affiliation">
            <xsl:if test="position() = 1">
                <xsl:value-of select="' ('"/>
            </xsl:if>
            <xsl:apply-templates select="current()"/>
            <xsl:if test="position() != last()">
                <xsl:value-of select="."/>
            </xsl:if>
            <xsl:if test="position() = last()">
                <xsl:value-of select="')'"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:person" mode="short_name_only">
        <xsl:apply-templates select="tei:persName[not(@full)][not(@type)]" mode="short"/>
    </xsl:template>
    <xsl:template match="tei:person" mode="short_info">
        <b><xsl:apply-templates select="tei:persName[not(@full)][not(@type)]" mode="short"/></b>
        <xsl:apply-templates select="tei:birth" mode="short"/>
        <xsl:apply-templates select="tei:death" mode="short"/>
        <xsl:apply-templates select="tei:occupation[@type='prim']" mode="short"/>
        <xsl:for-each select="tei:affiliation">
            <xsl:if test="position() = 1">
                <xsl:value-of select="' ('"/>
            </xsl:if>
            <xsl:value-of select="current()"/>
            <xsl:if test="position() != last()">
                <xsl:value-of select="','"/>
            </xsl:if>
            <xsl:if test="position() = last()">
                <xsl:value-of select="')'"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:persName[child::element()]" mode="short">
        <!-- we iterate to keep correct order of name parts -->
        <xsl:for-each select="descendant::*[not(@type=('nick','honorific','maiden','pseud'))][not(@subtype)]">
            <xsl:apply-templates select="current()"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:persName[child::element()]">
        <xsl:variable name="move_unused_forename_to_end" select="tei:forename[@subtype='unused'][preceding-sibling::tei:forename[@type='taken']]" />
        <xsl:variable name="move_unused_surname_to_end" select="tei:surname[@subtype='unused'][preceding-sibling::tei:surname[@type='taken']]" />
        <xsl:variable name="move_complete_name" select="$move_unused_forename_to_end and $move_unused_surname_to_end" />
        <xsl:apply-templates select="tei:roleName[not(preceding-sibling::*)]" />
        <xsl:apply-templates select="tei:forename[not(@subtype='unused')][not(@subtype='later')]" />
        <xsl:if test="tei:forename[@subtype='unused'] and not($move_complete_name)">
            <xsl:text> (</xsl:text>
            <xsl:if test="tei:forename/@type='taken'">
                <xsl:text>d. i.:  </xsl:text>
            </xsl:if>
            <xsl:apply-templates select="tei:forename[@subtype='unused']">
                <xsl:with-param name="brackets" select="false()" />
            </xsl:apply-templates>
            <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="tei:genName[preceding-sibling::*[1][self::tei:forename]]" />
        <xsl:apply-templates select="tei:addName[not(@type='honorific')][preceding-sibling::*[1][self::tei:forename or self::tei:genName]]" />
        <xsl:apply-templates select="tei:roleName[preceding-sibling::*[1][self::tei:forename or self::tei:genName[preceding-sibling::*[1][self::tei:forename]]]]" />
        <xsl:apply-templates select="tei:nameLink[preceding-sibling::*[1][self::tei:forename or self::tei:roleName[preceding-sibling::*[1][self::tei:forename or self::tei:genName]]]]" />
        <xsl:apply-templates select="tei:surname[not(@subtype='unused')][not(@type=('maiden','pseud'))][not(@subtype='later')][position()=1]" />
        <xsl:apply-templates select="tei:roleName[preceding-sibling::*[1][self::tei:surname]]" />
        <xsl:apply-templates select="tei:nameLink[preceding-sibling::*[1][self::tei:surname or self::tei:roleName[preceding-sibling::*[1][self::tei:surname]]]]" />
        <xsl:apply-templates select="tei:surname[not(@subtype='unused')][not(@type=('maiden','pseud'))][not(@subtype='later')][not(position()=1)]" />
        <xsl:apply-templates select="tei:genName[preceding-sibling::*[1][self::tei:surname]]" />
        <xsl:apply-templates select="tei:addName[not(@type='honorific')][preceding-sibling::*[1][self::tei:surname]]" />
        <xsl:if test="tei:surname[@subtype='unused'] and not($move_complete_name)">
            <xsl:text> (</xsl:text>
            <xsl:if test="tei:surname/@type='taken'">
                <xsl:text>d. i.:  </xsl:text>
            </xsl:if>
            <xsl:apply-templates select="tei:surname[@subtype='unused']">
                <xsl:with-param name="brackets" select="false()" />
            </xsl:apply-templates>
            <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="tei:surname[@type='maiden']" />
        <xsl:if test="$move_unused_forename_to_end and $move_unused_surname_to_end">
            <xsl:text> (d. i.: </xsl:text>
            <xsl:apply-templates select="tei:*[@subtype='unused']">
                <xsl:with-param name="brackets" select="false()" />
            </xsl:apply-templates>
            <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:if test="tei:*[@subtype='later']">
            <xsl:text> (später: </xsl:text>
            <xsl:apply-templates select="tei:*[@subtype='later']">
                <xsl:with-param name="brackets" select="false()" />
            </xsl:apply-templates>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:persName[not(child::element())]" mode="short">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="tei:forename">
        <xsl:if test="preceding-sibling::tei:forename">
            <xsl:value-of select="' '"/>
        </xsl:if>
        <xsl:value-of select="if (@type='nick') then '('||.||')' else ."/>
    </xsl:template>
    <xsl:template match="tei:surname">
        <xsl:value-of select="' '||normalize-space(.)"/>
    </xsl:template>
    <xsl:template match="tei:addName">
        <xsl:value-of select="' '||."/>
    </xsl:template>
    <xsl:template match="tei:nameLink">
        <xsl:value-of select="' '||."/>
    </xsl:template>
    <xsl:template match="tei:roleName">
        <xsl:value-of select="if (not(preceding-sibling::*)) then .||' ' else ' '||."/>
    </xsl:template>
     <xsl:template match="tei:genName">
        <xsl:value-of select="' '||."/>
    </xsl:template>
    <xsl:template match="tei:surname[@type='maiden']">
        <xsl:text> (geb. </xsl:text>
        <xsl:value-of select="."/>
        <xsl:if test="following-sibling::tei:surname[@type='pseud']">
            <xsl:value-of select="', Pseud. '|| following-sibling::tei:surname[@type='pseud']/text()"/>
        </xsl:if>
        <xsl:text>)</xsl:text>
    </xsl:template>
    <xsl:template match="tei:note[@type='source'][@subtype='publ']" mode="detail_view_reg">
        <a href="#" data-bs-toggle="popover" data-bs-content="{.}"  data-bs-placement="left" data-bs-trigger="hover" data-bs-custom-class="ff-ubuntu">
            <svg width="18" height="18" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 25"><g fill="none" stroke="#d8d8d8" stroke-width="1"><circle cx="12.5" cy="12.5" r="12.5" stroke="none"></circle><circle cx="12.5" cy="12.5" r="12" fill="none"></circle></g><g transform="translate(8.229 8.025)"><path d="M4253.114,129.086v-5.543h3.88" transform="translate(-4253.114 -123.543)" fill="none" stroke="#999" stroke-linejoin="round" stroke-width="1"></path><g transform="translate(2.5 4.5)"><line x2="6.041" fill="none" stroke="#999" stroke-width="1"></line><line x2="6.041" transform="translate(0 2.225)" fill="none" stroke="#999" stroke-width="1"></line><line x2="6.041" transform="translate(0 4.45)" fill="none" stroke="#999" stroke-width="1"></line></g></g></svg>
        </a>
    </xsl:template>
    <xsl:template match="tei:birth|tei:death" mode="short">
    <xsl:variable name="separator" select="if (starts-with(@when,'-') or starts-with(@when,'0')) then ' – ' else  '–'"/>
    <xsl:variable name="addendum" select="if (starts-with(@when,'-')) then ' v. Chr.' else if (starts-with(@when,'0')) then ' n. Chr.' else ()"/>
    <xsl:variable name="year">
        <xsl:choose>
            <xsl:when test="@when castable as xs:date">
                <xsl:value-of select="abs(year-from-date(xs:date(@when)))"/>
            </xsl:when>
            <xsl:when test="@when castable as xs:integer">
                <xsl:value-of select="abs(number(@when))"/>
            </xsl:when>
            <xsl:when test="matches(@when,'\d{4}\-\d{2}$')">
                <xsl:value-of select="abs(number(substring(@when,1,4)))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
        <xsl:value-of select="(if (self::tei:birth) then ', ' else $separator)||$year||$addendum"/>
    </xsl:template>
    <xsl:template match="tei:occupation[@type='prim']" mode="short">
        <xsl:value-of select="', '||."/>
    </xsl:template>
    <xsl:template match="tei:occupation">
        <xsl:text> </xsl:text>
        <xsl:choose>
        <xsl:when test="@when">
            <xsl:value-of select="wpn:date('[D]. [M]. [Y]', @when) || ' '" />
            <xsl:apply-templates mode="reg" />
        </xsl:when>
        <xsl:when test="@notAfter and not(@notBefore)">
            <xsl:choose>
            <xsl:when test="@type = 'prim'">
                <xsl:value-of select="'Bis ' || wpn:date('[D]. [M]. [Y]', @notAfter) || ' '" />
                <xsl:apply-templates mode="reg" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'bis ' || wpn:date('[D]. [M]. [Y]', @notAfter) || ' '" />
                <xsl:apply-templates mode="reg" />
            </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when
            test="@notBefore and (not(@notAfter) or @notAfter[. = ./ancestor::tei:person/tei:death/@when])">
            <xsl:choose>
            <xsl:when test="position() = 1">
                <xsl:value-of select="' Ab ' || wpn:date('[D]. [M]. [Y]', @notBefore) || ' '" />
                <xsl:apply-templates mode="reg" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'ab ' || wpn:date('[D]. [M]. [Y]', @notBefore) || ' '" />
                <xsl:apply-templates mode="reg" />
            </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="@notBefore and @notAfter">
            <xsl:value-of
            select="wpn:date('[D]. [M]. [Y]', @notBefore) || ' bis ' || wpn:date('[D]. [M]. [Y]', @notAfter) || ' '" />
            <xsl:apply-templates mode="reg" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates mode="reg" />
        </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position() != last()">,</xsl:if>
        <xsl:if test="position() = last()">.</xsl:if>
    </xsl:template>
    <xsl:template match="tei:affiliation">
        <xsl:text> </xsl:text>
        <xsl:if test="@notAfter">
        <xsl:value-of select="'Bis '||@notAfter||' '" />
        </xsl:if>
        <xsl:if test="@notBefore">
        <xsl:value-of select="(if (position() = 1) then 'Ab ' else 'ab ')||@notBefore||' '" />
        </xsl:if>
        <xsl:value-of select="." />
        <xsl:if test="position() != last()">
        <xsl:value-of select="','" />
        </xsl:if>
        <xsl:if test="position() = last()">
        <xsl:value-of select="'.'" />
        </xsl:if>
    </xsl:template>
     <xsl:template match="tei:forename[@subtype='unused']">
       <xsl:param name="brackets" select="true()"/>
       <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
       <xsl:value-of select="(if ($brackets) then '(' else ())||.||(if ($brackets) then ')' else ())"/>
    </xsl:template>
     <xsl:template match="tei:surname[@subtype='unused']">
        <xsl:param name="brackets" select="true()"/>
        <xsl:if test="position() != 1"><xsl:text> </xsl:text></xsl:if>
        <xsl:value-of select="(if ($brackets) then '(' else ())||.||(if ($brackets) then ')' else ())"/>
    </xsl:template>
    <xsl:template match="tei:birth|tei:death">
        <xsl:value-of select="if (self::tei:birth) then (', '||.) else (' – '||.|| (if (ends-with(.,'.')) then () else '.'))"/>
    </xsl:template>
    <xsl:template match="tei:idno[@type='GND']" mode="detail_view_reg">
    <div class="border-bottom border-light-grey pb-1">
        <a class="text-decoration-none text-dark-grey" target="_blank" href="{'http://d-nb.info/gnd/'||.}"><span class="pe-2">Link</span><span class="pe-2 text-blacker-grey-hover">GND</span></a>
        <svg width="5" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061"><defs><style>.a{fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;}</style></defs><path class="a" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path></svg>
    </div>
    </xsl:template>
    <xsl:template match="text()" mode="reg">
        <xsl:if test="preceding-sibling::node() and not(starts-with(.,','))">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="normalize-space(.)" />
        <xsl:if test="following-sibling::node()">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:title" mode="reg">
        <i>
            <xsl:apply-templates mode="reg" />
        </i>
    </xsl:template>
</xsl:stylesheet>