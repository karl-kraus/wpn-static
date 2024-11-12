<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
     <xsl:import href="./partials/scripts.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Volltextsuche'"/>
        <html  class="h-100" lang="{$site_language}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                    <main>
                        <div class="container">
                            <h1>
                                <xsl:value-of select="$doc_title"/>
                            </h1>
                            <div id="searchbox" class="my-2 mx-auto"></div>
                            <div class="d-flex gap-2 flex-wrap">
                                <div id="pagination" class="align-self-center"></div>
                                <div class="text-center align-self-center" id="stats-container"></div>
                            </div>
                            <div id="hits"></div>
                        </div>
                    </main>
                    <xsl:call-template name="html_footer"/>
                    <script src="js/vendor/typesense/typesense-instantsearch-adapter.min.js" type="text/javascript"></script>
                    <script src="js/vendor/instantsearch/instantsearch.production.min.js" type="text/javascript"></script>
                    <xsl:call-template name="scripts"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>