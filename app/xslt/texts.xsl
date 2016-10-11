<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                        xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                        exclude-result-prefixes="xs" 
                        xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
                        version="2.0">
    <xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>
    <!-- Header -->
    <xsl:template match="/">
        <xsl:apply-templates />   
    </xsl:template>
    
    <xsl:template match="teiHeader">
        <div class="header">
            <xsl:value-of select=".//fileDesc/sourceDesc/bibl/title[@type = 'short']"/>
        </div>
    </xsl:template>
    
    <xsl:template match="text">
        <div class="whiteBorder">
            <xsl:apply-templates select="child::node()"/>     
        </div>
    </xsl:template>
    
    <xsl:template match="body/div">
        <div class="tx-sample">
            <xsl:attribute name="id"><xsl:value-of select="./@xml:id"/></xsl:attribute>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- ### Allgemeine Inhalte ###-->
    
    <xsl:template match="pb">
        <p class="tx-pb">
           <xsl:attribute name="id"><xsl:value-of select="./@n"/></xsl:attribute>
            <xsl:value-of select="./@n"/>
        </p>
    </xsl:template>
    <xsl:template match="fw[@type ='pageNum']">
        <p class="tx-fw"><xsl:value-of select="."/></p>
    </xsl:template>
    <xsl:template match="lb">
        <br/>
    </xsl:template>
    
    <xsl:template match="choice">
        <span>
            <xsl:attribute name="class"><xsl:value-of select="./@ana"/></xsl:attribute>
            <a>
                <xsl:attribute name="title"><xsl:value-of select="./sic/data(.)"/></xsl:attribute>
                <xsl:value-of select="./corr/data(.)"/>
            </a>            
        </span>
    </xsl:template>
    <xsl:template match="quote">
        <span>
            <xsl:attribute name="class"><xsl:value-of select="./@type"/></xsl:attribute>
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="hi">
        <span class="tx-high"><xsl:value-of select="."/></span>
    </xsl:template>
    <xsl:template match="div/head">
        <h3 class="tx-head"><xsl:value-of select="."/></h3>
    </xsl:template>
    
</xsl:stylesheet>