<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:import href="nav-link.xsl"/>
    <xsl:template match="/" name="nav_bar">
        <xsl:param name="logo_small" as="xs:boolean" select="true()"/>
        <xsl:param name="include_searchbox" as="xs:boolean" select="false()"/>
        <xsl:param name="container" select="'container'"/>
        <wpn-header class="fixed-top bg-white pe-0">
            <nav id="primary_nav" class="navbar border-bottom {if ($logo_small = true()) then 'pt-05' else ()}">
                <div class="{$container}">
                    <a class="navbar-brand" href="index.html">
                        <!--<xsl:value-of select="$project_short_title"/>-->
                        <span class="visually-hidden">Karl Kraus 1933</span>
                        <svg xmlns="http://www.w3.org/2000/svg" id="logo" viewBox="0 0 123.47 106.97" width="{if ($logo_small) then 90 else 180}" aria-hidden="true" focusable="false">
                            <defs>
                                <style>.cls-1{fill:#4a4a49;}.cls-2{fill:#a21a17;}</style>
                            </defs>
                            <g id="Ebene_2" data-name="Ebene 2">
                                <g id="KARLKRAUS1933-EXPORT">
                                    <g id="LOGO-Karl-Kraus-1933_FARBE">
                                        <path class="cls-1" d="M21.24,49v9.32h2.18L29.17,49h6.6L28.42,60.93l8,12.71H29.49l-6.11-9.89H21.24v9.89H15.46V49Z"/>
                                        <path class="cls-1" d="M49.09,49a10.73,10.73,0,0,1,5.79,1.32c1.6,1,2.71,2.68,2.71,5.71,0,3.4-1.36,6-4.64,6.82,3.1.58,4,3.61,4.78,10.79H51.66c-.89-6.64-1.39-8.36-3.61-8.36H44.81v8.36H39V49ZM44.81,60.43h2.6c2.75,0,4.18-.61,4.18-3.72a2.88,2.88,0,0,0-.68-2.28,3,3,0,0,0-2.14-.5h-4Z"/>
                                        <path class="cls-1" d="M76.19,73.64,74.87,69H67.05l-1.32,4.68H59.84L67.59,49h6.93l7.74,24.64ZM71,54.82,68.3,64.35h5.36Z"/>
                                        <path class="cls-1" d="M89.69,49V64.85c0,2.65.22,4.22,3.89,4.22,3.5,0,3.82-1.43,3.82-4.22V49h5.79V64.78c0,2.32-.32,4.5-1.64,6.18s-4.07,3.11-8.18,3.11S87,72.89,85.66,71.32c-1.47-1.75-1.75-4.07-1.75-6.36V49Z"/>
                                        <path class="cls-1" d="M120.22,54.89A9.87,9.87,0,0,0,115,53.46c-1.75,0-2.89.47-2.89,2.4,0,3.75,11.32,1.53,11.32,10.46a7,7,0,0,1-3.11,6A11.58,11.58,0,0,1,114,74.07c-2.61,0-6.14-.65-8.14-2.47l2.85-4.25a9.85,9.85,0,0,0,5.86,1.82c1.68,0,3.07-.42,3.07-2.57,0-4.25-11.32-1.82-11.32-10.6a6.4,6.4,0,0,1,2.79-5.5,10.53,10.53,0,0,1,6.42-1.93c2.36,0,5.54.57,7.43,2.14Z"/>
                                        <path class="cls-1" d="M21.24,18.79v9.32h2.18l5.75-9.32h6.6L28.42,30.72l8,12.71H29.49l-6.11-9.89H21.24v9.89H15.46V18.79Z"/>
                                        <path class="cls-1" d="M54.16,43.43l-1.32-4.68H45L43.7,43.43H37.8l7.75-24.64h6.93l7.75,24.64ZM49,24.61l-2.68,9.54h5.35Z"/>
                                        <path class="cls-1" d="M72.87,18.79a10.63,10.63,0,0,1,5.78,1.33c1.61,1,2.72,2.67,2.72,5.71,0,3.39-1.36,6-4.64,6.82,3.1.57,4,3.6,4.78,10.78H75.44c-.89-6.64-1.39-8.35-3.61-8.35H68.59v8.35H62.8V18.79ZM68.59,30.22h2.6c2.75,0,4.18-.61,4.18-3.71a2.94,2.94,0,0,0-.68-2.29,3.07,3.07,0,0,0-2.14-.5h-4Z"/>
                                        <path class="cls-1" d="M91,18.79v19.5h8.46v5.14H85.24V18.79Z"/>
                                        <!-- dev:                                         
                                        <path class="cls-2" d="M111,33.6h-6.1v-10.1h6.1v1.2h-4.7v3.1h4v1.2h-4v3.5h4.7v1.2ZM117.1,33.6h-1.5l-3.7-9.7,1.3-.5,3.2,8.7,3.2-8.7,1.2.5-3.7,9.7ZM95.2,33.6v-10c.5,0,.9,0,1.3-.1.2,0,.4,0,.6,0,.3,0,.6,0,.9,0,.4,0,.7,0,1.1,0,.4,0,.7.1,1,.3,0,0,0,0,.1,0,.4.2.7.4,1.1.6.2.1.4.3.5.5.4.5.7,1,.9,1.6.2.5.3,1,.3,1.6,0,.1,0,.3,0,.4,0,.6,0,1.1-.2,1.7,0,.1,0,.2,0,.3-.2.6-.5,1.2-.9,1.6-.4.5-1,.9-1.6,1.1-.6.3-1.3.4-2.1.4,0,0-.1,0-.2,0-.2,0-.4,0-.6,0-.2,0-.4,0-.5,0,0,0-.2,0-.3,0-.4,0-.8,0-1.2-.1ZM96.5,24.7v7.8c.2,0,.4,0,.6,0,.2,0,.3,0,.5,0,0,0,.1,0,.2,0,.3,0,.6,0,.9,0,.5,0,.9-.2,1.2-.4.5-.3,1-.8,1.2-1.4.2-.4.3-.8.3-1.2,0-.3,0-.6,0-.9,0-.7-.1-1.3-.4-1.9-.3-.6-.7-1.1-1.2-1.5-.3-.2-.7-.4-1-.4-.3,0-.6-.1-.9-.1,0,0-.1,0-.2,0-.3,0-.5,0-.8,0-.2,0-.4,0-.6,0Z" vector-effect="non-scaling-stroke"/>
                                        -->
                                        <path class="cls-2" d="M19.28,86.21v19.44H17.72v-18H15.37V86.21Z"/>
                                        <path class="cls-2" d="M24.52,92.21A6.24,6.24,0,0,1,31,85.89a6.2,6.2,0,0,1,6.39,6.45c0,4.48-4.67,10.69-8.17,13.31H26.9a27.53,27.53,0,0,0,7.56-8.5,5.2,5.2,0,0,1-3.59,1.35A6.2,6.2,0,0,1,24.52,92.21Zm1.57,0A4.86,4.86,0,1,0,31,87.29,4.73,4.73,0,0,0,26.09,92.21Z"/>
                                        <path class="cls-2" d="M44.53,87.32a9.53,9.53,0,0,0-4.24,1.11V86.86a10.53,10.53,0,0,1,4.32-1c3.48,0,5.78,2,5.78,5a5,5,0,0,1-3.76,4.67,5.21,5.21,0,0,1,4.08,5.13c0,3-2.46,5.23-6.1,5.23a9.34,9.34,0,0,1-4.7-1.1V103.3a8.72,8.72,0,0,0,4.65,1.24c2.72,0,4.53-1.67,4.53-3.86,0-2.75-2.11-4.37-5.64-4.37H43V95h.73c2.86,0,5.08-1.62,5.08-4S47,87.32,44.53,87.32Z"/>
                                        <path class="cls-2" d="M58.43,87.32a9.53,9.53,0,0,0-4.23,1.11V86.86a10.48,10.48,0,0,1,4.31-1c3.49,0,5.78,2,5.78,5a5,5,0,0,1-3.75,4.67,5.21,5.21,0,0,1,4.07,5.13c0,3-2.45,5.23-6.1,5.23a9.3,9.3,0,0,1-4.69-1.1V103.3a8.68,8.68,0,0,0,4.64,1.24c2.73,0,4.53-1.67,4.53-3.86,0-2.75-2.1-4.37-5.64-4.37h-.48V95h.73c2.86,0,5.07-1.62,5.07-4S60.94,87.32,58.43,87.32Z"/>
                                        <path class="cls-2" d="M4,18.79H0v-14A4.84,4.84,0,0,1,4.83,0H15.45V4H4.83A.83.83,0,0,0,4,4.83Z"/>
                                    </g>
                                </g>
                            </g>
                        </svg>
                    </a>
                    <span class="d-flex align-items-center gap-2">
                        <xsl:if test="$include_searchbox">
                            <form method="get" action="suche.html?walpurgisnacht%5Bquery%5D" role="search">
                                <input type="text" name="walpurgisnacht[query]" class="rounded-0 form-control border-top-0 border-start-0 border-end-0 border-bottom"></input>
                            </form>
                        </xsl:if>
                        <a class="nav-link project-link pe-4 link-dark-grey text-primary-hover d-none d-md-inline" href="projekt.html">Über das Projekt</a>
                        <a class="nav-link project-link pe-4 link-dark-grey text-primary-hover d-none d-md-inline" href="edition.html">Zur Edition</a>
                        <button class="navbar-toggler d-inline-block border-0" type="button" data-bs-toggle="modal" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                            <!--<span class="navbar-toggler-icon"></span>-->
                            <svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" width="20" height="12" viewBox="0 0 20 12">
                                <defs>
                                    <style>.a{fill:none}</style>
                                </defs>
                                <g transform="translate(0 0.5)">
                                    <line class="a" x2="20"/>
                                    <line class="a" x2="20" transform="translate(0 5)"/>
                                    <line class="a" x2="20" transform="translate(0 10)"/>
                                </g>
                            </svg>
                        </button>
                    </span>
                    <div class="navbar start-0 bg-black-grey w-100 opacity-97 modal fade modal-xl mh-fit-content" data-bs-backdrop="false" tabindex="-1" id="navbarSupportedContent">
                        <div class="modal-dialog mw-100">
                            <div class="modal-content bg-transparent border-0">
                                <div class="modal-header text-end d-md-none border-0">
                                    <button type="button" class="btn-close btn-close btn-close-white" data-bs-dismiss="modal">
                                        <span class="visually-hidden">Navigation schließen</span>
                                    </button>  
                                </div>
                                <div class="container d-block">
                                    <div class="row">
                                        <div class="col-md-4">
                                        <span class="d-block navbar-title text-white border-bottom border-light-grey pb-1">Die Edition</span>
                                            <ul class="navbar-nav navbar-dark me-auto mb-2 mb-lg-0 pt-2">
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'edition.html'"/>
                                                        <xsl:with-param name="label" select="'Textgenese und Überlieferung'"/>
                                                        <xsl:with-param name="level" select="'level1'"/>
                                                    </xsl:call-template>
                                                </li>
                                                
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'projekt.html'"/>
                                                        <xsl:with-param name="label" select="'Über das Projekt'"/>
                                                        <xsl:with-param name="level" select="'level1'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'nutzungsbedingungen.html'"/>
                                                        <xsl:with-param name="label" select="'Nutzungsbedingungen'"/>
                                                        <xsl:with-param name="level" select="'level1'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'impressum.html'"/>
                                                        <xsl:with-param name="label" select="'Impressum'"/>
                                                        <xsl:with-param name="level" select="'level1'"/>
                                                    </xsl:call-template>
                                                </li>
                                            </ul>
                                        </div>
                                        <div class="col-md-4">
                                            <span class="d-block navbar-title text-white border-bottom border-light-grey pb-1">Dritte Walpurgisnacht</span>
                                            <ul class="navbar-nav navbar-dark me-auto mb-2 mb-lg-0 pt-2">
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'notizen.html'"/>
                                                        <xsl:with-param name="label" select="'Notizen zur Dritten Walpurgisnacht'"/>
                                                        <xsl:with-param name="level" select="'level1'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'notizen_konvolut_1.html'"/>
                                                        <xsl:with-param name="label" select="'Konvolut I'"/>
                                                        <xsl:with-param name="level" select="'level2 ps-2 fs-9'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'notizen_konvolut_2.html'"/>
                                                        <xsl:with-param name="label" select="'Konvolut II'"/>
                                                        <xsl:with-param name="level" select="'level2 ps-2 fs-9'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'annotierte_lesefassung.html'"/>
                                                        <xsl:with-param name="label" select="'Lesefassung'"/>
                                                        <xsl:with-param name="level" select="'level1'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'motti.html'"/>
                                                        <xsl:with-param name="label" select="'Zum Text der Dritten Walpurgisnacht'"/>
                                                        <xsl:with-param name="level" select="'level2 ps-2 fs-9'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'topographical.html'"/>
                                                        <xsl:with-param name="label" select="'Umschrift'"/>
                                                        <xsl:with-param name="level" select="'level1'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'idPb0001.html'"/>
                                                        <xsl:with-param name="label" select="'Das ‚Jerusalemer Konvolut‘'"/>
                                                        <xsl:with-param name="level" select="'level2 ps-2 fs-9'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <!-- <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'register.html'"/>
                                                        <xsl:with-param name="label" select="'Register'"/>
                                                    </xsl:call-template>
                                                </li>-->
                                                <!--<li class="nav-item">
                                                    <a class="nav-link" href="imprint.html">Textgenese</a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" href="imprint.html">Faksimile</a>
                                                </li>-->
                                            </ul>
                                        </div>
                                        <div class="col-md-4">
                                            <span class="d-block navbar-title text-white border-bottom border-light-grey pb-1">Kommentar</span>
                                            <ul class="navbar-nav navbar-dark me-auto mb-2 mb-lg-0 pt-2">
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'kommentar.html'"/>
                                                        <xsl:with-param name="label" select="'Stellenkommentar'"/>
                                                        <xsl:with-param name="level" select="'level1'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'register_kommentare.html'"/>
                                                        <xsl:with-param name="label" select="'Zum Register'"/>
                                                        <xsl:with-param name="level" select="'level2 ps-2 fs-9'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'personen.html'"/>
                                                        <xsl:with-param name="label" select="'Personen'"/>
                                                        <xsl:with-param name="level" select="'level1'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'register_personen.html'"/>
                                                        <xsl:with-param name="label" select="'Zum Register'"/>
                                                        <xsl:with-param name="level" select="'level2 ps-2 fs-9'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'intertexte.html'"/>
                                                        <xsl:with-param name="label" select="'Intertexte'"/>
                                                        <xsl:with-param name="level" select="'level1'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'register_intertexte.html'"/>
                                                        <xsl:with-param name="label" select="'Zum Register'"/>
                                                        <xsl:with-param name="level" select="'level2 ps-2 fs-9'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'ereignisse.html'"/>
                                                        <xsl:with-param name="label" select="'Ereignisse'"/>
                                                        <xsl:with-param name="level" select="'level1'"/>
                                                    </xsl:call-template>
                                                </li>
                                                <li class="nav-item">
                                                    <xsl:call-template name="nav-link">
                                                        <xsl:with-param name="href" select="'timeline.html'"/>
                                                        <xsl:with-param name="label" select="'Zur Timeline'"/>
                                                        <xsl:with-param name="level" select="'level2 ps-2 fs-9'"/>
                                                    </xsl:call-template>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
            <xsl:variable name="document" select="substring-before(tokenize(base-uri(),'/')[last()], '.xml')"/>
            <nav aria-label="breadcrumb" class="my-05">
                <div class="{$container}">
                    <ol class="breadcrumb">
                        <li aria-current="page">
                            <xsl:choose>
                                <xsl:when test="$document = 'index'">
                                    <xsl:attribute name="class">breadcrumb-item active</xsl:attribute>
                                    <xsl:text>Karl Kraus 1933: Dritte Walpurgisnacht</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="class">breadcrumb-item</xsl:attribute>
                                    <a href="index.html" class="link-dark-grey text-primary-hover">Karl Kraus 1933: Dritte Walpurgisnacht</a>
                                </xsl:otherwise>
                            </xsl:choose>
                        </li>
                        <xsl:if test="$document != 'index' 
                                    and $document != 'personindex_updated'
                                    and $document != 'commentindex_updated'
                                    and $document != 'eventindex_updated'
                                    and $document != 'biblindex_updated'
                                    and not(contains($document, 'motti')) 
                                    and not(contains($document, 'absatz')) 
                                    and not(contains($document, 'idPb'))">
                            <li class="breadcrumb-item active" aria-current="page">
                                <xsl:choose>
                                    <xsl:when test="$document = 'projekt'">Über das Projekt</xsl:when>
                                    <xsl:when test="$document = 'edition'">Zur Edition</xsl:when>
                                    <xsl:when test="$document = 'nutzungsbedingungen'">Nutzungsbedingungen</xsl:when>
                                    <xsl:when test="$document = 'impressum'">Impressum</xsl:when>
                                    <xsl:when test="$document = 'notizen'">Notizen</xsl:when>
                                    <xsl:when test="$document = 'annotierte_lesefassung'">Annotierte Lesefassung</xsl:when>
                                    <xsl:when test="$document = 'topographical'">Topographische Umschrift</xsl:when>
                                    <xsl:when test="$document = 'register'">Register</xsl:when>
                                    <xsl:when test="$document = 'kommentar'">Kommentar</xsl:when>
                                    <xsl:when test="$document = 'suche'">Suche</xsl:when>
                                    <xsl:otherwise>

                                    </xsl:otherwise>
                                </xsl:choose>
                            </li>
                        </xsl:if>
                        <xsl:if test="contains($document, 'motti') or contains($document, 'absatz')">
                            <li class="breadcrumb-item" aria-current="page"><a class="link-dark-grey text-primary-hover" href="annotierte_lesefassung.html">Annotierte Lesefassung</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Text</li>
                        </xsl:if>
                        <xsl:if test="contains($document, 'idPb')">
                            <li class="breadcrumb-item" aria-current="page"><a class="link-dark-grey text-primary-hover" href="topographical.html">Topographische Umschrift</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Text</li>
                        </xsl:if>
                        <xsl:if test="$document = 'personindex_updated'">
                            <li class="breadcrumb-item" aria-current="page"><a class="link-dark-grey text-primary-hover" href="register.html">Register</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Personen</li>
                        </xsl:if>  
                        <xsl:if test="$document = 'biblindex_updated'">
                            <li class="breadcrumb-item" aria-current="page"><a class="link-dark-grey text-primary-hover" href="register.html">Register</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Intertexte</li>
                        </xsl:if> 
                        <xsl:if test="$document = 'commentindex_updated'">
                            <li class="breadcrumb-item" aria-current="page"><a class="link-dark-grey text-primary-hover" href="kommentar.html">Kommentar</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Register der Stellenkommentare</li>
                        </xsl:if>  
                        <xsl:if test="$document = 'eventindex_updated'">
                            <li class="breadcrumb-item" aria-current="page"><a class="link-dark-grey text-primary-hover" href="kommentar.html">Kommentar</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Ereignisse</li>
                        </xsl:if>  
                    </ol>
                </div>
            </nav>
        </wpn-header>
    </xsl:template>
</xsl:stylesheet>
