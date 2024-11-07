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
    <xsl:import href="./partials/seg.xsl"/>
    <xsl:import href="./partials/event.xsl"/>
    <xsl:import href="./partials/scripts.xsl"/> 
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:title[@type = 'main'][1]/text()"/>
        </xsl:variable>
        <xsl:variable name="events">
            <xsl:copy-of select="//tei:event[@xml:id]"/>
        </xsl:variable>
        <html>
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
            </head>
            <body class="d-flex flex-column overflow-visible pe-0">
                    <xsl:call-template name="nav_bar">
                        <xsl:with-param name="container" select="'container-fluid px-5'"/>
                        <xsl:with-param name="logo_small" select="true()"/>
                    </xsl:call-template>
                    <xsl:variable name="event_categories" as="xs:string*">
                        <xsl:sequence select="//tei:body/tei:p/tei:listRef/tei:desc"/>
                    </xsl:variable>
                    <div class="wrapper">
                        <div class="d-flex flex-row">
                            <main class="text-black-grey ls-1 mb-4 w-75">
                                    <div>
                                        <div class="m-5 text-black-grey">
                                            <wpn-time-line class="d-block" id="timeline_container" data-selected-categories="{serialize(array {$event_categories},map {'method': 'json'})}"></wpn-time-line>
                                        </div>
                                    </div>
                            </main>
                            <aside class="w-25 border-start border-light-grey bg-primary bg-opacity-5 position-relative">
                                <div class="px-3">
                                    <h1 class="fs-meta-heading-2 py-2">Ereignisse filtern</h1>
                                    <ul class="list-unstyled">
                                        <xsl:for-each select="//tei:body/tei:p/tei:listRef">
                                            <li>
                                                <input type="checkbox" class="align-middle accent-primary timeline-helper" value="{current()/tei:desc/text()}" id="{current()/tei:desc/@xml:id}" name="{current()/tei:desc/@xml:id}" checked="true"/>
                                                <label for="{current()/tei:desc/@xml:id}" class="ps-05 fs-8_5"><xsl:value-of select="current()/tei:desc/text()"/></label>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </div>
                                <wpn-detail-view class="d-none position-absolute top-0 h-100 w-100 bg-white">
                                    <div class="d-block position-sticky">
                                        <xsl:apply-templates select="//tei:event" mode="detail_view">
                                            <xsl:with-param name="detail_view" select="true()" as="xs:boolean"/>
                                        </xsl:apply-templates>
                                    </div>
                                </wpn-detail-view>
                            </aside>
                        </div>
                    <xsl:call-template name="html_footer">
                        <xsl:with-param name="additional_clases" select="'z-1'"/>
                    </xsl:call-template>
                </div>
                    <script src="js/vendor/anychart/anychart-core.min.js" type="text/javascript"></script>
                    <script src="js/vendor/anychart/anychart-timeline.min.js" type="text/javascript"></script>
                    <script src="js/vendor/anychart/de-at.js" type="text/javascript"></script>
                    <xsl:call-template name="scripts"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
