<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:template name="info-3rd-column">
        <xsl:variable name="doc_type" select="//tei:pb/@type" />
        <div id="infocolumn" class="bg-white px-0 border-start border-light-grey">
            <div id="infocontent-pb">
            <xsl:for-each select="//tei:TEI/tei:facsimile[@corresp='#DWkonJer']/tei:surface">
                <xsl:variable name="convolute-id" select="./parent::tei:facsimile/@xml:id"/>
                <xsl:variable name="corresp-id" select="replace(@corresp, '#', '')"/>
                <div class="note m-2 {$corresp-id}">
                    <!-- ########### -->
                    <!-- textblock 1 -->
                    <!-- ########### -->
                    <h5><xsl:text>Jerusalemer Konvolut, fol. [</xsl:text><xsl:value-of select="@n"/><xsl:text>] recto</xsl:text></h5>
                    <xsl:for-each select="./tei:note[@type='pagination']">
                        <p id="paragraph-block-{position()}" class="paragraph-block" data-link="{@corresp}"> 
                            <xsl:text>Pagination </xsl:text>
                            <xsl:value-of select="./text()"/>
                            <xsl:text> (</xsl:text>
                            <xsl:call-template name="format_corresp">
                                <xsl:with-param name="corresp" select="@corresp"/>
                            </xsl:call-template>
                            <xsl:text>)</xsl:text>
                        </p>
                    </xsl:for-each>

                    <!-- ########### -->
                    <!-- textblock 2 -->
                    <!-- ########### -->
                    <h6 class="mt-2">Textträger</h6>
                    <p>
                        <xsl:text>Standort, Signatur: </xsl:text>
                        <xsl:value-of select="concat(//tei:sourceDesc[@xml:id=$convolute-id]/tei:msDesc/tei:msIdentifier/tei:institution/text(), ', ', //tei:sourceDesc[@xml:id=$convolute-id]/tei:msDesc/tei:msIdentifier/tei:collection/text(), ', ' //tei:sourceDesc[@xml:id=$convolute-id]/tei:msDesc/tei:msIdentifier/tei:idno[@type='signature']/text())"/>
                    </p>
                    <p><xsl:text>Grundschicht, Material: </xsl:text><xsl:value-of select="ancestor::tei:TEI/tei:teiHeader//tei:item[@xml:id=$corresp-id]/text()"/></p>
                    
                    <!-- ########### -->
                    <!-- textblock 3 -->
                    <!-- ########### -->
                    <h6 class="mt-2">Zustand</h6>
                    <p><xsl:value-of select="./tei:note[@type='stamp']/text()"/></p>

                    <!-- ########### -->
                    <!-- textblock 4 -->
                    <!-- ########### -->
                    <xsl:if test="./tei:note[@type=('change', 'printInstruction')]">
                        <h6 class="mt-2">Weitere Textschichten
                            <a id="btn_more_text_layers" class="cursor-pointer" role="button" aria-expanded="false" aria-controls="#list_more_text_layers">
                                <svg xmlns="http://www.w3.org/2000/svg" class="stroke-black-grey stroke-wpn-red-hover align-baseline ms-2" width="10" height="10" viewBox="0 0 8 8">
                                    <g transform="translate(0.53 0.75)">
                                        <path style="fill:none;stroke-width:1.5px;stroke-linejoin:round;" d="M0,6V0H6" transform="translate(6) rotate(90)"></path>
                                        <line style="fill:none;stroke-width:1.5px;" y1="6" x2="6"></line>
                                    </g>
                                </svg>
                            </a>
                        </h6>
                    
                        <ul id="list_more_layers_btn" class="d-none list-unstyled ms-2">
                            <xsl:for-each select="./tei:note[@type='change'][not(@corresp=('#edACE', '#typewriter2'))]">
                                <xsl:variable name="change" select="tokenize(@corresp, ' ')"/>
                                <xsl:variable name="corresp">
                                    <xsl:choose>
                                        <xsl:when test="$doc_type = 'witnessPrint'">
                                            <xsl:value-of select="@corresp"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each select="$change">
                                                <xsl:if test=". != '#typewriter'">
                                                    <xsl:value-of select="."/>
                                                    <xsl:if test="position() != last()">
                                                        <xsl:text> </xsl:text>
                                                    </xsl:if>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <li class="cursor-pointer my-1 list_more_text_layers" data-link="{$corresp}">
                                    <xsl:call-template name="format_corresp">
                                        <xsl:with-param name="corresp" select="@corresp"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:for-each>
                            <xsl:if test="./tei:note[@type='printInstruction']">
                            <li class="cursor-pointer my-1 list_more_text_layers_line" data-link="{./tei:note[@type='printInstruction']/@corresp}">
                                <xsl:text>Markierung für den Druck der Fackel Nr. 890: </xsl:text>
                                <xsl:choose>
                                    <xsl:when test="count(./tei:note[@type='printInstruction']) gt 1">
                                        <ul>
                                            <xsl:for-each select="./tei:note[@type='printInstruction']">
                                                <li><xsl:value-of select="./text()"/></li>
                                            </xsl:for-each>
                                        </ul>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="./tei:note[@type='printInstruction']/text()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </li>
                            </xsl:if>
                        </ul>
                    </xsl:if>

                    <!-- ########### -->
                    <!-- textblock 5 -->
                    <!-- ########### -->
                    <xsl:if test="./tei:note[@type='tpqBase']/text()">
                        <h6 class="mt-2">Datierung (terminus post quem)</h6>
                        <xsl:for-each select="./tei:note[@type='tpqBase']">
                            <p class="tpq cursor-pointer" data-link="{@corresp}">
                                <xsl:text>Grundschicht: </xsl:text>
                                <xsl:call-template name="note_date">
                                    <xsl:with-param name="input" select="./text()"/>
                                </xsl:call-template>
                                <xsl:text> (zitierter Text)</xsl:text>
                            </p>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="./tei:note[@type='tpqAdd']/text()">
                        <xsl:for-each select="./tei:note[@type='tpqAdd']">
                            <p class="tpq cursor-pointer" data-link="{@corresp}">
                                <xsl:text>Hs. Ergänzung: </xsl:text>
                                <xsl:call-template name="note_date">
                                    <xsl:with-param name="input" select="./text()"/>
                                </xsl:call-template>
                                <xsl:text> (zitierter Text)</xsl:text>
                            </p>
                        </xsl:for-each>
                    </xsl:if>

                    <!-- ########### -->
                    <!-- textblock 6 -->
                    <!-- ########### -->
                    <xsl:if test="./tei:note[@type=('delQuote', 'delPers')]">
                        <h6 class="mt-2">Anmerkung</h6>
                        <xsl:for-each select="./tei:note[@type=('delQuote', 'delPers')]">
                            <div class="delQP cursor-pointer" data-link="{@target}" data-register="{@corresp}">
                                <p>Eliminierter Verweis auf</p>
                                
                                <xsl:variable name="regrefs">
                                    <xsl:value-of select="tokenize(@target, ' ')"/>
                                </xsl:variable>
                                <xsl:for-each select="$regrefs">
                                    <xsl:variable name="target" select="replace(current(), '#', '')"/>
                                    <xsl:apply-templates select="doc('../../data/editions/Gesamt.xml')//*[@xml:id=$target]" mode="short_info"/>
                                    <!-- <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//*[@xml:id=$target]" mode="detail_view_textpage" /> -->
                                </xsl:for-each>
                            </div>
                        </xsl:for-each>
                    </xsl:if>
                </div>
            </xsl:for-each>
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
            <xsl:when test="contains($corresp, 'pencilOnProof')">
                <xsl:text>Bleistift</xsl:text>
            </xsl:when>
            <xsl:when test="contains($corresp, 'pencilOnProofKK')">
                <xsl:text>Bleistift (vermutl. Karl Kraus)</xsl:text>
            </xsl:when>
            <xsl:when test="contains($corresp, 'inkOnProof')">
                <xsl:text>Tinte, schwarz</xsl:text>
            </xsl:when>
            <xsl:when test="contains($corresp, 'redOnProof')">
                <xsl:text>Buntstift, rot</xsl:text>
            </xsl:when>
            <xsl:when test="contains($corresp, 'typewriter')">
                <xsl:text>Schreibmaschine</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$corresp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
