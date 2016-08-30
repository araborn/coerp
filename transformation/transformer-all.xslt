<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:coerp="http://coerp.uni-koeln.de/schema/coerp"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs coerp "
    version="2.0">
    <xsl:import href="tra-header.xslt"/>
    <xsl:import href="tra-texElem.xslt"/>
    <xsl:output method="xml" encoding="UTF-8" version="1.0" omit-xml-declaration="no" indent="yes"/>
    <!--Identity template, kopiert Elemente und Attribute, wo keine spezifischere Regel folgt -->

    <xsl:template match="/">
        <xsl:apply-templates select="coerp:coerp"/>
    </xsl:template>
    <xsl:template match="coerp:coerp">
        
        <TEI>                       
            <xsl:attribute name="xml:id"><xsl:value-of select="substring-before(substring-after(base-uri(),'old/'),'.xml')"/></xsl:attribute>
            <!--
            <xsl:namespace name="tei"><xsl:text>http://www.tei-c.org/ns/1.0</xsl:text></xsl:namespace>
            -->
            <xsl:text>
            <?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
            <?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?></xsl:text>
            
            <xsl:apply-templates/>
        </TEI>
    </xsl:template>
    
    
    <xsl:template match="//coerp:text">       
        <text>
            <body>               
                <xsl:call-template name="sample"/>
            </body>
        </text>
    </xsl:template>
    <xsl:template match="coerp:sample" name="sample">
        <div>
            <xsl:attribute name="xml:id">
                <xsl:text>sample</xsl:text><xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:call-template name="marktext"/>     
            <!--
            <xsl:apply-templates   select="child::node()"/>
            -->
         </div>
    </xsl:template>
    
    <xsl:template name="marktext">
        <xsl:for-each select=" //coerp:head">
            <div>
                <xsl:variable name="header" select="."/>
                <xsl:apply-templates select="."/>
                <p>
                    
                    <xsl:apply-templates select="following::node()[ preceding-sibling::coerp:head[1] = $header]"  /><lb/>
                </p>
                <!--
            <xsl:apply-templates select="child::node()"/>-->
            </div>
        </xsl:for-each>        
    </xsl:template>
    

    
    
    <xsl:template name="text" match="coerp:text//text()">
        <xsl:analyze-string select="." regex="&#xA;">
            <xsl:matching-substring>
                <lb/><xsl:text>&#xa;</xsl:text>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
</xsl:stylesheet>