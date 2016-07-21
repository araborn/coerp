<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:coerp="http://coerp.uni-koeln.de/schema/coerp"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs coerp"
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
            
            
            <xsl:variable name="headertex">
            <xsl:text>
            <?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
            <?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?></xsl:text></xsl:variable>
            <xsl:value-of select="$headertex"/>            
            <xsl:apply-templates/>
        </TEI>
    </xsl:template>
    
    
    <xsl:template match="//coerp:text">       
        <text>
            <body>               
                <xsl:apply-templates/>
            </body>
        </text>
    </xsl:template>
    <xsl:template match="coerp:sample">
        <div>
            <xsl:attribute name="xml:id">
                <xsl:text>sample</xsl:text><xsl:value-of select="@id"/>
            </xsl:attribute>
                       
            <xsl:apply-templates select="child::node()"/>
            
        </div>
    </xsl:template>
    
    <xsl:template match="coerp:speaker">
        <sp><xsl:attribute name="who">
            <xsl:value-of select="@id"/></xsl:attribute>
            <p> <xsl:apply-templates/><lb/></p>            
    </sp>
    </xsl:template>
 
    <xsl:template match="coerp:speaker/text()">
        <xsl:analyze-string select="." regex="&#xA;">
            <xsl:matching-substring>
                <lb/><xsl:text>&#xa;</xsl:text>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    
    
    
    <!--
    <xsl:template match=".//coerp:bible">        
        <note>
            <xsl:attribute name="type">bible_ref</xsl:attribute>
            <xsl:attribute name="target"><xsl:value-of select="@ref"/></xsl:attribute>
            <xsl:for-each select="tokenize(.,'\n')">
                <s><xsl:value-of select="."/></s><xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
        </note>        
    </xsl:template>
    -->

  <!--
    <xsl:template match=".//coerp:coerp_header">
        <teiHeader>
            <xsl:apply-templates  select="@* | node()"/>
        </teiHeader>
    </xsl:template>
    <xsl:template match=".//coerp:text">
        <text>
            <xsl:apply-templates select="@* | node()"/>
        </text>
    </xsl:template>
    <xsl:template match=".//coerp:speaker/text()">
        <sp>
            <xsl:attribute name="who">
                <xsl:value-of select="@id"/></xsl:attribute>
            <p>
                <xsl:analyze-string select="." regex="&#xA;">
                    <xsl:matching-substring>

                        <lb/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select=".">                            
                        </xsl:value-of>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>

            </p>
        </sp>    
    </xsl:template>
    -->
    <!--
    <xsl:template match="node()|@*" mode="inFile">
        <xsl:copy>
            <xsl:apply-templates mode="inFile" select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
  
    <xsl:template match="/">
        <xsl:apply-templates mode="inFile" select=
            "collection('file:///D:/eXist_Projects/COERP_XSLT/old/?select=*.xml;recurse=yes')"/>
    </xsl:template>
 -->
</xsl:stylesheet>