<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" 
    version="2.0" exclude-result-prefixes="xsl tei xs wpn">
    
    <xsl:template match="tei:person" mode="detail_view">
      <!--<xsl:result-document href="{@xml:id||'.html'}" method="html">-->
        <div class="d-none p-1 ps-0 pt-0 overflow-visible ls-2" id="{'details_'||@xml:id}">   
            <div class="person_signet_background position-sticky my-0 mw-100 top-18 px-2 ps-3 pt-2">
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
    <xsl:template match="tei:person" mode="kwic">
    <div class="border-bottom border-light-grey pb-1 mt-1">
        <a class="text-decoration-none text-dark-grey user-select-none" role="button" data-bs-toggle="collapse" data-bs-target="{'#kwics_'||@xml:id}" aria-expanded="false" aria-controls="{'kwics_'||@xml:id}">
        Textstellen
        </a>
        <div id="{'kwics_'||@xml:id}" class="collapse p-1 no-transition ff-century-old-style">
            <xsl:for-each select="descendant::tei:rs">
                <xsl:variable name="kwic_hit" select="collection('../../data/merged?select=*.html')//span[@id=current()/@xml:id]"/>
                <xsl:variable name="prev_text" select="string($kwic_hit/string-join(preceding::text()))"/>
                <xsl:variable name="following_text" select="string($kwic_hit/string-join(following::text()))"/>
                <xsl:variable name="kwic_left" select="substring($prev_text, string-length($prev_text) - 56)"/>
                <xsl:variable name="kwic_right" select="substring($following_text, 1, 56)"/>
                <xsl:if test="string-length($kwic_left) > 0">
                    <span class="text-light-grey"><xsl:copy-of select="'...'||$kwic_left"/></span>
                </xsl:if>
                <span class="text-kwic-grey"><xsl:copy-of select="$kwic_hit"/></span>
                    <xsl:if test="string-length($kwic_right) > 0">
                    <span class="text-light-grey"><xsl:copy-of select="$kwic_right||'...'"/></span>
                </xsl:if>
            </xsl:for-each>
        </div>
    </div>
    </xsl:template>
    <xsl:template match="tei:person" mode="list_view">
    <div id="{@xml:id}" class="py-1_5 px-2_5 fs-8_75 border-bottom border-light-grey lh-1625">
         <wpn-reg-entry class="text-black-grey text-decoration-none text-blacker-grey-hover fw-medium-hover" href="{'#'||@xml:id}">
                <xsl:apply-templates select="." mode="short"/>
         </wpn-reg-entry>
    </div>
    </xsl:template>
    <xsl:template match="tei:person">
        <xsl:apply-templates select="tei:persName[not(@full)][not(@type)]"/>
        <xsl:apply-templates select="tei:birth"/>
        <xsl:apply-templates select="tei:death"/>
        <xsl:apply-templates select="tei:occupation"/>
        <xsl:for-each select="tei:affiliation">
            <xsl:if test="position() = 1">
                <xsl:value-of select="' ('"/>
            </xsl:if>
            <xsl:apply-templates select="current()"/>
            <xsl:if test="position() != last()">
                <xsl:value-of select="','"/>
            </xsl:if>
            <xsl:if test="position() = last()">
                <xsl:value-of select="')'"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>.</xsl:text>
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
        <xsl:apply-templates select="tei:forename[not(@subtype='unused')]"/>
        <xsl:apply-templates select="tei:forename[@subtype='unused']"/>
        <xsl:apply-templates select="tei:surname[not(@subtype='unused')][not(@type='maiden')]"/>
        <xsl:apply-templates select="tei:surname[@subtype='unused']"/>
        <xsl:apply-templates select="tei:surname[@type='maiden']"/>
    </xsl:template>
    <xsl:template match="tei:persName[not(child::element())]" mode="short">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="tei:forename">
        <xsl:if test="preceding-sibling::tei:forename">
            <xsl:value-of select="' '"/>
        </xsl:if>
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="tei:surname">
        <xsl:value-of select="' '||."/>
    </xsl:template>
    <xsl:template match="tei:addName">
        <xsl:value-of select="' '||."/>
    </xsl:template>
    <xsl:template match="tei:nameLink">
        <xsl:value-of select="' '||."/>
    </xsl:template>
     <xsl:template match="tei:genName">
        <xsl:value-of select="' '||."/>
    </xsl:template>
    <xsl:template match="tei:surname[@type='maiden']">
        <xsl:value-of select="' (geb. '||.||')'"/>
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
        <xsl:value-of select="( if (not(preceding-sibling::tei:occupation)) then ' ' else ', ')||."/>
    </xsl:template>
    <xsl:template match="tei:affiliation">
        <xsl:value-of select="."/>
    </xsl:template>
     <xsl:template match="tei:forename[@subtype='unused']">
       <xsl:value-of select="' ('||.||')'"/>
    </xsl:template>
     <xsl:template match="tei:surname[@subtype='unused']">
        <xsl:value-of select="' ('||.||')'"/>
    </xsl:template>
    <xsl:template match="tei:birth|tei:death">
        <xsl:value-of select="if (self::tei:birth) then (', '||.) else (' – '||.||'.')"/>
    </xsl:template>
    <xsl:template match="tei:idno[@type='GND']" mode="detail_view_reg">
    <div class="border-bottom border-light-grey pb-1">
        <a class="text-decoration-none text-dark-grey" target="_blank" href="{'http://d-nb.info/gnd/'||.}"><span class="pe-2">Link</span><span class="pe-2 text-blacker-grey-hover">GND</span></a>
        <svg width="5" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061"><defs><style>.a{fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;}</style></defs><path class="a" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path></svg>
    </div>
    </xsl:template>
</xsl:stylesheet>