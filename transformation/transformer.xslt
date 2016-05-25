<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:coerp="http://coerp.uni-koeln.de/schema/coerp"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output omit-xml-declaration="yes" indent="yes"/>
    <!--Identity template, kopiert Elemente und Attribute, wo keine spezifischere Regel folgt -->
    
    <xsl:template match="/">
        <xsl:apply-templates select="coerp:coerp"/>
    </xsl:template>
    <xsl:template match="coerp:coerp">
        
        <TEI>
            <xsl:namespace name="tei"><xsl:text>http://www.tei-c.org/ns/1.0</xsl:text></xsl:namespace>
            <xsl:text>
            <?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
            <?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?></xsl:text>
            
            <xsl:apply-templates/>
        </TEI>
    </xsl:template>
    <xsl:template match=".//coerp:coerp_header">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <!-- Einbindung des Titles und des Autors-->
                    
                    <respStmt>
                        <resp>Principal Investigator</resp>                   
                        <name>Prof. Dr. Thomas Kohnen</name>                    
                    </respStmt>
                    <respStmt>
                        <resp>Transcription and Encoding</resp>
                        <name>André von Schledorn</name>                    
                    </respStmt>
                    <respStmt>
                        <resp>Transcription and Encoding</resp>
                        <name>Person 2</name>                    
                    </respStmt>
                    <respStmt>
                        <resp>Transcription and Encoding</resp>
                        <name>Person 3</name>                    
                    </respStmt>
                    <respStmt>
                        <resp>Transcription and Encoding</resp>
                        <name>Person 4</name>                    
                    </respStmt>
                </titleStmt>
                <publicationStmt>
                    
                </publicationStmt>
                <sourceDesc>
                    
                </sourceDesc>
            </fileDesc>
            <profileDesc/>
        </teiHeader>
    </xsl:template>
    
    <xsl:template match=".//coerp:text">       
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
    <!-- ersetzt Zeilenumbrüche durch <lb/> -->
    <xsl:template match="coerp:sampleN">
        
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
    
    <xsl:template match=".//coerp:comment">
        <choice>
            <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
            <sic><xsl:value-of select="@reading"/></sic>
            <corr><xsl:value-of select="text()"/></corr>
        </choice>
    </xsl:template>
    
    <xsl:template match=".//coerp:sup">
        <high rend="high"><xsl:value-of select="."/></high>
    </xsl:template>
    
    <xsl:template match="coerp:pb">     
        <xsl:variable name="amount" select=" count(preceding::coerp:pb)+1"></xsl:variable>
        <pb>
            <xsl:attribute name="n" select="$amount"/>
        </pb>
    </xsl:template>

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