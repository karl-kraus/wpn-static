<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    exclude-result-prefixes="xs tei local"
    version="2.0">
    <xsl:function name="local:makeId" as="xs:string">
        <xsl:param name="currentNode" as="node()"/>
        <xsl:variable name="nodeCurrNr">
            <xsl:value-of select="count($currentNode//preceding-sibling::*) + 1"/>
        </xsl:variable>
        <xsl:value-of select="concat(name($currentNode), '__', $nodeCurrNr)"/>
    </xsl:function>
    
    <xsl:template match="tei:pb">
        <span class="anchor-pb"></span>
        <span class="pb" source="{@facs}"><xsl:value-of select="./@n"/></span>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:del">
        <del><xsl:apply-templates/></del>
    </xsl:template>
    <xsl:template match="tei:cit">
        <cite><xsl:apply-templates/></cite>
    </xsl:template>
    <xsl:template match="tei:quote">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:date">
        <span class="date"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:lb"/>


    <xsl:template match="tei:list[@type='unordered']">
        <xsl:choose>
            <xsl:when test="ancestor::tei:body">
                <ul class="yes-index">
                    <xsl:apply-templates/>
                </ul>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:item">
        <xsl:choose>
            <xsl:when test="parent::tei:list[@type='unordered']|ancestor::tei:body">
                <li><xsl:apply-templates/></li>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:hi">
        <span>
            <xsl:choose>
                <xsl:when test="@rendition = '#em'">
                    <xsl:attribute name="class">
                        <xsl:text>italic </xsl:text>
                        <xsl:value-of select="substring-after(@change, '#')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rendition = '#italic'">
                    <xsl:attribute name="class">
                        <xsl:text>italic </xsl:text>
                        <xsl:value-of select="substring-after(@change, '#')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rendition = '#smallcaps'">
                    <xsl:attribute name="class">
                        <xsl:text>smallcaps </xsl:text>
                        <xsl:value-of select="substring-after(@change, '#')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rendition = '#bold'">
                    <xsl:attribute name="class">
                        <xsl:text>bold </xsl:text>
                        <xsl:value-of select="substring-after(@change, '#')"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:lg">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="tei:l">
        <xsl:apply-templates/><br/>
    </xsl:template>
    <xsl:template match="tei:p">
       <p class="replace(@rendition,'#','')"><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:attribute name="class">
                <xsl:text>table table-bordered table-striped table-condensed table-hover</xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:rs">
        <xsl:choose>
            <xsl:when test="count(tokenize(@ref, ' ')) > 1">
                <xsl:choose>
                    <xsl:when test="@type='person'">
                        <span class="persons {substring-after(@rendition, '#')}" id="{@xml:id}">
                            <xsl:apply-templates/>
                            <xsl:for-each select="tokenize(@ref, ' ')">
                                <sup class="entity" data-bs-toggle="modal" data-bs-target="{.}">
                                    <xsl:value-of select="position()"/>
                                </sup>
                                <xsl:if test="position() != last()">
                                    <sup class="entity">/</sup>
                                </xsl:if>
                            </xsl:for-each>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='place'">
                        <span class="places {substring-after(@rendition, '#')}" id="{@xml:id}">
                            <xsl:apply-templates/>
                            <xsl:for-each select="tokenize(@ref, ' ')">
                                <sup class="entity" data-bs-toggle="modal" data-bs-target="{.}">
                                    <xsl:value-of select="position()"/>
                                </sup>
                                <xsl:if test="position() != last()">
                                    <sup class="entity">/</sup>
                                </xsl:if>
                            </xsl:for-each>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='bibl'">
                        <span class="works {substring-after(@rendition, '#')}" id="{@xml:id}">
                            <xsl:apply-templates/>
                            <xsl:for-each select="tokenize(@ref, ' ')">
                                <sup class="entity" data-bs-toggle="modal" data-bs-target="{.}">
                                    <xsl:value-of select="position()"/>
                                </sup>
                                <xsl:if test="position() != last()">
                                    <sup class="entity">/</sup>
                                </xsl:if>
                            </xsl:for-each>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='org'">
                        <span class="orgs {substring-after(@rendition, '#')}" id="{@xml:id}">
                            <xsl:apply-templates/>
                            <xsl:for-each select="tokenize(@ref, ' ')">
                                <sup class="entity" data-bs-toggle="modal" data-bs-target="{.}">
                                    <xsl:value-of select="position()"/>
                                </sup>
                                <xsl:if test="position() != last()">
                                    <sup class="entity">/</sup>
                                </xsl:if>
                            </xsl:for-each>
                        </span>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@type='person'">
                        <span class="persons entity {substring-after(@rendition, '#')}" id="{@xml:id}" data-bs-toggle="modal" data-bs-target="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='place'">
                        <span class="places entity {substring-after(@rendition, '#')}" id="{@xml:id}" data-bs-toggle="modal" data-bs-target="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='bibl'">
                        <span class="works entity {substring-after(@rendition, '#')}" id="{@xml:id}" data-bs-toggle="modal" data-bs-target="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='org'">
                        <span class="orgs entity {substring-after(@rendition, '#')}" id="{@xml:id}" data-bs-toggle="modal" data-bs-target="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:listPerson">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:person">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="5" />
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="modal fade" id="{@xml:id}" data-bs-keyboard="false" tabindex="-1" aria-labelledby="{concat(./tei:persName[1]/tei:surname[1], ', ', ./tei:persName[1]/tei:forename[1])}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel"><xsl:value-of select="concat(./tei:persName[1]/tei:surname[1], ', ', ./tei:persName[1]/tei:forename[1])"/></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table class="table">
                            <tbody>
                                <xsl:if test="./tei:idno[@type='GEONAMES']">
                                <tr>
                                    <th>
                                        Geonames ID
                                    </th>
                                    <td>
                                        <a href="{./tei:idno[@type='GEONAMES']}" target="_blank">
                                            <xsl:value-of select="tokenize(./tei:idno[@type='GEONAMES'], '/')[4]"/>
                                        </a>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='WIKIDATA']">
                                <tr>
                                    <th>
                                        Wikidata ID
                                    </th>
                                    <td>
                                        <a href="{./tei:idno[@type='WIKIDATA']}" target="_blank">
                                            <xsl:value-of select="tokenize(./tei:idno[@type='WIKIDATA'], '/')[last()]"/>
                                        </a>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='GND']">
                                <tr>
                                    <th>
                                        GND ID
                                    </th>
                                    <td>
                                        <a href="{./tei:idno[@type='GND']}" target="_blank">
                                            <xsl:value-of select="tokenize(./tei:idno[@type='GND'], '/')[last()]"/>
                                        </a>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:listEvent">
                                <tr>
                                    <th>
                                        Erwähnungen
                                    </th>
                                    <td>
                                        <ul>
                                            <xsl:for-each select=".//tei:event">
                                                <xsl:variable name="linkToDocument">
                                                    <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"/>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="position() lt $showNumberOfMentions + 1">
                                                        <li>
                                                            <xsl:value-of select=".//tei:title"/><xsl:text> </xsl:text>
                                                            <a href="{$linkToDocument}">
                                                                <i class="fas fa-external-link-alt"></i>
                                                            </a>
                                                        </li>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </tr>
                                </xsl:if>
                                <tr>
                                    <th></th>
                                    <td>
                                        Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a> für eine vollständige Auflistung
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:listPlace">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:place">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="5" />
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="modal fade" id="{@xml:id}" data-bs-keyboard="false" tabindex="-1" aria-labelledby="{if(./tei:settlement) then(./tei:settlement/tei:placeName) else (./tei:placeName)}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel"><xsl:value-of select="if(./tei:settlement) then(./tei:settlement/tei:placeName) else (./tei:placeName)"/></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table>
                            <tbody>
                                <xsl:if test="./tei:country">
                                <tr>
                                    <th>
                                        Country
                                    </th>
                                    <td>
                                        <xsl:value-of select="./tei:country"/>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='GND']/text()">
                                    <tr>
                                        <th>
                                            GND
                                        </th>
                                        <td>
                                            <a href="{./tei:idno[@type='GND']}" target="_blank">
                                                <xsl:value-of select="tokenize(./tei:idno[@type='GND'], '/')[last()]"/>
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='WIKIDATA']/text()">
                                    <tr>
                                        <th>
                                            Wikidata
                                        </th>
                                        <td>
                                            <a href="{./tei:idno[@type='WIKIDATA']}" target="_blank">
                                                <xsl:value-of select="tokenize(./tei:idno[@type='WIKIDATA'], '/')[last()]"/>
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='GEONAMES']/text()">
                                    <tr>
                                        <th>
                                            Geonames
                                        </th>
                                        <td>
                                            <a href="{./tei:idno[@type='GEONAMES']}" target="_blank">
                                                <xsl:value-of select="tokenize(./tei:idno[@type='GEONAMES'], '/')[4]"/>
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:listEvent">
                                <tr>
                                    <th>
                                        Erwähnungen
                                    </th>
                                    <td>
                                        <ul>
                                            <xsl:for-each select=".//tei:event">
                                                <xsl:variable name="linkToDocument">
                                                    <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"/>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="position() lt $showNumberOfMentions + 1">
                                                        <li>
                                                            <xsl:value-of select=".//tei:title"/><xsl:text> </xsl:text>
                                                            <a href="{$linkToDocument}">
                                                                <i class="fas fa-external-link-alt"></i>
                                                            </a>
                                                        </li>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </tr>
                                </xsl:if>
                                <tr>
                                    <th></th>
                                    <td>
                                        Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a> für eine vollständige Auflistung
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:listOrg">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:org">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="5" />
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="modal fade" id="{@xml:id}" data-bs-keyboard="false" tabindex="-1" aria-labelledby="{if(./tei:settlement) then(./tei:settlement/tei:placeName) else (./tei:placeName)}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel"><xsl:value-of select="if(./tei:settlement) then(./tei:settlement/tei:placeName) else (./tei:placeName)"/></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table class="table">
                            <tbody>
                                <xsl:if test="./tei:idno[@type='GEONAMES']">
                                <tr>
                                    <th>
                                        Geonames ID
                                    </th>
                                    <td>
                                        <a href="{./tei:idno[@type='GEONAMES']}" target="_blank">
                                            <xsl:value-of select="tokenize(./tei:idno[@type='GEONAMES'], '/')[4]"/>
                                        </a>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='WIKIDATA']">
                                <tr>
                                    <th>
                                        Wikidata ID
                                    </th>
                                    <td>
                                        <a href="{./tei:idno[@type='WIKIDATA']}" target="_blank">
                                            <xsl:value-of select="tokenize(./tei:idno[@type='WIKIDATA'], '/')[last()]"/>
                                        </a>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='GND']">
                                <tr>
                                    <th>
                                        GND ID
                                    </th>
                                    <td>
                                        <a href="{./tei:idno[@type='GND']}" target="_blank">
                                            <xsl:value-of select="tokenize(./tei:idno[@type='GND'], '/')[last()]"/>
                                        </a>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:listEvent">
                                <tr>
                                    <th>
                                        Erwähnungen
                                    </th>
                                    <td>
                                        <ul>
                                            <xsl:for-each select=".//tei:event">
                                                <xsl:variable name="linkToDocument">
                                                    <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"/>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="position() lt $showNumberOfMentions + 1">
                                                        <li>
                                                            <xsl:value-of select=".//tei:title"/><xsl:text> </xsl:text>
                                                            <a href="{$linkToDocument}">
                                                                <i class="fas fa-external-link-alt"></i>
                                                            </a>
                                                        </li>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </tr>
                                </xsl:if>
                                <tr>
                                    <th></th>
                                    <td>
                                        Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a> für eine vollständige Auflistung
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:listBibl">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:seg|tei:event" mode="link_list">
        <xsl:param name="elem_id"/>
        <xsl:if test="tei:ref[@type='ext'] or tei:desc/tei:ref[@type='ext']">
            <div class="py-1 border-bottom border-light-grey">
                <details>
                    <summary class="d-flex align-items-baseline">Links</summary>
                        <ul data-testid="external_links_{$elem_id}" class="list-unstyled mb-0">
                            <xsl:for-each select="tei:ref[@type='ext'] | tei:desc/tei:ref[@type='ext']">
                                <xsl:apply-templates select="current()" mode="link_list_item"/>
                            </xsl:for-each>
                        </ul>
                </details>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:ref[@type='ext']" mode="link_list_item">
        <li><a class="d-block text-decoration-none text-dark-grey text-blacker-grey-hover" href="{@target}" target="_blank">
            <xsl:apply-templates mode="ref_link"/>
            <svg class="ms-2 align-baseline" width="5" height="10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.281 9.061">
                <path style="fill:none;stroke:#666;stroke-linejoin:round;stroke-miterlimit:10;stroke-width:1.5px;" d="M.354.353l4,4-4,4" transform="translate(0.177 0.177)"></path>
            </svg>
        </a></li>
    </xsl:template>
    <xsl:template name="list_bibliographic_data">
        <xsl:param name="elem_id"/>
        <xsl:param name="node"/>
        <xsl:param name="type"/>
        <xsl:variable name="index" select="if ($type='source') then 'SekLit_Kommentar' else 'Register'"/>
        <div>
            <details class="py-1 border-bottom border-light-grey">
                <summary class="d-flex align-items-baseline summary-sources">
                    <xsl:choose>
                        <xsl:when test="$type = 'source'">
                            <span>Quellen</span>
                        </xsl:when>
                        <xsl:when test="$type = 'int'">
                            <span>Intertexte</span>
                        </xsl:when>
                    </xsl:choose>
                </summary>
                <ul class="list-unstyled mb-0" data-testid="{$type}_{$elem_id}">
                    <xsl:for-each-group select="$node//tei:ref[@type=$type]/tokenize(@target,' ')" group-by="doc('../../data/indices/'||$index||'.xml')//(tei:citedRange|tei:bibl)[@xml:id=replace(current(),'#','')]/ancestor-or-self::tei:bibl/@xml:id">
                        <xsl:sort select="doc('../../data/indices/'||$index||'.xml')//tei:bibl[@xml:id=current-grouping-key()]/@sortKey"/>
                        <xsl:variable name="target_id" select="replace(current(),'#','')"/>
                        <li class="my-05 lh-0_86">
                            
                                <xsl:choose>
                                    <xsl:when test="$type = 'source'">
                                        <span data-bibl-id="{current-grouping-key()}">
                                            <xsl:apply-templates select="doc('../../data/indices/'||$index||'.xml')//(tei:bibl)[@xml:id=current-grouping-key()]/(text()|tei:ref)" mode="list_bibliographic_data"/>
                                        </span>
                                        <xsl:for-each select="current-group()">
                                            <xsl:if test="position() = 1">
                                                <xsl:text>, </xsl:text>
                                            </xsl:if>
                                            <span data-cited-range="{replace(current(),'#','')}">
                                                <xsl:apply-templates select="doc('../../data/indices/'||$index||'.xml')//(tei:citedRange)[@xml:id=replace(current(),'#','')]/(text()|tei:ref)" mode="list_bibliographic_data"/>
                                            </span>
                                            <xsl:if test="not(position() = last())">
                                                <xsl:text>, </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:variable name="bibl_node" select="doc('../../data/indices/'||$index||'.xml')//(tei:bibl)[@xml:id=current-grouping-key()]"/>
                                        <xsl:variable name="ref_node" select="doc('../../data/indices/'||$index||'.xml')//(tei:bibl|tei:citedRange)[@xml:id=replace(current-group(),'#','')]"/>
                                        <a class="text-decoration-none text-dark-grey" href="{'register_intertexte.html?letter='||substring($bibl_node/@sortKey,1,1)||'#'||$bibl_node/@xml:id}" target="_blank">    
                                            <xsl:choose>
                                                <xsl:when test="$ref_node/name() = 'citedRange'">
                                                    <xsl:if test="$ref_node/tei:ref[@type='int']">
                                                        <xsl:apply-templates select="$ref_node/tei:ref[@type='int']"/>
                                                    </xsl:if>
                                                    <xsl:apply-templates select="$bibl_node">
                                                        <xsl:with-param name="render-cited-range" select="normalize-space(string-join($ref_node/text()))" />
                                                    </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates select="$bibl_node">
                                                       <!-- <xsl:with-param name="detail_view_textpage" select="true()"/> -->
                                                    </xsl:apply-templates>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </a>
                                    </xsl:otherwise>
                                </xsl:choose>
                        </li>
                    </xsl:for-each-group>
                </ul>
            </details>
        </div>
    </xsl:template>
    <xsl:template name="category_list">
    <xsl:variable name="category_ids" select="tokenize(@corresp,' ')"/>
    <xsl:variable name="categories_label">
        <xsl:choose>
            <xsl:when test="count($category_ids) = 1">
                <xsl:text>Kategorie: </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Kategorien: </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <span><xsl:value-of select="$categories_label"/></span>
    <ul data-testid="category_list_{@xml:id}" class="list-unstyled d-inline inline-list-comma-separated">
        <xsl:for-each select="$category_ids">
        <xsl:variable name="category" select="doc('../../data/indices/Events.xml')//(tei:desc)[@xml:id=replace(current(),'#','')]"/>
            <li class="d-inline">
                <span class="text-primary-hover cursor-default">
                    <xsl:apply-templates select="$category" mode="ref_link"/>
                </span>
            </li>
        </xsl:for-each>
    </ul>
    </xsl:template>
    <xsl:template match="text()" mode="list_bibliographic_data">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    <!-- trailing space in data -->
    <xsl:template match="text()[last()][preceding-sibling::text()][not(following-sibling::*)]" mode="ref_link">
            <xsl:value-of select="replace(.,'\s+$','')"/>
    </xsl:template>
    <xsl:template match="tei:title" mode="ref_link">
        <i><xsl:value-of select="normalize-space(.)"/></i>
    </xsl:template>
    <xsl:template match="tei:ref" mode="list_bibliographic_data">
        <xsl:text> </xsl:text>
        <a href="{.}" target="_blank"><xsl:value-of select="."/></a>
    </xsl:template>
</xsl:stylesheet>
