<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at" 
    version="2.0" exclude-result-prefixes="xsl tei xs wpn">
    
    <xsl:template match="tei:seg" mode="detail_view">
      <!--<xsl:result-document href="{@xml:id||'.html'}" method="html">-->
        <div class="d-none p-1 ps-0 pt-0 overflow-visible ls-2" id="{'details_'||@xml:id}">   
            <div class="seg_signet_background my-0 mw-100 top-18 px-2 ps-3 pt-2">
                <div class="border-0 d-flex flex-column">
                    <div class="d-flex justify-content-between">
                        <h2 class="fs-8_75 text-black-grey fw-normal">Registereintrag</h2>
                        <button class="border-0 bg-transparent">
                            <svg class="align-top" width="10" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 7.778 7.778"><defs><style>.a{fill:none;stroke:#d8d8d8;stroke-width:2px;}</style></defs><g transform="translate(0.707 0.707)"><line class="a" x2="9" transform="translate(0 0) rotate(45)"></line><line class="a" x2="9" transform="translate(0 6.364) rotate(-45)"></line></g></svg>
                        </button>
                    </div>
                    <div class="fs-6 text-dark-grey p-0">
                        <div>
                            <xsl:apply-templates select="."/>
                        </div>
                        <xsl:apply-templates select="." mode="kwic"/>
                    </div>
                </div>
            </div>
        </div>
<!--</xsl:result-document>-->
    </xsl:template>
    <xsl:template match="tei:seg" mode="kwic">
    <div>
         <details class="pb-1 mt-1 border-bottom border-light-grey">
            <summary class="d-flex align-items-baseline">Zum Text</summary>
            <div id="{'kwics_'||@xml:id}" class="ff-century-old-style">
                <xsl:for-each select="descendant::tei:ref[@type='comment']">
                    <xsl:variable name="kwic_hit" select="collection('../../data/merged?select=*.html')//span[@id=current()/@xml:id]"/>
                    <xsl:variable name="prev_text" select="string($kwic_hit/string-join(preceding::text()))"/>
                    <xsl:variable name="following_text" select="string($kwic_hit/string-join(following::text()))"/>
                    <xsl:variable name="kwic_left" select="substring($prev_text, string-length($prev_text) - 78)"/>
                    <xsl:variable name="kwic_right" select="substring($following_text, 1, 78)"/>
                    <div class="text-kwic-grey d-flex justify-content-between">
                        <div class="kwic-wrapper">
                            <xsl:if test="string-length($kwic_left) > 0">
                                <span><xsl:copy-of select="'...'||$kwic_left"/></span>
                            </xsl:if>
                            <span><xsl:copy-of select="$kwic_hit"/></span>
                            <xsl:if test="string-length($kwic_right) > 0">
                                <span><xsl:copy-of select="$kwic_right||'...'"/></span>
                            </xsl:if>
                        </div>
                        <div>
                            <p class="ff-ubuntu text-light-grey">
                                <xsl:value-of select="$kwic_hit/ancestor::body/@data-label"/>
                            </p>
                        </div>
                    </div>
                </xsl:for-each>
            </div>
        </details>
    </div>
    </xsl:template>
    <xsl:template match="tei:seg" mode="list_view">
    <div  id="{@xml:id}" class="lh-1625">
         <a class="text-blacker-grey text-decoration-none fs-9" href="{'#'||@xml:id}">
                <b><xsl:apply-templates select="." mode="short"/></b>
         </a>
    </div>
    </xsl:template>
    <xsl:template match="tei:seg" mode="short">
        <xsl:apply-templates select="tei:label" mode="short"/>
    </xsl:template>
    <xsl:template match="tei:label" mode="short">
        <span><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg">
        <xsl:apply-templates select="tei:label"/>
        <xsl:apply-templates select="tei:note"/>
        <xsl:apply-templates select="tei:note" mode="list_sources"/>
        <xsl:if test="tei:ref[@type='ext']">
            <div>
                <details class="py-1 border-bottom border-light-grey">
                    <summary class="d-flex align-items-baseline">Links</summary>
                        <xsl:for-each select="tei:ref[@type='ext']">
                            <xsl:apply-templates select="current()"/>
                        </xsl:for-each>
                </details>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:label">
        <p class="fs-9 text-black-grey"><b><xsl:apply-templates/></b></p>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="tei:title">
        <i><xsl:value-of select="."/></i>
    </xsl:template>
    <xsl:template match="tei:note">
        <p class="text-justify fs-8_5 lh-0_86 my-1 text-black-grey"><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="tei:ref[@type='source']">
    <xsl:variable name="sources">
        <xsl:for-each select="tokenize(@target,' ')">
        <xsl:variable name="target_id" select="replace(current(),'#','')"/>
            <xsl:apply-templates select="doc('../../data/indices/SekLit_Kommentar.xml')//(tei:citedRange|tei:bibl)[@xml:id=$target_id]" mode="popover_content"/>
        </xsl:for-each>
    </xsl:variable>
     <a href="#" data-bs-toggle="popover" data-bs-content="{$sources}"  data-bs-placement="left" data-bs-trigger="hover" data-bs-custom-class="ff-ubuntu">
        <svg width="14" height="14" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 25"><g fill="none" stroke="#d8d8d8" stroke-width="1"><circle cx="12.5" cy="12.5" r="12.5" stroke="none"></circle><circle cx="12.5" cy="12.5" r="12" fill="none"></circle></g><g transform="translate(8.229 8.025)"><path d="M4253.114,129.086v-5.543h3.88" transform="translate(-4253.114 -123.543)" fill="none" stroke="#999" stroke-linejoin="round" stroke-width="1"></path><g transform="translate(2.5 4.5)"><line x2="6.041" fill="none" stroke="#999" stroke-width="1"></line><line x2="6.041" transform="translate(0 2.225)" fill="none" stroke="#999" stroke-width="1"></line><line x2="6.041" transform="translate(0 4.45)" fill="none" stroke="#999" stroke-width="1"></line></g></g></svg>
    </a>
    </xsl:template>
    <xsl:template match="tei:citedRange" mode="popover_content">
        <p><xsl:value-of select="preceding-sibling::tei:bibl[@type='short']"/><xsl:value-of select="', '||.||'.'"/></p>
    </xsl:template>
    <xsl:template match="tei:note" mode="list_sources">
    <div>
        <details class="pb-1 border-bottom border-light-grey">
            <summary class="d-flex align-items-baseline">Quellen</summary>
            <xsl:for-each select="tei:ref[@type='source']/tokenize(@target,' ')">
                <xsl:sort select="doc('../../data/indices/SekLit_Kommentar.xml')//(tei:citedRange|tei:bibl)[@xml:id=replace(current(),'#','')]/ancestor-or-self::tei:bibl/@sortKey"/>
                <xsl:variable name="target_id" select="replace(current(),'#','')"/>
                <xsl:apply-templates select="doc('../../data/indices/SekLit_Kommentar.xml')//(tei:citedRange|tei:bibl)[@xml:id=$target_id]" mode="list_sources"/>
            </xsl:for-each>
        </details>
    </div>
    </xsl:template>
    <xsl:template match="tei:citedRange" mode="list_sources">
        <p class="my-04 lh-0_86"><xsl:value-of select="ancestor::tei:bibl/text()"/><xsl:value-of select="', '||."/></p>
    </xsl:template>
     <xsl:template match="tei:ref[@type='ext']">
        <a class="d-block text-decoration-none text-dark-grey text-blacker-grey-hover" href="{@target}" target="_blank">
            <xsl:apply-templates/>
            <svg class="ms-2 align-baseline" width="5" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                <defs>
                    <style>.b{fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;}</style>
                </defs>
                <path class="b" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path>
            </svg>
        </a>
        
    </xsl:template>
    <xsl:template match="tei:seg" mode="short_info">
        <xsl:param name="ref_type"/>
            <span class="fw-bold">
                <xsl:value-of select="(if ($ref_type='comment') then 'Kommentar' else 'Glossar')||': '"/>
                <xsl:apply-templates select="tei:label" mode="comment"/>
            </span>
    </xsl:template>
    <xsl:template match="tei:event" mode="short_info">
    <span class="fw-bold"><xsl:text>Ereignis: </xsl:text><xsl:apply-templates select="tei:label" mode="comment"/></span>
    </xsl:template>
    <xsl:template match="tei:label" mode="comment">
    <xsl:apply-templates mode="comment"/>
    </xsl:template>
    <xsl:template match="tei:title" mode="comment">
    <i><xsl:apply-templates mode="comment"/></i>
    </xsl:template>
    <xsl:template match="text()" mode="comment">
    <xsl:value-of select="."/>
    </xsl:template>
</xsl:stylesheet>