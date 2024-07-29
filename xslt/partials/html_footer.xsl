<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:template match="/" name="html_footer">
    <xsl:param name="include_scroll_script" select="true()"/>
        <footer class="footer mt-auto py-3 border-top border-light-grey">
            <div class="container mt-1_5">
                <ul class="list-unstyled d-flex flex-row justify-content-end">
                    <li>
                        <a class="project-link link-dark-grey link-hover-primary-hover text-decoration-none" href="impressum.html">Impressum</a>
                    </li>
                    <li>
                        <a class="project-link ps-4 link-dark-grey link-hover-primary-hover text-decoration-none" href="nutzungsbedingungen.html">Nutzungsbedingungen</a>
                    </li>
                    <li>
                        <a class="project-link ps-4 link-dark-grey link-hover-primary-hover text-decoration-none" href="projekt.html">Über das Projekt</a>
                    </li>
                    <li>
                        <a class="project-link ps-4 link-dark-grey link-hover-primary-hover text-decoration-none" href="{$github_url}"><i class="bi bi-github"></i></a>
                    </li>
                </ul>
            </div>
        </footer>
        <xsl:if test="include_scroll_script">
            <script src="js/scroll.js"></script>
        </xsl:if>
        <script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
        <script src="js/vendor/bootstrap/bootstrap.bundle.min.js"></script>
        
        
    </xsl:template>
</xsl:stylesheet>