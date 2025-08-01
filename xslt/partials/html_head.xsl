<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:include href="./params.xsl"/>
    <xsl:include href="./styles.xsl"/>
    <xsl:template match="/" name="html_head">
        <xsl:param name="html_title" select="$project_short_title"></xsl:param>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-title" content="{$html_title}" />
        <meta name="msapplication-TileColor" content="#ffffff" />
        <meta name="msapplication-TileImage" content="{$project_logo}" />
    <!-- favicon -->
        <link rel="icon" href="images/favicons/favicon.ico" sizes="32x32"/>
        <link rel="icon" href="images/favicons/icon.svg" type="image/svg+xml"/>
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon.png" />
        <!-- <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-60x60.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-72x72.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-76x76.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-114x114.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-120x120.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-144x144.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-152x152.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-167x167.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-180x180.png" />
        <link rel="None" type="image/png" href="images/favicons/mstile-70x70.png" />
        <link rel="None" type="image/png" href="images/favicons/mstile-270x270.png" />
        <link rel="None" type="image/png" href="images/favicons/mstile-310x310.png" />
        <link rel="None" type="image/png" href="images/favicons/mstile-310x150.png" />
        <link rel="shortcut icon" type="image/png" href="images/favicons/favicon-196x196.png" /> -->
    <!-- favicon end -->
        <link rel="profile" href="http://gmpg.org/xfn/11"></link>
        <title><xsl:value-of select="$html_title"/></title>
        <xsl:call-template name="styles"/>
    </xsl:template>
</xsl:stylesheet>