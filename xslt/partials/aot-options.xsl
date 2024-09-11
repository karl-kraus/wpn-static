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
                   <!--<li class="dropdown-item">
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
                    </li>-->
                </ul>                                                    
            </div>
            <div class="d-none d-md-block mt-2">
                    <!-- Your menu goes here --> 
                    <fieldset class="mb-2">
                        <div class="d-flex gap-1_5 justify-content-center mb-05">
                        <wpn-text-zoom-button zoom-direction="in">
                            <svg viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false" width="24" height="24"><g><path fill="#999" d="M13 7h-2v4H7v2h4v4h2v-4h4v-2h-4V7zm-1-5C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"></path></g></svg>
                        </wpn-text-zoom-button>
                        <wpn-text-zoom-button zoom-direction="out">
                            <svg viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false" width="24" height="24"><g><path fill="#999" d="M7 11v2h10v-2H7zm5-9C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"></path></g></svg>
                        </wpn-text-zoom-button>
                        </div>
                        <legend class="text-dark-grey fs-7 text-center">Textgröße</legend>
                    </fieldset>                        
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
                        <li class="mb-1">
                            <annotation-slider data-disable-btns='fkl' opt="prs" class="text-wpn-person fs-7 mx-auto"></annotation-slider>
                        </li>
                        <li class="mb-1">
                            <annotation-slider data-disable-btns='fkl' opt="quts" class="text-wpn-quote fs-7 mx-auto"></annotation-slider>
                        </li>
                        <li class="mb-1">
                            <annotation-slider data-disable-btns='prs,quts' opt="fkl" class="text-wpn-fackel fs-7 mx-auto"></annotation-slider>
                        </li>
                        <li class="mb-1">
                            <annotation-slider opt="pbs" class="text-black-grey fs-7 mx-auto"></annotation-slider>
                        </li>
                         <li class="mb-1">
                            <annotation-slider opt="cmts" class="text-wpn-comment fs-7 mx-auto"></annotation-slider>
                        </li>
                    </ul>                                                    
                </div>
        </div>
        
    </xsl:template>
</xsl:stylesheet>