<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/scripts.xsl"/>
    <xsl:import href="./partials/scripts.xsl"/>
    <xsl:import href="./editions_typo.xsl"/>
    <xsl:import href="./partials/typo-del.xsl"/>
    <xsl:import href="./partials/typo-add.xsl"/>
    


    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:title[@type='main'][1]/text()"/>
        </xsl:variable>
        <html class="h-100" lang="{$site_language}">
    
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            
            <body class="d-flex flex-column h-100">
            <xsl:call-template name="nav_bar"/>
                <main class="text-black-grey lh-1625 ls-1 mt-18">
                    <div class="container pt-1">                        
                        <h1><xsl:value-of select="$doc_title"/></h1>
                        <xsl:if test="tokenize(base-uri(),'/')[last()] = 'annotierte_lesefassung.xml'">
                            <section class="my-5_5">
                                <a role="button" class="btn btn-outline-black-grey" href="motto.html">Zum Text der Lesefassung</a>
                            </section>
                        </xsl:if>
                        <xsl:if test="tokenize(base-uri(),'/')[last()] = 'visualisierungen.xml'">
                            <div class="card rounded-0 h-100 position-relative">
                                <span class="wpn-card-badge">NEU</span>
                                <div class="card-body border-bottom signet pt-1_5 ps-3 pb-3">
                                    <h3 class="card-title mt-1"><a href="vis_DW.html" class="stretched-link text-decoration-none text-blacker-grey">Visualisierung Textträger der Dritten Walpurgisnacht</a></h3>
                                </div>
                                <img src="images/card_tfragment2.png" class="d-block" alt=""/>
                            </div>
                            <div class="card rounded-0 h-100 position-relative">
                                <span class="wpn-card-badge">NEU</span>
                                <div class="card-body border-bottom signet pt-1_5 ps-3 pb-3">
                                    <h3 class="card-title mt-1"><a href="vis_DW_F890.html" class="stretched-link text-decoration-none text-blacker-grey">Visualisierung Dritte Walpurgisnacht – Fackel Nr. 890–905</a></h3>
                                    <p class="card-subtitle text-black-grey">Typoskript „Wenn ich mich nun frage …“</p>
                                </div>
                                <img src="images/card_tfragment2.png" class="d-block" alt=""/>
                            </div>
                            
                        </xsl:if>
                        <xsl:if test="tokenize(base-uri(),'/')[last()] = 'topographical.xml'">
                            <section class="my-5_5 position-relative wpn-card-slider">
                                <wpn-scroll-button scroll-direction="left" role="button" class="wpn-card-slider-btn wpn-card-slider-btn-left" aria-label="Zurück">&#8249;</wpn-scroll-button>
                                <div id="scroll-container" class="py-2 wpn-card-slider-track">
                                    <div class="wpn-card-slider-item">
                                        <div class="card rounded-0 h-100">
                                            <div class="card-body border-bottom signet pt-1_5 ps-3 pb-3">
                                                <h3 class="card-title mt-1"><a href="wit-DfeH-0001.html" class="stretched-link text-decoration-none text-blacker-grey">Df(eH)</a></h3>
                                                <p class="card-subtitle text-black-grey">Druckfahnen – ‚Jerusalemer Konvolut‘</p>
                                            </div>
                                            <img src="images/card_dfeh.png" class="d-block" alt=""/>
                                        </div>
                                    </div>
                                    <div class="wpn-card-slider-item">
                                        <div class="card rounded-0 h-100 position-relative">
                                            <span class="wpn-card-badge">NEU</span>
                                            <div class="card-body border-bottom signet pt-1_5 ps-3 pb-3">
                                                <h3 class="card-title mt-1"><a href="wit-TFragment2-0229r.html" class="stretched-link text-decoration-none text-blacker-grey">T<sup>Fragment 2</sup></a></h3>
                                                <p class="card-subtitle text-black-grey">Typoskript „Wenn ich mich nun frage …“</p>
                                            </div>
                                            <img src="images/card_tfragment2.png" class="d-block" alt=""/>
                                        </div>
                                    </div>
                                    <div class="wpn-card-slider-item">
                                        <div class="card rounded-0 h-100 position-relative">
                                            <span class="wpn-card-badge">NEU</span>
                                            <div class="card-body border-bottom signet pt-1_5 ps-3 pb-3">
                                                <h3 class="card-title mt-1"><a href="wit-HMotto-0001r.html" class="stretched-link text-decoration-none text-blacker-grey">H<sup>Motto</sup></a></h3>
                                                <p class="card-subtitle text-black-grey">Handschrift des Mottos</p>
                                            </div>
                                            <img src="images/card_hmotto.png" class="d-block" alt=""/>
                                        </div>
                                    </div>
                                    <div class="wpn-card-slider-item">
                                        <div class="card rounded-0 h-100 position-relative">
                                            <span class="wpn-card-badge">NEU</span>
                                            <div class="card-body border-bottom signet pt-1_5 ps-3 pb-3">
                                                <h3 class="card-title mt-1"><a href="wit-DfMotto-0001r.html" class="stretched-link text-decoration-none text-blacker-grey">Df<sup>Motto</sup></a></h3>
                                                <p class="card-subtitle text-black-grey">Druckfahnen des Mottos</p>
                                            </div>
                                            <img src="images/card_dfmotto.png" class="d-block" alt=""/>
                                        </div>
                                    </div>
                                    <div class="wpn-card-slider-item">
                                        <div class="card rounded-0 h-100 position-relative">
                                            <span class="wpn-card-badge">NEU</span>
                                            <div class="card-body border-bottom signet pt-1_5 ps-3 pb-3">
                                                <h3 class="card-title mt-1"><a href="wit-TParalipomenon-0034r.html" class="stretched-link text-decoration-none text-blacker-grey">T<sup>Paralipomenon</sup></a></h3>
                                                <p class="card-subtitle text-black-grey">Ausgeschiedenes Typoskript</p>
                                            </div>
                                            <img src="images/card_tparalipomenon.png" class="d-block" alt=""/>
                                        </div>
                                    </div>
                                </div>
                                <wpn-scroll-button scroll-direction="right" role="button" class="wpn-card-slider-btn wpn-card-slider-btn-right" aria-label="Weiter">&#8250;</wpn-scroll-button>
                            </section>
                        </xsl:if>
                        <!--  -->
                        <xsl:if test="tokenize(base-uri(),'/')[last()] = 'personen.xml'">
                            <section class="my-5_5">
                                <a role="button" class="btn btn-outline-black-grey" href="register_personen.html">Zum Personenregister</a>
                            </section>
                        </xsl:if>
                        <xsl:if test="tokenize(base-uri(),'/')[last()] = 'intertexte.xml'">
                            <section class="my-5_5">
                                <a role="button" class="btn btn-outline-black-grey" href="register_intertexte.html">Zum Register der Intertexte</a>
                            </section>
                        </xsl:if>
                        <xsl:if test="tokenize(base-uri(),'/')[last()] = 'ereignisse.xml'">
                            <section class="my-5_5">
                                <a role="button" class="btn btn-outline-black-grey" href="timeline.html">Zur Timeline</a>
                            </section>
                        </xsl:if>
                        <!--  -->
                        <xsl:apply-templates select=".//tei:body"></xsl:apply-templates>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="scripts"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:head">
        <h2 class="{if (@rend='larger_heading') then 'fs-meta-heading-1' else 'fs-meta-heading-2'}"><xsl:apply-templates/></h2>
    </xsl:template>
    <xsl:template match="tei:p">
        <p id="{generate-id()}" class="my-1 {if (@rend='indent') then ('ms-2_5') else ()} {if(@rend='rightAlign') then ('text-end') else ()}"><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{generate-id()}"><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="tei:lb">
    <br/>
    </xsl:template>
    <xsl:template match="tei:graphic">
        <img src="{@url}" alt="{./tei:desc}"></img>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <abbr title="unclear"><xsl:apply-templates/></abbr>
    </xsl:template>
    <xsl:template match="tei:del">
        <del><xsl:apply-templates/></del>
    </xsl:template>
    <xsl:template match="tei:emph">
        <em><xsl:apply-templates/></em>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='sup']">
        <sup style="{@style}"><xsl:apply-templates/></sup>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='sub']">
        <sub style="{@style}"><xsl:apply-templates/></sub>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='strong']">
        <span class="fw-bolder"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:note[@type='footnote']">
        <p class="ms-2_5 fs-8"><xsl:apply-templates/></p>
    </xsl:template>
     <xsl:template match="tei:ref">
        <a class="text-primary text-decoration-none ff-ubuntu" href="{@target}"><xsl:apply-templates/></a>
    </xsl:template>
     <xsl:template match="tei:div[parent::tei:div[parent::tei:body]]">
        <div class="intro-text"><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="tei:div[parent::tei:div[parent::tei:body] and @type='legende']">
         <div id="legende-pb" class="min-h-100 intro-text">
                  <xsl:for-each select=".//tei:list">
                    <ul class="list-unstyled mt-2 p-0">
                    <xsl:for-each select="./tei:item">
                        <xsl:variable name="rendition" select="replace(@rendition, '#', '')"/>
                        <xsl:variable name="rend" select="@rend"/>
                        <xsl:variable name="change" select="replace(@change, '#', '')"/>
                        <li class="{if($change)then($change)else()} {if($rendition)then($rendition)else()} {if($rend)then($rend)else()}">
                            <xsl:apply-templates/>
                        </li>
                    </xsl:for-each>
                    </ul>
                  </xsl:for-each>
            </div>
    </xsl:template>
    <xsl:template match="tei:div[parent::tei:body]">
    <xsl:variable name="id" select="'wrapper'||count(preceding::tei:div[parent::tei:body])"/>
        <section class="mb-5_5 position-relative" id="{$id}"><xsl:apply-templates/>
        <xsl:if test="not(@rend='showall')">
            <wpn-toggle-text-button role="button" target-element="{$id}" toggle-class="show-all" toggle-text="Weniger lesen" class="btn btn-link text-decoration-none text-blacker-grey border-blacker-grey border-start-0 border-end-0 border-top-0 border-bottom-1 rounded-0 px-0 pb-05 position-absolute end-n05 bottom-0 bg-white">Mehr lesen</wpn-toggle-text-button>
        </xsl:if>
        </section>
    </xsl:template>     
    <xsl:template match="tei:table">
        <div class="intro-text"><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="tei:row">
        <div class="d-flex flex-row {if (not(following-sibling::tei:row)) then 'mb-2' else ()}"><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="tei:cell">
        <div class="{if (count(preceding-sibling::tei:cell) = 0) then 'w-30' else 'w-70'}"><xsl:apply-templates/></div>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend='alert']">
        <span class="warning"><xsl:apply-templates/></span>
    </xsl:template>
    
</xsl:stylesheet>
