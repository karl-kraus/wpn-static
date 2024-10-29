<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">

    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:mode on-no-match="deep-skip"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/bibl.xsl"/>
    <xsl:import href="./partials/scripts.xsl"/>
    <!-- alphabetic index  -->
    <xsl:variable name="index_letters"
        select="sort(distinct-values(//tei:term/@key))"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:title[@type = 'main'][1]/text()"/>
        </xsl:variable>
        <xsl:variable name="bibls">
            <xsl:copy-of select="//tei:bibl[@xml:id]"/>
        </xsl:variable>
        <html class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
            </head>
            <body class="d-flex flex-column h-100 overflow-visible pe-0">
                <xsl:call-template name="nav_bar">
                    <xsl:with-param name="container" select="'container-fluid px-5'"/>
                    <xsl:with-param name="logo_small" select="true()"/>
                </xsl:call-template>
                <div class="d-flex flex-row mb-n10">
                    <main class="text-black-grey ls-1 mt-15 mb-4 w-60">
                        <div>
                            <div class="m-5">
                                <h1>Register der Intertexte</h1>
                                <nav class="nav-tabs d-flex flex-row flex-wrap text-center mb-1 mt-5 lh-1_4" role="tablist">
                                    <xsl:for-each select="65 to 90">
                                        <xsl:variable name="letter"
                                            select="codepoints-to-string(current())"/>
                                        <a data-bs-toggle="tab" data-bs-target="{'#'|| $letter||'-pane'}"
                                            class="nav-link cursor-pointer text-blacker-grey-hover ff-ubuntu-500-hover w-7_5 {if ($letter = $index_letters) then () else 'text-light-grey pe-none'} {if ($letter = 'A') then 'active' else ()}">
                                            <xsl:value-of select="$letter"/>
                                        </a>
                                    </xsl:for-each>
                                </nav>
                                <div class="tab-content">
                                    <xsl:for-each select="$index_letters">
                                        <xsl:variable name="index-letter" select="current()"/>
                                        <div class="tab-pane {if ($index-letter = 'A') then 'active' else ()}"  id="{current()||'-pane'}">
                                        <xsl:for-each select="$bibls//tei:term[@key = $index-letter]">

                                        <xsl:sort select="
                                                        current() || '_' || (if (ancestor::tei:bibl/tei:title[@level = 'j']) then
                                                            (ancestor::tei:bibl/tei:title[@level = 'j'][1] || '_' || ancestor::tei:bibl/tei:title[@level = 'a'][1])
                                                        else
                                                            if (ancestor::tei:bibl/tei:title[@level = 'a']) then
                                                                ancestor::tei:bibl/tei:title[@level = 'a'][1]
                                                            else
                                                                ancestor::tei:bibl/tei:title[@level = 'm'][1])"
                                                />
                                        <xsl:sort select="ancestor::tei:bibl/tei:num"/>
                                        <xsl:apply-templates
                                                select="ancestor::tei:bibl" mode="list_view">
                                                
                                            </xsl:apply-templates>
                                        </xsl:for-each>
                                        </div>
                                    </xsl:for-each>
                                </div>
                            </div>
                        </div>
                    </main>
                    <aside class="w-40 border-start border-light-grey">
                        <wpn-detail-view class="d-block position-sticky">
                            <xsl:apply-templates select="//tei:bibl[@xml:id]" mode="detail_view">
                                <xsl:with-param name="detail_view" select="true()" as="xs:boolean"/>
                            </xsl:apply-templates>
                        </wpn-detail-view>
                    </aside>                    
                </div>
                <xsl:call-template name="html_footer"/>
                <script type="text/javascript" src="js/vendor/openseadragon/openseadragon.min.js"></script>
                <xsl:call-template name="scripts"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
