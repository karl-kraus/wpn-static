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
                                <a role="button" class="btn btn-outline-black-grey" href="motti.html">Zum Text</a>
                            </section>
                        </xsl:if>
                        <xsl:if test="tokenize(base-uri(),'/')[last()] = 'topographical.xml'">
                            <section class="my-5_5">
                                <a role="button" class="btn btn-outline-black-grey" href="idPb0001.html">Zum Text</a>
                            </section>
                        </xsl:if>
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
         <div id="legende-pb" class="min-h-100 min-vh-100">
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
        <div><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="tei:row">
        <div class="d-flex flex-row {if (not(following-sibling::tei:row)) then 'mb-2' else ()}"><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="tei:cell">
        <div class="{if (count(preceding-sibling::tei:cell) = 0) then 'w-30' else 'w-70'}"><xsl:apply-templates/></div>
    </xsl:template>   
</xsl:stylesheet>
