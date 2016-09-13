<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                        xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                        exclude-result-prefixes="xs" 
                        xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
                        version="2.0">
    <xsl:output method="xhtml" encoding="UTF-8" indent="no"/>
    <!-- Header -->
    <xsl:template match="/">
        <xsl:apply-templates />   
    </xsl:template>
    <xsl:template match="teiHeader">
        <div class="header">
            <xsl:value-of select="//fileDesc/sourceDesc/bibl/title[@type = 'short']"/>
        </div>
    </xsl:template>
    
    <!-- ### Text Darstellung ###-->
    
    <xsl:template match="text">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="text/body/div">
        <div class="sample whiteBorder">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="div/div">
        <div class="sample-inner">
            <xsl:apply-templates/>
        </div>
        <div class="NAV_line"/>
    </xsl:template>
    <xsl:template match="sp">
        <div class="speaker">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="p">
        <span class="paragraph">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="lb">
        <br/>
    </xsl:template>
    <xsl:template match="head">
    <div class="headline">
        <xsl:apply-templates/>
    </div>
    </xsl:template>
</xsl:stylesheet>