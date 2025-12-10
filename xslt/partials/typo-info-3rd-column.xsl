<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">
    
    <xsl:template name="info-3rd-column">
        <xsl:variable name="doc_type" select="//tei:pb/@type" />
        
        <div id="infocolumn" class="grid-box-3 z-index-1">
            <div id="infocontent" class="bg-white px-0 overflow-y-scroll vh-100-nav">
                <div id="infocontent-header" class="row z-index-1 flex-row bg-white position-sticky top-nav text-center m-0 border border-light-grey" style="border-radius:0.25rem 0 0 0;">
                    <div style="max-height:55px;max-width:40px;" class="col p-0_25 border-end border-light-grey align-content-around m-visually-hidden">
                        <div id="infocontent-hide-btn" role="button" aria-controls="#infocontent" class="cursor-pointer p-1 active text-center mx-auto" title="Info-Spalte schließen">
                            <img id="infocontent-hide-icon" src="images/plus.svg" alt="Infospalte schließen"/>     
                            <span id="infocontent-hide-icon-hidden" class="mx-auto visually-hidden" style="stroke:grey;fill:grey;" title="Infospalte öffnen">
                                <svg width="18" height="18" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false"><g><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path></g></svg>
                            </span>
                        </div>
                    </div>
                    <div class="col p-0_25 border-end border-light-grey bg-primary align-content-around">
                        <div class="d-flex cursor-pointer text-center mx-auto">
                        <xsl:choose>
                            <xsl:when test="string-length($prev) > 0">
                                <a id="prevPageLink" class="mx-auto" style="stroke:white;fill:white;" href="{replace($prev, '.xml', '.html')}?view=all-columns" title="zu seite {replace($prev, '.xml', '.html')} gehen">
                                    <svg width="18" height="18" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false"><g><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path></g></svg>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="mx-auto" style="stroke:grey;fill:grey;" title="keine vorherige Seite">
                                    <svg width="18" height="18" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false"><g><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path></g></svg>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                        </div>
                    </div>
                    <div id="pagination-dropdown" class="col px-1 border-end border-light-grey bg-primary">
                        <div class="d-block cursor-pointer dropdown ff-ubuntu">
                            <xsl:variable name="currentPage" select="replace(replace(tokenize(base-uri(current()),'/')[last()], '.xml', ''), 'idPb', '')"/>
                            <xsl:variable name="currentPageString" select="if(contains($currentPage, '_') ) 
                                                                            then(xs:integer(replace( tokenize( $currentPage, '_' )[1], 'F', '' ) )||'/'||tokenize( $currentPage, '_' )[2] ) 
                                                                            else(xs:integer(replace($currentPage, 'F', '')))"/>
                            <button id="dropdownMenuButton1" class="d-contents cursor-pointer btn btn-secondary text-white fs-9_38 border-0 m-0" type="button" aria-controls="#pagination-pb" aria-expanded="false">
                                <span><xsl:text>Seite: </xsl:text></span><xsl:value-of select="$currentPageString"/>
                            </button>
                            <br/>
                            <xsl:variable name="pages" select="collection('../../data/editions?select=idPb*.xml')"/>
                            <label id="paginationLabel" class="cursor-pointer text-white fs-7 fw-light dropdown-toggle" for="dropdownMenuButton1">
                                <xsl:text>von </xsl:text><xsl:value-of select="count($pages[not(.//tei:pb[@type='nonWitness'])])"/>
                            </label>
                        </div>
                    </div>
                    <div class="col p-0_25 border-end border-light-grey bg-primary align-content-around">
                        <div class="d-flex cursor-pointer text-center mx-auto">
                        <xsl:choose>
                            <xsl:when test="string-length($next) > 0">
                                <a id="nextPageLink" class="mx-auto" style="stroke:white;fill:white;" href="{replace($next, '.xml', '.html')}?view=all-columns" title="zu seite {replace($next, '.xml', '.html')} gehen">
                                    <svg width="18" height="18" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false"><g><path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"></path></g></svg>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="mx-auto" style="stroke:grey;fill:grey;" title="keine nächste Seite">
                                    <svg width="18" height="18" viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false"><g><path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"></path></g></svg>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                        </div>
                    </div>
                    <div id="allcolumnBtn" role="button" class="active-view-icon col p-0_25 cursor-pointer border-end border-light-grey m-visually-hidden align-content-around">
                        <img src="images/icon-view-all.svg" alt="Synoptic View: Facsimile and Info Column" class="view-icon"/>
                    </div>
                    <div id="textcolumnBtn" role="button" class="col p-0_25 cursor-pointer border-end border-light-grey m-visually-hidden align-content-around">
                        <img src="images/icon-view-facs.svg" alt="Synoptic View: Facsimile, Text Columns and Info Column" class="view-icon"/>                    
                    </div>
                    <div id="facscolumnBtn" role="button" class="col p-0_25 cursor-pointer border-end border-light-grey m-visually-hidden align-content-around">
                        <img src="images/icon-view-text.svg" alt="Synoptic View: Text and Info Column" class="view-icon"/>
                    </div>
                    <div id="allcolumnRowBtn" role="button" class="col p-0_25 cursor-pointer border-end border-light-grey m-visually-hidden align-content-around">
                        <img src="images/icon-view-vertical.svg" alt="Synoptic View: Facsimile, Text Rows and Info Column" class="view-icon"/>
                    </div>
                    <div id="setMode" role="button" class="col p-0_25 cursor-pointer border-light-grey m-visually-hidden align-content-around">
                        <label class="cursor-pointer" style="font-size:7pt;">Highlighting<br/>[BETA]</label>
                    </div>
                </div>
                <div class="row flex-row m-0 mx-auto">
                    <div class="col p-0_25 position-sticky z-index-1 top-nav-2 cursor-pointer border-start border-bottom border-light-grey align-content-around" style="max-height:55px;max-width:38px;border-radius: 0 0 0 0.25rem;">
                        <div id="legende-btn" class="active text-center" title="Legende öffnen" type="button" aria-controls="#legende-pb" aria-expanded="false">
                            <img src="images/icon-quelle-bg.svg" alt="Legende"/>                    
                        </div>
                    </div>
                    <div id="infocontent-wrapper" class="col border-end border-bottom border-start border-light-grey p-0 m-0">
                        <div id="legende-pb" class="visually-hidden">
                            <xsl:variable name="pages" select="document('../../data/meta/topographical.xml')"/>
                            <div class="w-100 h-100 m-0 p-2">
                                <h5>Legende</h5>
                                  <xsl:for-each select="$pages//tei:div[@type='legende']//tei:list">
                                    <ul class="list-unstyled mt-2 p-0">
                                    <xsl:for-each select="./tei:item">
                                        <xsl:variable name="rendition" select="replace(@rendition, '#', '')"/>
                                        <xsl:variable name="rend" select="@rend"/>
                                        <xsl:variable name="change" select="replace(@change, '#', '')"/>
                                        <li class="{if($change)then($change)else()}{if($rendition)then($rendition)else()}{if($rend)then($rend)else()}">
                                            <xsl:apply-templates/>
                                        </li>
                                    </xsl:for-each>
                                    </ul>
                                  </xsl:for-each>
                            </div>
                        </div>
                        <div id="pagination-pb" class="visually-hidden bg-primary text-white">
                            <xsl:variable name="pages" select="collection('../../data/editions?select=idPb*.xml')"/>
                            <div id="pagination-grid" class="pagination-grid-5 w-100 h-100 text-center m-0 p-1">
                                <xsl:for-each select="$pages">
                                    <xsl:sort select=".//tei:pb/@xml:id[1]"/>
                                    <xsl:variable name="page" select="replace(replace(tokenize(base-uri(current()),'/')[last()], '.xml', ''), 'idPb', '')"/>
                                    <xsl:variable name="pageString" select="if(contains($page, '_'))then(xs:integer(replace(tokenize($page, '_')[1], 'F', ''))||'/'||tokenize($page, '_')[2])else(xs:integer(replace($page, 'F', '')))"/>
                                    <xsl:if test="not(.//tei:pb[@type='nonWitness'])">
                                        <a class="fs-9_38 text-white text-decoration-none d-block px-0 my-1 mx-0 py-0 text-center hover:bg-white hover:text-primary" href="{replace(tokenize(base-uri(current()),'/')[last()], '.xml', '.html')}?view=all-columns">
                                            <xsl:value-of select="$pageString"/>
                                        </a>
                                    </xsl:if>
                                </xsl:for-each>
                            </div>
                        </div>
                        <div id="infocontent-pb" class="min-h-100 min-vh-100">
                            <xsl:variable name="creation" select="//tei:creation"/>
                            <xsl:for-each select="//tei:TEI/tei:facsimile[@corresp='#DWkonJer']/tei:surface">
                                <xsl:variable name="text" select="../following-sibling::tei:text"/>
                                <xsl:variable name="convolute-id" select="replace(./parent::tei:facsimile/@corresp, '#', '')"/>
                                <xsl:variable name="corresp-id" select="replace(@corresp, '#', '')"/>
                                <div class="note m-2 {$corresp-id}">
                                    <!-- ########### -->
                                    <!-- 1 - GENERAL INFO, IDENTIFICATION -->
                                    <!-- ########### -->
                                    <h4 class="mt-2">
                                        <xsl:text>Jerusalemer Konvolut,</xsl:text><br/><xsl:text>fol. [</xsl:text><xsl:value-of select="@n"/><xsl:text>] recto.</xsl:text></h4>
                                    
                                    <h5 id="btn_general_info" class="mt-2 cursor-pointer text-dropdown-toggle" role="button" aria-expanded="false" aria-controls="#list_general_info">Standort, Signatur</h5>
                                    <div id="list_general_info" class="visually-hidden">
                                        <p>
                                            <xsl:value-of
                                                select="
                                                let $id := //tei:sourceDesc[@xml:id='DWkonJer']/tei:msDesc/tei:msIdentifier
                                                return concat(string-join((
                                                $id/tei:institution,
                                                $id/tei:collection,
                                                $id/tei:idno[@type='signature']
                                                ), ', '), '.')
                                                "/>
                                        </p>
                                        <xsl:for-each select="./tei:note[@type='pagination']">
                                            <p id="paragraph-block-{position()}" class="paragraph-block" data-link="fw-{replace(@corresp, '#', '')}">
                                                <xsl:variable name="corresp">
                                                    <xsl:value-of select="substring-after(@corresp, '#')"/>
                                                </xsl:variable>
                                                <xsl:text>Paginierung </xsl:text>
                                                <xsl:value-of select="./text()"/>
                                                <xsl:text> (</xsl:text>
                                                <xsl:value-of select="$creation//id(data($corresp))"/>
                                                <xsl:text>)</xsl:text>
                                            </p>
                                        </xsl:for-each>
                                        <p><xsl:value-of select="./tei:note[@type='stamp']/text()"/></p>
                                    </div>

                                    <!-- ########### -->
                                    <!-- 2 - CARRIER INFO -->
                                    <!-- ########### -->
                                    <h5 id="btn_carrier_info" class="mt-2 cursor-pointer text-dropdown-toggle" role="button" aria-expanded="false" aria-controls="#list_carrier_info">
                                        Textträger, Grundschicht,<br/>Digitalisat</h5>
                                    <div id="list_carrier_info" class="visually-hidden">
                                        <h6>Gehört zu:</h6>
                                        <xsl:for-each select="ancestor::tei:TEI/tei:teiHeader//tei:item[@xml:id=$corresp-id]/tei:p">
                                            <p><xsl:value-of select="./text()"/></p>
                                        </xsl:for-each>
                                        <xsl:if test="./tei:note[@type='state']">
                                            <h6>Anmerkung:</h6>
                                            <p><xsl:value-of select="./tei:note[@type='state']/text()"/></p>
                                        </xsl:if> 
                                    </div>
                                    
                                    
                                    <!-- ########### -->
                                    <!-- textblock 4 -->
                                    <!-- ########### -->
                                    <xsl:if test="./tei:note[@type=('change', 'printInstruction', 'overwritten')]">
                                        <h5 id="btn_more_text_layers" class="mt-2 cursor-pointer text-dropdown-toggle" role="button" aria-expanded="false" aria-controls="#list_more_text_layers">
                                            Bearbeitungsschichten</h5>
                                        
                                        <ul id="list_more_layers" class="list-unstyled visually-hidden"><!-- removed class d-none -->
                                            <xsl:if test="./tei:note[@type='change'][not(@corresp=('#edACE', '#typewriter2'))]">
                                            <xsl:for-each select="./tei:note[@type='change'][not(@corresp=('#edACE', '#typewriter2'))]">
                                                <xsl:variable name="change" select="tokenize(@corresp, ' ')"/>
                                                <xsl:variable name="corresp">
                                                    <xsl:choose>
                                                        <xsl:when test="$doc_type = 'witnessPrint'">
                                                            <xsl:value-of select="replace(@corresp, '#', '')"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:for-each select="$change">
                                                                <xsl:value-of select="replace(., '#', '')"/>
                                                                <xsl:if test="position() != last()">
                                                                    <xsl:text> </xsl:text>
                                                                </xsl:if>
                                                            </xsl:for-each>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>
                                                <li class="my-1 list_more_text_layers" data-link="{$corresp}">
                                                    <xsl:value-of select="$creation//id(data($corresp))"/>
                                                </li>
                                            </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="./tei:note[@type='printInstruction']">
                                                <xsl:variable name="corresp">
                                                    <xsl:value-of select="replace(./tei:note[@type='printInstruction']/@corresp, '#', '')"/>
                                                </xsl:variable>
                                                <!--  add data link with corresp -->
                                                <!-- currently removed until new implementation -->
                                                <li class="my-1 list_more_text_layers_line">
                                                    <label id="btn-corresp-printInstruction" class="cursor-pointer text-dropdown-toggle" role="button" aria-expanded="false" aria-controls="#corresp-printInstruction-list">
                                                        <xsl:text>Markierung für den Druck der Fackel Nr. 890: </xsl:text>
                                                    </label>
                                                    <div id="corresp-printInstruction-list" class="visually-hidden">
                                                    <xsl:choose>
                                                        <xsl:when test="count(./tei:note[@type='printInstruction']) gt 1">
                                                            <ul class="list-unstyled ps-1">
                                                                <xsl:for-each select="./tei:note[@type='printInstruction']">
                                                                    <li><xsl:value-of select="./text()"/></li>
                                                                </xsl:for-each>
                                                            </ul>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="./tei:note[@type='printInstruction']/text()"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                    </div>
                                                </li>
                                            </xsl:if>
                                            <xsl:if test="./tei:note[@type='overwritten']">
                                                <li class="my-1">
                                                    <label id="btn-corresp-overwritten" class="cursor-pointer text-dropdown-toggle" role="button" aria-expanded="false" aria-controls="#corresp-fackel-list-overwritten">
                                                        <xsl:text>Überschreibende Korrekturen</xsl:text>
                                                    </label>
                                                    <ul id="list-corresp-overwritten" class="visually-hidden list-unstyled ps-1">
                                                        <xsl:for-each select="./tei:note[@type='overwritten']">
                                                            <xsl:variable name="corresp" select="replace(@corresp, '#', '')"/>
                                                            <li class="list_more_text_layers_line" data-overwritten="{$corresp}" style="font-size:0.9em;">
                                                                <xsl:value-of select="$creation//id(data($corresp))"/>
                                                            </li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </li>
                                            </xsl:if>
                                            <xsl:if test="./tei:note[@type='printF890']">
                                                <li class="my-1">
                                                    <label id="btn-corresp-fackel" class="cursor-pointer text-dropdown-toggle" role="button" aria-expanded="false" aria-controls="#corresp-fackel-list">
                                                        <xsl:text>Markierung für die Fackel Nr. 890-905</xsl:text>
                                                    </label>
                                                    <ul id="corresp-fackel-list" class="visually-hidden list-unstyled ps-1">
                                                        <xsl:for-each select="./tei:note[@type='printF890']">
                                                            <li class="list_more_text_layers_line" data-link="{replace(@target, '#', '')}" style="font-size:0.9em;">
                                                                <xsl:value-of select="./text()"/>
                                                            </li>
                                                            <xsl:variable name="regrefs">
                                                                <xsl:value-of select="tokenize(@corresp, ' ')"/>
                                                            </xsl:variable>
                                                            <xsl:if test="count($regrefs) gt 0">
                                                            <li class="list_more_text_layers_line" style="font-size:0.9em;">
                                                                <xsl:for-each select="$regrefs">
                                                                    <xsl:variable name="corresp" select="replace(current(), '#', '')"/>
                                                                    <xsl:choose>
                                                                        <xsl:when test="$corresp = 'none'">
                                                                            <xsl:text>Keine Entsprechung in der Fackel Nr. 890-905.</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:apply-templates select="doc('../../data/indices/Register.xml')//*[@xml:id=$corresp]" mode="typo_short_info">
                                                                                <xsl:with-param name="printType" select="'fackel'"/>
                                                                            </xsl:apply-templates>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:for-each>
                                                            </li>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </ul>
                                                </li>
                                            </xsl:if>
                                        </ul>
                                    </xsl:if>
                                    
                                    <!-- ########### -->
                                    <!-- textblock 5 -->
                                    <!-- ########### -->
                                    <xsl:if test="./tei:note[starts-with(@type, 'tpq')]/text()">
                                        <h5 id="btn_tpq_info" class="mt-2 cursor-pointer text-dropdown-toggle" role="button" aria-expanded="false" aria-controls="#list_tpq_info">
                                            Datierung - terminus post quem [BETA]</h5>
                                        <div id="list_tpq_info" class="visually-hidden"><!-- removed class d-none -->
                                            <xsl:for-each select="./tei:note[@type='tpqBase']">
                                                <p class="tpq" data-linkone="{replace(@corresp, '#', '')}">
                                                    <xsl:text>Grundschicht: </xsl:text>
                                                    <xsl:call-template name="note_date">
                                                        <xsl:with-param name="input" select="./text()"/>
                                                    </xsl:call-template>
                                                    <xsl:text> (zitierter Text)</xsl:text>
                                                </p>
                                            </xsl:for-each>
                                            <xsl:for-each select="./tei:note[@type='tpqAdd']">
                                                <p class="tpq" data-linkone="{replace(@corresp, '#', '')}">
                                                    <xsl:text>Hs. Ergänzung: </xsl:text>
                                                    <xsl:call-template name="note_date">
                                                        <xsl:with-param name="input" select="./text()"/>
                                                    </xsl:call-template>
                                                    <xsl:text> (zitierter Text)</xsl:text>
                                                </p>
                                            </xsl:for-each>
                                        </div>
                                    </xsl:if>
                                    
                                    <!-- ########### -->
                                    <!-- textblock 6 -->
                                    <!-- ########### -->
                                    <xsl:if test="./tei:note[@type=('delQuote', 'delPers')]">
                                        <h5 id="btn_delQP_info" class="mt-2 cursor-pointer text-dropdown-toggle" role="button" aria-expanded="false" aria-controls="#list_delQP_info">
                                            Inhaltliche Anmerkung</h5>
                                        <div id="list_delQP_info" class="visually-hidden"><!-- removed class d-none -->
                                            <xsl:text>Eliminierter Verweis auf </xsl:text>
                                            <xsl:for-each select="./tei:note[@type=('delQuote', 'delPers')]">
                                                <div class="delQP">
                                                    <xsl:variable name="regrefs">
                                                        <xsl:value-of select="tokenize(@corresp, ' ')"/>
                                                    </xsl:variable>
                                                    <xsl:variable name="target">
                                                        <xsl:value-of select="@target"/>
                                                    </xsl:variable>
                                                    <xsl:for-each select="$regrefs">
                                                        <xsl:variable name="corresp" select="replace(current(), '#', '')"/>
                                                        <xsl:apply-templates select="doc('../../data/indices/Register.xml')//tei:citedRange[@xml:id=$corresp]" mode="typo_short_info">
                                                            <xsl:with-param name="printType" select="'register'"/>
                                                            <xsl:with-param name="datalink" select="concat(replace($target, '#', ''), ' ', replace($corresp, '#', ''))"/>
                                                        </xsl:apply-templates>
                                                        <!-- <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//*[@xml:id=$target]" mode="detail_view_textpage" /> -->
                                                    </xsl:for-each>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </xsl:if>
                                    
                                </div>
                            </xsl:for-each>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template name="note_date">
        <xsl:param name="input" select="."/>
        <!-- convert iso date to string dd. mm. yyyy -->
        <xsl:variable name="check-iso" select="matches($input, '(\d{4})-(\d{2})-(\d{2})')"/>
        <xsl:variable name="check-iso-no-day" select="matches($input, '(\d{4})-(\d{2})')"/>
        <xsl:variable name="check-iso-year-only" select="matches($input, '(\d{4})')"/>
        <xsl:choose>
            <xsl:when test="$check-iso">
                <xsl:variable name="date" select="replace($input, '(\d{4})-(\d{2})-(\d{2})', '$3. $2. $1')"/>
                <xsl:value-of select="$date"/>
            </xsl:when>
            <xsl:when test="$check-iso-no-day">
                <xsl:variable name="date" select="replace($input, '(\d{4})-(\d{2})', '$2. $1.')"/>
                <xsl:value-of select="$date"/>
            </xsl:when>
            <xsl:when test="$check-iso-year-only">
                <xsl:variable name="date" select="replace($input, '(\d{4})', '$1')"/>
                <xsl:value-of select="$date"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="format_corresp">
        <xsl:param name="corresp" select="."/>
        <xsl:choose>
            <xsl:when test="contains($corresp, 'inkOnProofKK')">
                <xsl:text>Tinte, schwarz (Karl Kraus)</xsl:text>
            </xsl:when>
            <xsl:when test="contains($corresp, 'pencilOnProofKK')">
                <xsl:text>Bleistift (vermutl. Karl Kraus)</xsl:text>
            </xsl:when>
            <xsl:when test="$corresp='#inkOnProof' or $corresp='#inkOnTypescript'">
                <xsl:text>Tinte, schwarz</xsl:text>
            </xsl:when>
            <xsl:when test="contains($corresp, 'blueInkOnProof')">
                <xsl:text>Tinte, blau</xsl:text>
            </xsl:when>
            <xsl:when test="$corresp='#pencilOnProof' or $corresp='#pencilOnTypescript'">
                <xsl:text>Bleistift (ev. Druckerei Jahoda &amp; Siegel)</xsl:text>
            </xsl:when>
            <xsl:when test="$corresp='#redOnProof'">
                <xsl:text>Buntstift, rot</xsl:text>
            </xsl:when>
            <xsl:when test="$corresp='#bluePencilOnProof'">
                <xsl:text>Buntstift, blau</xsl:text>
            </xsl:when>
            <xsl:when test="$corresp='#pencilOnProofLibrary'">
                <xsl:text>Bleistift (National Library of Israel)</xsl:text>
            </xsl:when>
            <xsl:when test="$corresp='#typewriter'">
                <xsl:text>Schreibmaschine</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$corresp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
</xsl:stylesheet>
