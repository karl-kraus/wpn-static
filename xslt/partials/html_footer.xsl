<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:template match="/" name="html_footer">
    <xsl:param name="additional_clases"/>
    <xsl:param name="include_scroll_script" select="true()"/>
        <footer class="footer mt-auto py-3 border-top border-light-grey bg-white {$additional_clases}">
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
                        <a class="project-link ps-4 link-dark-grey link-hover-primary-hover text-decoration-none" target="_blank" rel="noopener noreferrer" href="{$github_url}"><span class="visually-hidden">github link</span>
                            <svg aria-hidden="true" focusable="false" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-github" viewBox="0 0 16 16">
                                <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27s1.36.09 2 .27c1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.01 8.01 0 0 0 16 8c0-4.42-3.58-8-8-8"/>
                            </svg>
                        </a>
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