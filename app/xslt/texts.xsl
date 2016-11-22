<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                        xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                        exclude-result-prefixes="xs" 
                        xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
                        version="2.0">
    <xsl:output method="xhtml" encoding="UTF-8" indent="no"/>
    <!-- Header --><!--
    <xsl:template match="/text">
        <xsl:apply-templates />   
    </xsl:template>-->
    
    <xsl:template match="teiHeader">
      <div style="display:none"><xsl:apply-templates/></div>
    </xsl:template>
    
    <xsl:template match="text">
        <div class="tx-innerText">
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
            <xsl:attribute name="id"><xsl:value-of select="concat('tx-pb','_',./@n)"/></xsl:attribute>
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
            <xsl:variable name="ana" select="./@ana"/>
            <xsl:attribute name="class"><xsl:value-of select="./@ana"/></xsl:attribute>
            <xsl:attribute name="id" select=" concat(./@ana,'_',count(preceding::choice[@ana eq $ana])+1)"/>
            <a>
                <xsl:attribute name="title"><xsl:value-of select="./@ana"/> : <xsl:value-of select="./sic/data(.)"/></xsl:attribute>
                <xsl:value-of select="./corr/data(.)"/>
                <i class="glyphicon glyphicon-comment InText" style="display: none;"/>
            </a>            
            
        </span>
    </xsl:template>
    <xsl:template match="quote">
        <span>
            <xsl:variable name="type" select="./@type"/>
            <xsl:attribute name="class"><xsl:value-of select="./@type"/></xsl:attribute>
            <xsl:attribute name="id" select=" concat(./@type,'_',count(preceding::quote[@type eq $type])+1)"/>
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="hi">
        <span class="tx-high"><xsl:value-of select="."/></span>
    </xsl:template>
    <xsl:template match="div/head">
        <h3 class="tx-head">
            <xsl:attribute name="id" select=" concat('tx-head','_',count(preceding::div/head)+1)"/>
            <xsl:value-of select="."/>
        </h3>
    </xsl:template>
    
</xsl:stylesheet>