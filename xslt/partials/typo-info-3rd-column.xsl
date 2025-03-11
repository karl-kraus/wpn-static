<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wpn="https://wpn.acdh.oeaw.ac.at"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="2.0" exclude-result-prefixes="#all">

    <div id="infocolumn" class="bg-white px-0 border-start border-light-grey">
        <div id="infocontent-pb">
        <xsl:for-each select="//tei:TEI/tei:facsimile[@corresp='#DWkonJer']/tei:surface">
            <xsl:variable name="corresp" select="replace(@corresp, '#', '')"/>
            <div class="note m-2 {$corresp}">
                <!-- ########### -->
                <!-- textblock 1 -->
                <!-- ########### -->
                <h5><xsl:text>Jerusalemer Konvolut, fol. [</xsl:text><xsl:value-of select="@n"/><xsl:text>] recto</xsl:text></h5>
                <xsl:for-each select="./tei:note[@type='pagination']">
                    <p><xsl:value-of select="concat('Pagination ', ./text(), ' (', replace(@corresp, '#', ''), ')')"/></p>
                </xsl:for-each>

                <!-- ########### -->
                <!-- textblock 2 -->
                <!-- ########### -->
                <h6 class="mt-2">Textträger</h6>
                <p><xsl:text>Standort, Signatur: </xsl:text></p>
                <p><xsl:text>Grundschicht, Material: </xsl:text><xsl:value-of select="ancestor::tei:TEI/tei:teiHeader//tei:item[@xml:id=$corresp]/text()"/></p>
                
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
                
                    <ul id="list_more_text_layers" class="d-none list-unstyled ms-2">
                        <xsl:for-each select="./tei:note[@type='change'][not(@corresp='#edACE')]">
                            <li class="cursor-pointer my-1" data-link="{@corresp}"><xsl:value-of select="replace(@corresp, '#', '')"/></li>
                        </xsl:for-each>
                        <li class="cursor-pointer my-1" data-link="{@corresp}">
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
                    </ul>
                </xsl:if>

                <!-- ########### -->
                <!-- textblock 5 -->
                <!-- ########### -->
                <xsl:if test="./tei:note[@type='tpqBase']">
                    <h6 class="mt-2">Datierung (terminus post quem)</h6>
                    <xsl:for-each select="./tei:note[@type='tpqBase']">
                        <p class="tpq cursor-pointer" data-link="{@corresp}"><xsl:value-of select="concat('Grundschicht: ', ./text(), ' (zitierter Text)')"/></p>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="./tei:note[@type='tpqAdd']">
                    <xsl:for-each select="./tei:note[@type='tpqAdd']">
                        <p class="tpq cursor-pointer" data-link="{@corresp}"><xsl:value-of select="concat('Hs. Ergänzung: ', ./text(), ' (zitierter Text)')"/></p>
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
                                <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//*[@xml:id=$target]" mode="short_info"/>
                                <!-- <xsl:apply-templates select="doc('../data/editions/Gesamt.xml')//*[@xml:id=$target]" mode="detail_view_textpage" /> -->
                            </xsl:for-each>
                        </div>
                    </xsl:for-each>
                </xsl:if>
            </div>
        </xsl:for-each>
        </div>
    </div>
</stylesheet>