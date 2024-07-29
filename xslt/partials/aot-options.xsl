<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl tei" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>
            <h1>Widget annotation options.</h1>
            <p>Contact person: daniel.stoxreiter@oeaw.ac.at</p>
            <p>Applied with call-templates in html:body.</p>
            <p>Custom template to create interactive options for text annoations.</p>
        </desc>    
    </doc>
    
    <xsl:template name="annotation-options">
    <div>
            <div id="aot-navBarNavDropdown" class="navBarNavDropdown dropstart d-md-none">
                <!-- Your menu goes here -->
                <a title="Annotationen" href="#" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false" role="button">
                    <i class="bi bi-gear" title="Menü zur Anpassung der Anzeige"></i>
                </a>                  
                <ul class="dropdown-menu d-block border-0 z-2">
                    <!--<li class="dropdown-item">
                        <full-size opt="fls"></full-size>
                    </li>
                    <li class="dropdown-item">
                        <image-switch opt="es"></image-switch>
                    </li>
                    <li class="dropdown-item">
                        <font-size opt="fs"></font-size>
                    </li>
                    <li class="dropdown-item">
                        <font-family opt="ff"></font-family>
                    </li>-->
                    <li class="dropdown-item">
                        <annotation-slider opt="prs" class="text-wpn-person fs-7"></annotation-slider>
                    </li>
                    <li class="dropdown-item">
                        <annotation-slider opt="quts" class="text-wpn-quote fs-7"></annotation-slider>
                    </li>
                    <li class="dropdown-item">
                        <annotation-slider opt="pbs" class="text-black-grey fs-7"></annotation-slider>
                    </li>
                    <li class="dropdown-item">
                        <annotation-slider opt="cmts" class="text-comment fs-7"></annotation-slider>
                    </li>
                </ul>                                                    
            </div>
            <div class="d-none d-md-block">
                    <!-- Your menu goes here -->               
                    <ul class="border-0 z-2 list-unstyled">
                        <!--<li class="dropdown-item">
                            <full-size opt="fls"></full-size>
                        </li>
                        <li class="dropdown-item">
                            <image-switch opt="es"></image-switch>
                        </li>
                        <li class="dropdown-item">
                            <font-size opt="fs"></font-size>
                        </li>
                        <li class="dropdown-item">
                            <font-family opt="ff"></font-family>
                        </li>-->
                        <li>
                            <annotation-slider opt="prs" class="text-wpn-person fs-7 mx-auto"></annotation-slider>
                        </li>
                        <li>
                            <annotation-slider opt="quts" class="text-wpn-quote fs-7 mx-auto"></annotation-slider>
                        </li>
                        <li>
                            <annotation-slider opt="pbs" class="text-black-grey fs-7 mx-auto"></annotation-slider>
                        </li>
                         <li>
                            <annotation-slider opt="cmts" class="text-wpn-comment fs-7 mx-auto"></annotation-slider>
                        </li>
                    </ul>                                                    
                </div>
        </div>
        
    </xsl:template>
</xsl:stylesheet>