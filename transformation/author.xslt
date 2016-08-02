<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:coerp="http://coerp.uni-koeln.de/schema/coerp"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs coerp tei"
    version="2.0">
    <xsl:output omit-xml-declaration="no" indent="yes"/>
    <xsl:variable name="docs" select=" collection(iri-to-uri('../transformation/old/?select=*.*'))"/>
    <xsl:template match="/">
        <!--<xsl:copy-of select="$docs"/>-->
        <xsl:variable name="text" select="($docs//coerp:author | $docs//coerp:author)"/>
            <xsl:for-each select="$text"  >
                
                <xsl:sort select="."/>
                <term>
                    <orig key=""><xsl:value-of select="."/></orig>
                </term>
                <!--<term>
                    <orig key=""><xsl:value-of select=".//coerp:author"/></orig>
                </term>-->
               <!--<xsl:apply-templates select="//coerp:author"></xsl:apply-templates>-->
                
            </xsl:for-each>
        
        
    </xsl:template>

    <xsl:template match="//coerp:author">      
        <term>
        <orig key=""><xsl:value-of select="."/></orig>
    </term>
    </xsl:template>
</xsl:stylesheet>