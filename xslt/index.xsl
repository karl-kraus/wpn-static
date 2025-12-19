<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/scripts.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select='"WPN Static-Site"'/>
        </xsl:variable>

    
        <html lang="{$site_language}">
    
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>            
            <body class="d-flex flex-column overflow-scroll" id="home">
                <xsl:call-template name="nav_bar">
                    <xsl:with-param name="logo_small" select="false()"/>
                    <xsl:with-param name="container" select="'container p-md-0'"/>
                </xsl:call-template>
                <main class="flex-shrink-0 pt-1 lh-1_625 text-black-grey mb-5">
                    <section class="container p-md-0">
                        <h1 class="mb-2"><xsl:value-of select="$project_title"/></h1>
                        <div class="mt-2">
                            <xsl:apply-templates select="//tei:body//tei:p"/>
                        </div>
                        <a role="button" href="projekt.html" class="btn btn-outline-black-grey">Über das Projekt</a>
                    </section>
                    <hr class="my-3"/>
                    <section class="container p-0">
                        <div class="row py-3 align-items-center">   
                            <div class="justify-content-stretch col-4 p-md-2_5 col-md-4">
                                <div class="card rounded-0">
                                    <div class="card-body border-bottom signet pt-1_5 ps-3 pb-3">
                                        <h3 class="card-title mt-1"><a href="annotierte_lesefassung.html" class="stretched-link text-decoration-none text-blacker-grey">Annotierte Lesefassung</a></h3>
                                        <p class="card-subtitle text-black-grey">Dritte Walpurgisnacht</p>
                                    </div>
                                    <img src="images/card_annotierte_lesefassung.png" class="d-block" alt=""/>
                                </div>
                            </div>
                            <div class="justify-content-stretch col-4 p-md-2_5 col-md-4">
                                <div class="card rounded-0">
                                    <div class="card-body border-bottom signet pt-1_5 ps-3 pb-3">
                                        <h3 class="card-title mt-1"><a href="topographical.html" class="stretched-link text-decoration-none text-blacker-grey">Topographische Umschrift</a></h3>
                                        <p class="card-subtitle text-black-grey">Dritte Walpurgisnacht</p>
                                    </div>
                                    <img src="images/card_topographical.png" class="d-block" alt=""/>
                                </div>
                            </div>
                            <div class="justify-content-stretch col-4 p-md-2_5 col-md-4">
                                <div class="card rounded-0">
                                    <div class="card-body border-bottom signet pt-1_5 ps-3 pb-3">
                                        <h3 class="card-title mt-1"><a href="kommentar.html" class="stretched-link text-decoration-none text-blacker-grey">Kommentar</a></h3>
                                        <p class="card-subtitle text-black-grey">Stellenkommentar und Zeitleiste</p>
                                    </div>
                                    <img src="images/card_kommentar.png" class="d-block" alt=""/>
                                </div>
                            </div>
                            <div class="justify-content-stretch col-4 p-md-2_5 col-md-4">
                                <div class="card rounded-0">
                                    <div class="card-body border-bottom signet pt-1_5 ps-3 pb-3">
                                        <h3 class="card-title mt-1"><a href="notizen.html" class="stretched-link text-decoration-none text-blacker-grey">Notizen</a></h3>
                                        <p class="card-subtitle text-black-grey">Dritte Walpurgisnacht</p>
                                    </div>
                                    <img src="images/card_notizen.png" class="d-block" alt=""/>
                                </div>
                            </div>
                            <div class="justify-content-stretch col-4 p-md-2_5 col-md-4">
                                <div class="card rounded-0">
                                    <div class="card-body border-bottom signet pt-1_5 ps-3 pb-3">
                                        <h3 class="card-title mt-1"><a href="register.html" class="stretched-link text-decoration-none text-blacker-grey">Register</a></h3>
                                        <p class="card-subtitle text-black-grey">Personen und Intertexte</p>
                                    </div>
                                    <img src="images/card_register.png" class="d-block" alt=""/>
                                </div>
                            </div>
                        </div>
                    </section>
                    <hr class="my-3"/>
                     <section class="container p-0">
                        <div class="row mb-2">
                            <div class="col">
                                <p>Ein Projekt der</p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col">
                                <div class="card border-0 align-items-start">
                                    <img height="100" src="images/partner-logos/logo-oeaw.svg" alt="Österreichische Akademie der Wissenschaften"/>
                                    <div class="card-body p-0 pt-5">
                                        <p class="fs-8_75"><a  href="https://www.oeaw.ac.at/" target="_blank" rel="noopener noreferrer" alt="Österreichische Akademie der Wissenschaften" class="stretched-link text-decoration-none text-blacker-grey">Österreichische Akademie der Wissenschaften</a></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col">
                                <div class="card border-0 align-items-start">
                                    <img height="100" src="images/partner-logos/logo-acdh-ch.svg" alt="Austrian Centre for Digital Humanities and Cultural Heritage"/>
                                    <div class="card-body p-0  pt-5">
                                        <p class="p-0 fs-8_75"><a  href="https://www.oeaw.ac.at/acdh/" target="_blank" rel="noopener noreferrer" alt="Austrian Centre for Digital Humanities and Cultural Heritage" class="stretched-link text-decoration-none text-blacker-grey">Austrian Centre for Digital Humanities and Cultural Heritage</a></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col">
                                <div class="card border-0 align-items-start">
                                    <img height="50" src="images/partner-logos/logo-ace.svg" alt="ACE"/>
                                    <div class="card-body p-0 pt-10">
                                        <p class="p-0 fs-8_75">Austrian Corpora and Editions</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col">
                                <div class="card border-0 align-items-start">
                                    <img height="100" src="images/partner-logos/logo-acdh-ch.svg"  alt="Austrian Centre for Digital Humanities and Cultural Heritage"/>
                                    <div class="card-body p-0  pt-5">
                                        <p class="p-0 fs-8_75"><a  href="https://www.oeaw.ac.at/acdh/research-units/literarytextual-studies" target="_blank" rel="noopener noreferrer" alt="Literatur- &amp; Textwissenschaft" class="stretched-link text-decoration-none text-blacker-grey">Literary&amp;Textual Studies<br/>Austrian Centre for Digital Humanities and Cultural Heritage<br/>Austrian Academy of Sciences</a></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-2 mt-5">
                            <p>Unser Dank für die Kooperation gilt</p>
                        </div>
                         <div class="row">
                            <div class="col-md-4">
                                <div class="card border-0 align-items-start">
                                    <a href="https://www.wien.gv.at/kultur/abteilung/" title="Kulturabteilung der Stadt Wien" target="_blank" rel="noopener noreferrer"><img height="70" src="images/partner-logos/Wien-Kultur-Logo.png" alt="Logo Wien Kultur"/></a>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card border-0 align-items-start">
                                    <a href="https://www.wienbibliothek.at/" title="Wienbibliothek im Rathaus" target="_blank" rel="noopener noreferrer"><img height="70" src="images/partner-logos/Wienbibliothek-Logo.png" alt="Logo Wienbibliothek"/></a>
                                </div>
                            </div>
                        </div>
                     </section>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="scripts"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}"><xsl:apply-templates/></h2>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='alert']">
        <span class="warning"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p id="{generate-id()}"><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul id="{generate-id()}"><xsl:apply-templates/></ul>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <li id="{generate-id()}"><xsl:apply-templates/></li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
       <xsl:template match="tei:emph">
        <em><xsl:apply-templates/></em>
    </xsl:template>
</xsl:stylesheet>
