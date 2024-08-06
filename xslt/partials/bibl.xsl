<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    version="2.0" exclude-result-prefixes="xsl tei xs wpn">
    <xsl:import href="./wpn_utils.xsl"/>
    <!-- templates for bibl elements and descendants -->
    <!-- template for the intertext register -->
    <xsl:template match="tei:bibl" mode="detail_view">
        <div class="d-none p-1 ps-0 pt-0 overflow-visible ls-2" id="{'details_'||@xml:id}">
            <div
                class="quote_signet_background my-0 mw-100 top-18 px-2 ps-3 pt-2">
                <div class="border-0 flex flex-column">
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
                        <xsl:apply-templates select="tei:ref[@type = 'gen']" mode="detail_view_reg"/>
                        <xsl:apply-templates select="@corresp" mode="detail_view_reg"/>
                        <!--<xsl:apply-templates select="." mode="kwic"/>-->
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <!-- template for the kwics needed in the intertext register -->
    <xsl:template match="tei:bibl" mode="kwic">
        <div class="border-bottom border-light-grey pb-1 mt-1">
            <a class="text-decoration-none text-dark-grey user-select-none" role="button" data-bs-toggle="collapse" data-bs-target="{'#kwics_'||@xml:id}" aria-expanded="false" aria-controls="{'kwics_'||@xml:id}">
            Textstellen
            </a>
            <div id="{'kwics_'||@xml:id}" class="collapse p-1 no-transition ff-century-old-style">
                <xsl:for-each select="descendant::tei:quote">
                    <xsl:variable name="kwic_hit"
                        select="collection('../data/merged?select=*.html')//span[@id = current()/@xml:id]"/>
                    <xsl:variable name="prev_text"
                        select="string($kwic_hit/string-join(preceding::text()))"/>
                    <xsl:variable name="following_text"
                        select="string($kwic_hit/string-join(following::text()))"/>
                    <xsl:variable name="kwic_left"
                        select="substring($prev_text, string-length($prev_text) - 56)"/>
                    <xsl:variable name="kwic_right" select="substring($following_text, 1, 56)"/>
                    <xsl:if test="string-length($kwic_left) > 0">
                        <span class="text-light-grey">
                            <xsl:copy-of select="'...' || $kwic_left"/>
                        </span>
                    </xsl:if>
                    <span class="text-kwic-grey">
                        <xsl:copy-of select="$kwic_hit"/>
                    </span>
                    <xsl:if test="string-length($kwic_right) > 0">
                        <span class="text-light-grey">
                            <xsl:copy-of select="$kwic_right || '...'"/>
                        </span>
                    </xsl:if>
                </xsl:for-each>
            </div>
        </div>
    </xsl:template>
    <!-- template for the list view entries needed in the intertext register -->
    <xsl:template match="tei:bibl" mode="list_view">
        <div 
            class="py-1_5 px-2_5 fs-8_75 border-bottom border-light-grey lh-1625">
            <a class="text-black-grey text-decoration-none text-blacker-grey-hover ff-ubuntu-500-hover" href="{'#'||@xml:id}">
                <xsl:apply-templates select="."/>
            </a>
        </div>
    </xsl:template>
    <!-- template for long citation -->
    <xsl:template match="tei:bibl">
        <span>
            <xsl:choose>
                <xsl:when test="@sortKey = 'N._N.'">
                    <xsl:value-of select="'N. N.'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="tei:author"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="tei:author or @sortKey = 'N._N.'">
                <xsl:value-of select="': '"/>
            </xsl:if>
            <xsl:variable name="citation">
                <xsl:apply-templates select="tei:title[not(@level = 's')]"/>
                <xsl:choose>
                    <xsl:when test="descendant::tei:title[@level = 'm']">
                        <xsl:if test="not(descendant::tei:title[@level = 's'])">
                            <xsl:apply-templates select="tei:num"/>
                        </xsl:if>
                        <xsl:apply-templates select="tei:editor"/>
                        <xsl:apply-templates select="tei:pubPlace"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="tei:pubPlace"/>
                        <xsl:if test="not(descendant::tei:title[@level = 's'])">
                            <xsl:apply-templates select="tei:num"/>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:apply-templates select="tei:date"/>
                <xsl:if test="descendant::tei:title[@level = 's']">
                    <xsl:apply-templates select="descendant::tei:title[@level = 's']"/>
                </xsl:if>
                <xsl:apply-templates select="tei:biblScope"/>
            </xsl:variable>
            <xsl:copy-of select="$citation"/>
            <xsl:if test="not(matches(normalize-space($citation), '\.$'))">
                <xsl:text>.</xsl:text>
            </xsl:if>
        </span>
    </xsl:template>
    <!-- template for newspaper short citation -->
    <xsl:template match="tei:bibl[descendant::tei:title[@level='j']]" mode="short">
        <xsl:apply-templates select="if (tei:title[@level='j'][@type='short']) then tei:title[@level='j'][@type='short'] else tei:title[@level='j']" mode="short"/>
         <!--<xsl:value-of select="wpn:preposition(tei:date)"/>
         <xsl:value-of select="tei:date/text()"/>-->
         <xsl:apply-templates select="tei:date" mode="short"/>
    </xsl:template>
    <!-- template for non-newspaper short citation -->
    <xsl:template match="tei:bibl[not(descendant::tei:title[@level='j'])]" mode="short">
        <xsl:apply-templates select="tei:title[@level='a'][not(@type='subtitle')] | tei:title[@level='m'][not(@type='subtitle')]" mode="short"/>
    </xsl:template>
    <!-- template for authors -->
    <xsl:template match="tei:author">
        <xsl:param name="initials_only"/>
        <xsl:param name="skip_role" as="xs:boolean" select="false()"/>
        <span>
            <xsl:value-of select="
                    if ($initials_only) then
                        wpn:initials(.)
                    else
                        ."/>
            <xsl:if test="@role and $skip_role = false()">
                <xsl:value-of select="' (' || @role || ')'"/>
            </xsl:if>
            <xsl:if test="not(position() = last())">
                <xsl:value-of select="', '"/>
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="tei:title[not(@type = 'short')][@level = 'j'][text()]">
        <i>
            <xsl:if test="preceding-sibling::tei:title and not(@type = 'subtitle')">
                <xsl:text> In: </xsl:text>
            </xsl:if>
            <xsl:if test="@type = 'subtitle' and preceding-sibling::tei:title[@level = 'j']">
                <xsl:value-of select="'. '"/>
            </xsl:if>
            <xsl:value-of select="."/>
        </i>
    </xsl:template>
    <xsl:template match="tei:title[@type = 'short']"/>
    <xsl:template match="tei:title[@level = 'j']" mode="short">
        <i><xsl:value-of select="."/></i>
    </xsl:template>
    <xsl:template match="tei:biblScope">
        <xsl:choose>
            <xsl:when test="preceding-sibling::tei:title[@level = ('j', 'a', 'm')]">
                <span>
                    <xsl:value-of select="', ' || ."/>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:date[not(@from)][not(@to)]">
        <xsl:choose>
            <xsl:when test="preceding-sibling::tei:title[@level = 'j']">
                <span>
                    <xsl:value-of select="' ' || wpn:preposition(.) || ' ' || string-join(text())"/>
                    <xsl:apply-templates select="tei:note" mode="date_note"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span>
                    <xsl:value-of select="' ' || wpn:capitalize(string-join(text()))"/>
                    <xsl:apply-templates select="tei:note" mode="date_note"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:date[not(@from)][not(@to)]" mode="short">
        <xsl:choose>
            <xsl:when test="preceding-sibling::tei:title[@level = 'j']">
                <span>
                    <xsl:value-of select="' ' || wpn:preposition(.) || ' ' || string-join(text())"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span>
                    <xsl:value-of select="' ' || wpn:capitalize(string-join(text()))"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:date[@from or @to]">
        <xsl:value-of select="' ' || string-join(text())"/>
        <xsl:apply-templates select="tei:note" mode="date_note"/>
    </xsl:template>
    <xsl:template match="tei:date[@from or @to]" mode="short">
        <xsl:value-of select="' ' || string-join(text())"/>
    </xsl:template>
    <xsl:template match="tei:pubPlace">
        <xsl:choose>
            <xsl:when test="preceding-sibling::tei:title[@level = 'j']">
                <span>
                    <xsl:value-of select="' ('"/>
                    <xsl:apply-templates
                        select="preceding-sibling::tei:edition | following-sibling::tei:edition"/>
                    <xsl:value-of select="."/>
                    <xsl:value-of select="')'"/>
                    <xsl:if test="following-sibling::tei:date[@from][@to]">
                        <xsl:value-of select="'.'"/>
                    </xsl:if>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="' ' || ."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:note" mode="date_note">
        <span>
            <xsl:value-of select="' (' || . || ')'"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:num">
        <span>
            <xsl:choose>
                <xsl:when test="preceding-sibling::tei:title[@level = ('a', 'j', 's')]">
                    <xsl:value-of select="', '"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="' '"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="."/>
            <xsl:if
                test="preceding-sibling::tei:title[1][not(@level = ('j', 's'))] and not(ends-with(., '.'))">
                <xsl:value-of select="'.'"/>
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="tei:title[@level = 's']">
        <xsl:value-of select="' (= ' || ."/>
        <xsl:apply-templates select="following-sibling::tei:num"/>
        <xsl:value-of select="')'"/>
    </xsl:template>
    <xsl:template match="tei:editor">
        <xsl:value-of select="
                ' ' || @role || (if (@role = 'Hg.') then
                    ' v. '
                else
                    ()) || ' ' || . || (if (not(ends-with(., '.'))) then
                    '.'
                else
                    ())"/>
    </xsl:template>
    <xsl:template match="tei:edition">
        <xsl:value-of select=". || ', '"/>
    </xsl:template>
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:ref[@type='gen']" mode="detail_view_reg">
        <xsl:variable name="linktext">
        <xsl:apply-templates select="./ancestor::tei:bibl" mode="short"/>
        </xsl:variable>
        <xsl:variable name="linklabel">
            <xsl:choose>
                <xsl:when test="@subtype = 'specific'">
                    <xsl:text>Link </xsl:text>
                </xsl:when>
                <xsl:when test="@subtype = 'example'">
                    <xsl:text>Link (exempl.) </xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <div  class="pb-1 border-bottom border-light-grey">
            <span>
                <xsl:value-of select="$linklabel"/>
            </span>
            <a class="text-decoration-none text-dark-grey" href="{@target}">
                <xsl:copy-of select="$linktext"/>
            </a>
        </div>
    </xsl:template>
    <xsl:template match="@corresp" mode="detail_view_reg">
        <div class="pb-1 border-bottom border-light-grey">
            <span>Scan: </span>
            <span><xsl:apply-templates select="./ancestor::tei:bibl" mode="short"/></span>
        </div>
    </xsl:template>
</xsl:stylesheet>
