<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">

    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="no"
        omit-xml-declaration="yes"/>
    <xsl:mode on-no-match="deep-skip"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/seg.xsl"/>
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/scripts.xsl"/>
    <xsl:variable name="index_letters"
        select="sort(distinct-values(//tei:term/@key))"/>
       
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:title[@type = 'main'][1]/text()"/>
        </xsl:variable>
        <xsl:variable name="comments">
            <xsl:copy-of select="//tei:seg[@xml:id]"/>
        </xsl:variable>
        <html class="h-100" lang="{$site_language}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
            </head>
            <body class="d-flex flex-column h-100 overflow-visible pe-0">
                <xsl:copy-of select="$index_letters"/>
                <!--<xsl:copy-of select="$quotes"/>-->
                    <xsl:call-template name="nav_bar">
                        <xsl:with-param name="container" select="'container-fluid px-5'"/>
                        <xsl:with-param name="logo_small" select="true()"/>
                    </xsl:call-template>
                                    <div class="d-flex flex-row mb-n10">
                    <main class="text-black-grey ls-1 mb-10 w-60">
                            <div>
                                <div class="m-5 text-black-grey">
                                    <h1>Register der Stellenkommentare</h1>
            
                                    <div class="mt-7">
                                        <xsl:for-each select="head(//tei:body//tei:p)//tei:listRef">
                                            <xsl:variable name="topic" select="current()"/>
                                            <xsl:variable name="topic_id" select="$topic/tei:desc/@xml:id"/>
                                            <div class="mt-2" id="topic_{$topic_id}">
                                            <p class="text-primary ff-ubuntu"><xsl:value-of select="$topic/tei:desc"/></p>
                                                <ul class="ps-0 mb-0 {if (count(current()//tei:ptr) > 4) then 'intro-text h-auto list-collapsable' else ()} {if ($topic_id = 'DWCtopic0004') then 'col-count-responsive' else ()}">
                                                    <xsl:for-each select="current()//tei:ptr">
                                                    <xsl:variable name="id" select="replace(@target,'#','')"/>
                                                    <xsl:apply-templates
                                                            select="//tei:seg[@xml:id = $id]" mode="list_view">
                                                            <xsl:with-param name="topic_id" select="$topic_id"/>
                                                        </xsl:apply-templates>
                                                    </xsl:for-each>
                                                </ul>
                                                <xsl:if test="count(current()//tei:ptr) > 4">
                                                    <wpn-toggle-text-button role="button" target-element="topic_{$topic_id}" toggle-class="show-all" toggle-text="Weniger lesen" class="btn btn-link text-decoration-none text-blacker-grey border-blacker-grey border-start-0 border-end-0 border-top-0 border-bottom-1 rounded-0 px-0 pb-05 bottom-0 bg-white">Mehr lesen</wpn-toggle-text-button>
                                                </xsl:if>
                                            </div>
                                        </xsl:for-each>
                                    </div>
                                </div>
                            </div>
                    </main>
                    <aside class="w-40 border-start border-light-grey">
                                <wpn-detail-view class="d-block position-sticky overflow-y-auto">
                                    <xsl:for-each select="//tei:seg[not(ancestor::tei:seg)]">
                                        <xsl:variable name="cur_seg" select="current()"/>
                                        <xsl:for-each select="tokenize(@corresp,' ')">    
                                            <xsl:apply-templates select="$cur_seg" mode="detail_view">
                                                <xsl:with-param name="detail_view" select="true()" as="xs:boolean"/>
                                                <xsl:with-param name="topic_id" select="replace(current(),'#','')"/>
                                            </xsl:apply-templates>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </wpn-detail-view>
                            </aside>
                            </div>
                    <xsl:call-template name="html_footer">
                        <xsl:with-param name="additional_clases" select="'z-1'"/>
                    </xsl:call-template>
                    <xsl:call-template name="scripts"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="text()">
    <xsl:value-of 
     select="translate(.,'&#xA;&#x9;','')"/>
  </xsl:template>
</xsl:stylesheet>
