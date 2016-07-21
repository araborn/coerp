<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:coerp="http://coerp.uni-koeln.de/schema/coerp"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs coerp tei"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8" version="1.0"  indent="yes" use-character-maps="cm1"/>
    
    <xsl:character-map name="cm1">
        <xsl:output-character character="&#182;" string="&amp;#182;"/>
    </xsl:character-map>
    
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
        <xsl:choose>
            <xsl:when test="./@pgn and  preceding-sibling::*[1]/@n">
                <fw type="pageNum">
                        <xsl:attribute name="n" select="./@pgn/data(.)"/>                
                        <xsl:variable name="xmlid" select="string(preceding-sibling::*[1]/@n/data(.))"/>                    
                        <xsl:value-of select="$xmlid"/>                          
                        <!--  replace(preceding-sibling::*[1]/@n,' ','-') " -->
                </fw>
            </xsl:when>
            <xsl:when test="./@pgn">
                <fw type="pageNum">
                        <xsl:attribute name="n" select="./@pgn/data(.)"/>                
                </fw>
            </xsl:when>
            <xsl:when test="preceding-sibling::*[1]/@n">
                <fw type="pageNum">
                <xsl:variable name="xmlid" select="string(preceding-sibling::*[1]/@n/data(.))"/>                    
                <xsl:value-of select="$xmlid"/>
                </fw>
            </xsl:when>   
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
        <pb>
            <xsl:attribute name="n" select="$amount"/>                       
        </pb>
        
        
        <!--
        <fw type="pageNum">
            <xsl:if test="./@pgn">                
                    <xsl:attribute name="n" select="./@pgn/data(.)"/>                
            </xsl:if>            
            <xsl:if test=" preceding-sibling::*[1]/@n">   
                <xsl:variable name="xmlid" select="string(preceding-sibling::*[1]/@n/data(.))"/>                    
                <xsl:value-of select="$xmlid"/>                          
            </xsl:if>     
        </fw>
        -->
        
    </xsl:template>
    
    
    <xsl:template match="//coerp:head">
        <head><xsl:value-of select="text()"/></head>        
    </xsl:template>
    
    <xsl:template match="//coerp:superscr">
        <opener><xsl:value-of select="text()"/></opener>
    </xsl:template>
    <xsl:template match="//coerp:subscr">
        <closer><xsl:value-of select="text()"/></closer>
    </xsl:template>
    
</xsl:stylesheet>