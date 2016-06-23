<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:coerp="http://coerp.uni-koeln.de/schema/coerp"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs coerp tei"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8" version="1.0"  indent="yes"/>
    
    <xsl:template match="//coerp:sampleN"></xsl:template>
    
    <xsl:template match="coerp:bible">       
        <quote>
            <xsl:attribute name="type">biblical</xsl:attribute>
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
    
    <xsl:template match="coerp:psalm">       
        <quote>
            <xsl:attribute name="type">psalm</xsl:attribute>
            <xsl:attribute name="ana"><xsl:value-of select="@ref"/></xsl:attribute>
            <xsl:apply-templates />
        </quote>                
    </xsl:template>
    <xsl:template match="coerp:psalm/text()">        
        <xsl:analyze-string select="." regex="&#xA;">
            <xsl:matching-substring>
                <lb/><xsl:text>&#xa;</xsl:text>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>        
        </xsl:analyze-string>        
    </xsl:template>
    
    <xsl:template match="coerp:foreign">       
        <foreign>            
            <xsl:attribute name="lang">
                <xsl:variable name="entry" select="@language"/>
                <xsl:choose>
                    <xsl:when test="$entry = 'latin'"><xsl:text>lat</xsl:text></xsl:when>
                </xsl:choose>                
            </xsl:attribute>
            <xsl:apply-templates />
        </foreign>                
    </xsl:template>   
    <xsl:template match="coerp:foreign/text()">        
        <xsl:analyze-string select="." regex="&#xA;">
            <xsl:matching-substring>
                <lb/><xsl:text>&#xa;</xsl:text>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>        
        </xsl:analyze-string>        
    </xsl:template>
    
    <xsl:template match="coerp:foreign_omitted">       
        <foreign>            
            <xsl:attribute name="lang">
                <xsl:variable name="entry" select="@language"/>
                <xsl:choose>
                    <xsl:when test="$entry = 'latin'"><xsl:text>lat</xsl:text></xsl:when>
                    <xsl:when test="$entry = 'greek'"><xsl:text>gre</xsl:text></xsl:when>
                    <xsl:when test="$entry = 'hebrew'"><xsl:text>heb</xsl:text></xsl:when>
                </xsl:choose>                
            </xsl:attribute>
            <xsl:attribute name="ana"><xsl:text>omitted</xsl:text></xsl:attribute>
            <!-- ## Elemente ohne Text
            <xsl:apply-templates />
            -->
        </foreign>                
    </xsl:template>  
    
    <xsl:template match="//coerp:comment">
        <choice><xsl:attribute name="ana"><xsl:value-of select="@type"/></xsl:attribute><sic><xsl:value-of select="@reading"/></sic><corr><xsl:value-of select="text()"/></corr></choice></xsl:template>
    
    <xsl:template match="//coerp:sup">
        <hi rend="high"><xsl:value-of select="."/></hi>
    </xsl:template>
    
    <xsl:template match="coerp:pb">     
        <xsl:variable name="amount" select=" count(preceding::coerp:pb)+1"></xsl:variable>
        
        <pb>
            <xsl:attribute name="n" select="$amount"/>
                <xsl:if test=" preceding-sibling::*[1]/@n">   
                    <xsl:variable name="xmlid" select="string(preceding-sibling::*[1]/@n/data(.))"/>
                    <xsl:attribute name="xml:id" select=" replace($xmlid,' ','-') "></xsl:attribute>
                    <!--  replace(preceding-sibling::*[1]/@n,' ','-') " -->
                </xsl:if>            
        </pb>
        
        <xsl:if test="./@pgn">
            <fw type="pagenum">
                <xsl:value-of select="./@pgn/data(.)"/>
            </fw>
        </xsl:if>
        
    </xsl:template>
    
    
    <xsl:template match="//coerp:head">
        <head><xsl:value-of select="text()"/></head>        
    </xsl:template>
    
</xsl:stylesheet>