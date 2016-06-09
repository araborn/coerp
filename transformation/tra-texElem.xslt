<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:coerp="http://coerp.uni-koeln.de/schema/coerp"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output omit-xml-declaration="yes" indent="yes"/>
    
    <xsl:template match="coerp:bible">       
        <quote>
            <xsl:attribute name="type">biblical</xsl:attribute>
            <xsl:attribute name="ana"><xsl:value-of select="@ref"/></xsl:attribute>
            <xsl:apply-templates />
        </quote>                
    </xsl:template>
    <xsl:template match="coerp:psalm">       
        <quote>
            <xsl:attribute name="type">psalm</xsl:attribute>
            <xsl:attribute name="ana"><xsl:value-of select="@ref"/></xsl:attribute>
            <xsl:apply-templates />
        </quote>                
    </xsl:template>
    
    <xsl:template match="coerp:bible/text()">        
        <xsl:analyze-string select="." regex="&#xA;">
            <xsl:matching-substring>
                <lb/><xsl:text>&#xa;</xsl:text>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>        
        </xsl:analyze-string>        
    </xsl:template>
    
    <xsl:template match="//coerp:comment">
        <choice><xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute><sic><xsl:value-of select="@reading"/></sic><corr><xsl:value-of select="text()"/></corr></choice></xsl:template>
    
    <xsl:template match="//coerp:sup">
        <high rend="high"><xsl:value-of select="."/></high>
    </xsl:template>
    
    <xsl:template match="coerp:pb">     
        <xsl:variable name="amount" select=" count(preceding::coerp:pb)+1"></xsl:variable>
        
        <pb>
            <xsl:attribute name="n" select="$amount"/>
            <xsl:if test="preceding-sibling::coerp:fol"><xsl:attribute name="xml:id" select="preceding-sibling::coerp:fol/@n/data(.)"></xsl:attribute></xsl:if>
        </pb>
    </xsl:template>
    
    <xsl:template match="//coerp:head">
        <head><xsl:value-of select="text()"/></head>        
    </xsl:template>
    
</xsl:stylesheet>