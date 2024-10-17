<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="xsl tei xs wpn">
    <xsl:import href="./wpn_utils.xsl"/>
    <xsl:variable name="scan_index" select="json-doc('../../data/indices/scan_index.json')"/>
    <!-- special cases regarding citation style -->
    <xsl:variable name="initials_only_names"
        select="('Hanns Heinz Ewers', 'Jacob und Wilhelm Grimm', 'August von Platen')"/>
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
                        <xsl:apply-templates select="." mode="kwic"/>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <!-- template neded for detail view in edition view -->
    <xsl:template match="tei:bibl" mode="detail_view_textpage">
    <xsl:param name="id" />
    <xsl:param name="quotetype" />
    <xsl:param name="id_in_text" />
    <xsl:variable name="signet_class" select="if (starts-with($id_in_text,'F890')) then 'fackel_signet_background' else 'quote_signet_background'"/>
    <div class="d-none p-1 ps-0 pt-0 overflow-visible ls-2"
        id="{'details_'||$id_in_text||'_'||(if ($id) then $id else @xml:id)}">
        <div class="{$signet_class} my-0 mw-100 top-18 px-2 ps-2 pt-1">
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
                <xsl:value-of select="$quotetype" />
                </span>
                <xsl:apply-templates select=".">
                </xsl:apply-templates>
            </div>
            <xsl:apply-templates select="tei:ref[@type = 'gen']" mode="detail_view_textpage" />
            <xsl:apply-templates select="@corresp" mode="detail_view_textpage" />
            <div class="py-1 border-bottom border-light-grey">
                <span>Register</span>
                <a class="text-decoration-none text-dark-grey ps-2"
                href="{'register_intertexte.html#'||@xml:id}" target="_blank">
                <xsl:apply-templates select="." mode="short" />
                <svg class="ms-2 align-baseline" width="5" height="10"
                    xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                    <path style="fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path>
                </svg>
                </a>
            </div>
            </div>
        </div>
        </div>
    </div>
    </xsl:template>
    <xsl:template match="tei:ref[@type='int'][parent::tei:citedRange]">
    <xsl:param name="quotetype" />
    <xsl:variable name="reftarget" select="replace(@target,'#','')" />
    <xsl:variable name="refnode"
        select="doc('../../data/indices/Register.xml')//tei:citedRange[@xml:id=$reftarget]" />
    <xsl:apply-templates select="$refnode" mode="simple">
        <xsl:with-param name="ref_subtype" select="@subtype" />
        <xsl:with-param name="quotetype" select="$quotetype" />
    </xsl:apply-templates>
    <xsl:choose>
        <xsl:when test="$quotetype ='Berichterstattung dazu z. B. in: '">
        <br />
        <xsl:value-of select="$quotetype" />
        </xsl:when>
        <xsl:otherwise>
        <xsl:if test="@subtype='nonexcl'">
            <xsl:choose>
            <xsl:when test="$refnode/tei:ref[@type='int']">
                <span>, zit. z. B. in: </span>
            </xsl:when>
            <xsl:otherwise>
                <br />
                <span>Zit. z. B. in: </span>
            </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="@subtype='specific'">
            <xsl:choose>
            <xsl:when test="$refnode/tei:ref[@type='int']">
                <span>, zit. in: </span>
            </xsl:when>
            <xsl:otherwise>
                <span><br />Zit. in: </span>
            </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:citedRange" mode="simple">
    <xsl:param name="id" />
    <xsl:param name="quotetype" />
    <xsl:param name="id_in_text" />
    <xsl:param name="ref_subtype" />
    <xsl:param name="initial_cited_range" />
    <!--<xsl:value-of
    select="@xml:id"/>-->
    <span class="fs-6 text-dark-grey p-0 pt-1 d-l">
        <xsl:apply-templates select="tei:ref[@type='int']">
        </xsl:apply-templates>
        <xsl:apply-templates select="ancestor::tei:bibl">
        <xsl:with-param name="render-cited-range" select="normalize-space(string-join(./text()))" />
        <xsl:with-param name="final-dot" select="if (tei:ref[@type='int']) then false() else true()" />
        <xsl:with-param name="detail_view_textpage" select="true()" />
        </xsl:apply-templates>

    </span>
    </xsl:template>
    <xsl:template match="tei:citedRange" mode="detail_view_textpage">
    <xsl:param name="id" />
    <xsl:param name="quotetype" />
    <xsl:param name="id_in_text" />
    <xsl:variable name="signet_class" select="if (starts-with($id_in_text,'F890')) then 'fackel_signet_background' else 'quote_signet_background'"/>
    <xsl:variable name="elem_id" select="'details_'||$id_in_text||'_'||(if ($id) then $id else @xml:id)"/>
    <div class="d-none p-1 ps-0 pt-0 overflow-visible ls-2"
        id="{'details_'||$id_in_text||'_'||(if ($id) then $id else @xml:id)}">
        <div class="{$signet_class} my-0 mw-100 top-18 px-2 ps-2 pt-1">
        <div class="border-0 flex flex-column">
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
                <xsl:if test="$quotetype">
                    <xsl:if test="not($quotetype = 'Berichterstattung dazu z. B. in: ' and tei:ref[@type='int'][@subtype = 'nonexcl'])">   
                        <span>
                            <xsl:value-of select="$quotetype" />
                        </span>
                    </xsl:if>
                </xsl:if>
                <xsl:apply-templates select="tei:ref[@type='int']">
                    <xsl:with-param name="quotetype" select="$quotetype" />
                </xsl:apply-templates>
                <xsl:apply-templates select="ancestor::tei:bibl">
                <xsl:with-param name="render-cited-range"
                    select="normalize-space(string-join(./text()))" />
                <xsl:with-param name="detail_view_textpage" select="true()" />
                </xsl:apply-templates>
            </div>
            <ul data-testid="external_links_{$elem_id}" class="list-unstyled mb-0">
                <xsl:call-template name="ext_links">
                    <xsl:with-param name="node_id" select="@xml:id"/>
                </xsl:call-template>
            </ul>
            <ul data-testid="text_excerpts_{$elem_id}" class="list-unstyled mb-0">
                <xsl:call-template name="text_excerpts">
                    <xsl:with-param name="node_id" select="@xml:id"/>
                </xsl:call-template>
            </ul>
            <ul data-testid="scans_{$elem_id}" class="list-unstyled mb-0">
                <xsl:call-template name="scans">
                    <xsl:with-param name="node_id" select="@xml:id"/>
                </xsl:call-template>
            </ul>
            <ul data-testid="register_links_{$elem_id}" class="list-unstyled mb-0">
                <xsl:call-template name="link_to_register">
                    <xsl:with-param name="node_id" select="@xml:id"/>
                </xsl:call-template>
            </ul>
            </div>
        </div>
        </div>
    </div>
    </xsl:template>
    <!-- template for the kwics needed in the intertext register -->
    <xsl:template match="tei:bibl" mode="kwic">
        <details class="border-bottom border-light-grey pb-1 mt-1">
            <summary class="d-flex align-items-baseline">Textstellen</summary>
            <div id="{'kwics_'||@xml:id}">
                <xsl:for-each select="descendant::tei:quote">
                    <xsl:variable name="kwic_hit"
                        select="collection('../../data/merged?select=*.html')//span[@id = current()/@xml:id]"/>
                    <xsl:variable name="prev_text"
                        select="string($kwic_hit/string-join(preceding::text()))"/>
                    <xsl:variable name="following_text"
                        select="string($kwic_hit/string-join(following::text()))"/>
                    <xsl:variable name="kwic_left"
                        select="substring($prev_text, string-length($prev_text) - 56)"/>
                    <xsl:variable name="kwic_right" select="substring($following_text, 1, 56)"/>
                    <div class="text-kwic-grey d-flex justify-content-between align-items-end position-relative">
                        <div class="kwic-wrapper w-80 ff-century-old-style p-08">
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
        <xsl:param name="detail_view_textpage" select="false()"/>
        <xsl:param name="render-cited-range"/>
        <xsl:param name="final-dot" select="true()"/>
        <span>
            <xsl:choose>
                <xsl:when test="@sortKey = 'N._N.' and not($detail_view_textpage)">
                    <xsl:value-of select="'N. N.'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="tei:author"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="tei:author or (@sortKey = 'N._N.' and not($detail_view_textpage))">
                <xsl:value-of select="': '"/>
            </xsl:if>
            <xsl:variable name="citation">
                <xsl:apply-templates select="tei:title[not(@level = 's')]">
                    <xsl:with-param name="from_cited_range" select="boolean(normalize-space($render-cited-range))"/>
                </xsl:apply-templates>
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
                <xsl:apply-templates select="tei:date" mode="info_view"/>
                <xsl:if test="descendant::tei:title[@level = 's']">
                    <xsl:apply-templates select="descendant::tei:title[@level = 's']"/>
                </xsl:if>
                <xsl:apply-templates select="tei:biblScope"/>
            </xsl:variable>
            <xsl:variable name="cited-range">
                <xsl:if test="normalize-space($render-cited-range)">
                    <xsl:choose>
                    <xsl:when test="tei:biblScope">
                        <xsl:if test="not(tei:biblScope/text() = $render-cited-range)">
                        <xsl:value-of select="', hier '||$render-cited-range" />
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="', '||$render-cited-range" />
                    </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                </xsl:variable>
                <xsl:variable name="full-citation">
                <xsl:copy-of select="$citation" />
                <xsl:copy-of select="$cited-range" />
                </xsl:variable>
                <xsl:copy-of select="$full-citation" />
                <xsl:if test="not(ends-with(normalize-space($full-citation),'.')) and $final-dot">
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
        <xsl:if test="preceding-sibling::tei:title and not(@type = 'subtitle')">
            <xsl:text> In: </xsl:text>
        </xsl:if>
        <i>    
            <xsl:value-of select="normalize-space(.)"/>
        </i>
        <xsl:if test="following-sibling::tei:title[not(@type='short')]">
            <xsl:value-of select="'. '"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:title[@type = 'short']"/>
    <xsl:template match="tei:title[@level = 'j']" mode="short">
        <i><xsl:value-of select="."/></i>
    </xsl:template>
    <xsl:template match="tei:title[@level = ('a', 'm')][text()]">
        <xsl:param name="from_cited_range" select="false()" />
        <span>
            <xsl:if test="@level = 'm' and preceding-sibling::tei:title[@level = 'a']">
            <xsl:value-of select="'In: '" />
            <xsl:apply-templates
                select="
                                if (preceding-sibling::tei:author[. = 'Hanns Heinz Ewers']) then
                                    preceding-sibling::tei:author[1]
                                else
                                    preceding-sibling::tei:author">
                <xsl:with-param name="initials_only"
                select="preceding-sibling::tei:author/text() = $initials_only_names" />
                <xsl:with-param name="skip_role" select="true()" as="xs:boolean" />
            </xsl:apply-templates>
            <xsl:value-of select="': '" />
            </xsl:if>
            <xsl:value-of select="normalize-space(.)" />
            <xsl:choose>
            <!-- Die Bibel - special case -->
            <xsl:when test="ancestor::tei:bibl[@xml:id ='DWbibl00192']">
            </xsl:when>
            <xsl:when test="not(matches(., '(\p{Pf}|\p{Po}|\.\p{Pi})$'))">
                <xsl:text>.</xsl:text>
            </xsl:when>
            </xsl:choose>
            <xsl:if test="following-sibling::tei:title[not(@type='short')]">
            <xsl:text> </xsl:text>
            </xsl:if>
        </span>
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
    <xsl:template match="tei:date[not(@from)][not(@to)]" mode="info_view">
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
    <xsl:template match="@corresp" mode="detail_view_reg">
        <div class="pb-1 border-bottom border-light-grey">
            <span>Scan </span>
            <span><xsl:apply-templates select="./ancestor::tei:bibl" mode="short"/></span>
        </div>
    </xsl:template>
    <xsl:template match="tei:citedRange" mode="short_info">
        <xsl:param name="quotetype"/>
        <span><xsl:value-of select="$quotetype"/></span>
        <xsl:apply-templates select="./ancestor::tei:bibl" mode="short_info">
        </xsl:apply-templates>
        <xsl:if test="preceding-sibling::tei:biblScope">
            <span><xsl:value-of select="', '||data(preceding-sibling::tei:biblScope)"/></span>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:note[@type='context']" mode="detail_view_reg">
    <details class="pt-1 pb-1 border-bottom border-light-grey">
        <summary class="d-flex align-items-baseline">Textausschnitt <span class="ps-2">
            <xsl:apply-templates select="./ancestor::tei:bibl" mode="short" />
        </span></summary>
        <div class="ff-century-old-style pt-1_5 px-1_5 pb-1">
        <xsl:apply-templates />
        </div>
    </details>
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
<xsl:template name="ext_links">
    <xsl:param name="node_id" as="xs:string"/>
    <xsl:variable name="ref_node" select="doc('../../data/indices/Register.xml')//(tei:bibl|tei:citedRange)[@xml:id=$node_id]"/>
    <xsl:variable name="bibl_id"
        select="if ($ref_node/name() = 'citedRange') then ancestor::tei:bibl/@xml:id else $node_id"/>
        <xsl:if test="$ref_node/tei:ref[@type='int']">
            <xsl:call-template name="ext_links">
                <xsl:with-param name="node_id" select="$ref_node/tei:ref[@type='int']/replace(@target,'#','')"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$ref_node[tei:ref[@type='ext']]">
            <xsl:for-each select="$ref_node//tei:ref[@type='ext']">
                <xsl:variable name="ext_link" select="current()"/>
                <xsl:variable name="linktext">
                    <xsl:apply-templates select="current()/ancestor-or-self::tei:bibl" mode="short"/>
                </xsl:variable>
                <xsl:variable name="linklabel">
                    <xsl:choose>
                        <xsl:when test="$ext_link/@subtype = 'specific'">
                            <xsl:text>Link</xsl:text>
                        </xsl:when>
                        <xsl:when test="$ext_link/@subtype = 'example'">
                            <xsl:text>Link (exempl.)</xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:variable>
                <li class="py-1 border-bottom border-light-grey">
                    <span>
                        <xsl:value-of select="$linklabel"/>
                    </span>
                    <a class="ps-2 text-decoration-none text-dark-grey" href="{$ext_link/@target}" target="_blank">
                        <xsl:copy-of select="$linktext"/>
                        <svg class="ms-2 align-baseline" width="5" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                            <path style="fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;" class="b" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path>
                        </svg>
                    </a>
                </li>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="text_excerpts">
    <xsl:param name="node_id" as="xs:string"/>
        <xsl:variable name="ref_node" select="doc('../../data/indices/Register.xml')//(tei:bibl|tei:citedRange)[@xml:id=$node_id]"/>
        <xsl:variable name="bibl_id"
            select="if ($ref_node/name() = 'citedRange') then ancestor::tei:bibl/@xml:id else $node_id"/>
        <xsl:if test="$ref_node/tei:ref[@type='int']">
            <xsl:call-template name="text_excerpts">
                <xsl:with-param name="node_id" select="$ref_node/tei:ref[@type='int']/replace(@target,'#','')"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$ref_node[tei:note[@type='context']]">
            <li><details class="pt-1 pb-1 border-bottom border-light-grey">
                <summary class="d-flex align-items-baseline"><span>Textausschnitt</span><span class="ps-2">
                    <xsl:apply-templates select="$ref_node/ancestor::tei:bibl" mode="short" />
                </span></summary>
                <div class="ff-century-old-style pt-1_5 px-1_5 pb-1">
                    <xsl:apply-templates select="$ref_node/tei:note[@type='context']" mode="excerpt"/>
                </div>
            </details></li>
        </xsl:if>
    </xsl:template>
    <xsl:template name="scans">
        <xsl:param name="node_id" as="xs:string"/>
        <xsl:variable name="ref_node" select="doc('../../data/indices/Register.xml')//(tei:bibl|tei:citedRange)[@xml:id=$node_id]"/>
        <xsl:if test="$ref_node/tei:ref[@type='int']">
            <xsl:call-template name="scans">
                <xsl:with-param name="node_id" select="$ref_node/tei:ref[@type='int']/replace(@target,'#','')"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$ref_node/@corresp">
            <xsl:variable name="scan_index_item"  select="map:get($scan_index, $ref_node/@xml:id)"/>
            <li><details class="py-1 border-bottom border-light-grey">
                <summary class="d-flex align-items-baseline">
                    <span>Scan</span> 
                    <span class="ps-2">
                        <xsl:apply-templates select="$ref_node/ancestor-or-self::tei:bibl" mode="short" />
                    </span>
                </summary>
                <wpn-scans id="{'scans_'||$ref_node/@xml:id}" class="d-block vh-50">
                    <xsl:attribute name="facs" select="serialize($scan_index_item, map {'method': 'json'})"/>
                </wpn-scans>
                <xsl:if test="$scan_index_item?*[1]?note_short">
                    <div class="fs-7 mt-3 text-end"><xsl:value-of select="'(Bildquelle: '||$scan_index_item?*[1]?note_short||')'"/></div>
                </xsl:if>
            </details></li>
         </xsl:if>
    </xsl:template>
    <xsl:template name="link_to_register">
        <xsl:param name="node_id" as="xs:string"/>
        <xsl:variable name="ref_node" select="doc('../../data/indices/Register.xml')//(tei:bibl|tei:citedRange)[@xml:id=$node_id]"/>
        <xsl:variable name="bibl_id"
            select="if ($ref_node/name() = 'citedRange') then $ref_node/ancestor::tei:bibl/@xml:id else $node_id"/>
        
        <xsl:if test="$ref_node/tei:ref[@type='int']">
            <xsl:call-template name="link_to_register">
                <xsl:with-param name="node_id" select="$ref_node/tei:ref[@type='int']/replace(@target,'#','')"/>
            </xsl:call-template>
        </xsl:if>
        <li class="py-1 border-bottom border-light-grey">
            <span>Register</span>
            <a class="text-decoration-none text-dark-grey ps-2"
                href="{'register_intertexte.html#'||$bibl_id}" target="_blank">
                <xsl:apply-templates select="$ref_node/ancestor-or-self::tei:bibl" mode="short"/>
                
                <svg class="ms-2 align-baseline" width="5" height="10"
                    xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                    <path style="fill: none; stroke: #666; stroke-linejoin: round;
                            stroke-miterlimit: 10; stroke-width: 1.5px;" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"/>
                </svg>
            </a>
        </li>
    </xsl:template>
</xsl:stylesheet>
