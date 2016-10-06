<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8" version="1.0" omit-xml-declaration="no" indent="yes"/>
    
    <xsl:template match="/">
        <authors>
            <xsl:apply-templates/>
        </authors>
    </xsl:template>
    <xsl:template match="./term">
        
            <author>
                <xsl:attribute name="key"><xsl:value-of select="./author/@key"/></xsl:attribute>
                <orig><xsl:value-of select="./orig/data(.)"/></orig>
                <correct><xsl:value-of select="./author/data(.)"/></correct>
                <bio_info>Text</bio_info>
            </author>
        
    </xsl:template>
</xsl:stylesheet>