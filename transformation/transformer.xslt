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
                    <title><xsl:value-of select=".//coerp:short_title/data(.)"/></title>
                    <author><xsl:value-of select=".//coerp:author/data(.)"/></author>
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
                    <p>Text-Resource des COERP-Projekts</p>
                </publicationStmt>
                <sourceDesc>
                    <bibl>
                        <author><xsl:value-of select=".//coerp:author/data(.)"/></author>
                        <!-- Verknüpfung mit Kommentar Änderug muss noch hergestellt werden-->
                        <title type="main"><xsl:value-of select=".//coerp:title/data(.)"/></title>
                        <title type="short"><xsl:value-of select=".//coerp:short_title/data(.)"/></title>
                        <date><!--Under Construction--></date>
                        <idno>
                            <xsl:attribute name="type" select="substring-before(.//coerp:source/data(.),' ')"/>
                            <xsl:value-of select="substring-after(.//coerp:source/data(.),' ')"/>
                        </idno>
                        <note type="lists">
                            <list type="format">
                                <item><term type="format_original"><xsl:value-of select=".//coerp:format_original/data(.)"/></term></item>
                                <xsl:if test=".//coerp:format/coerp:pagination_erratic/@exists/data(.) eq 'true'"><item type="pagination_erratic"><term>true</term></item></xsl:if>
                                <xsl:if test="empty(.//coerp:format/coerp:contains/data(.) ) eq false()"><item><term><xsl:attribute name="type">contains</xsl:attribute><xsl:attribute name="subtype" select=".//coerp:format/coerp:contains/@type/data(.)"></xsl:attribute> <xsl:value-of select=".//coerp:format/coerp:contains/data(.)"/></term></item></xsl:if>
                                <xsl:if test=".//coerp:format/coerp:satb_scores/@exists/data(.) eq 'true'"><item><term type="satb_scores">true</term></item></xsl:if>
                            </list>
                            <list type="text_body">
                                <xsl:if test=".//coerp:text_body/coerp:illustrations/@exist/data(.) = 'true'"><item><term type="illustrations"><xsl:attribute name="subtype" select=".//coerp:text_body/illustrations/@type/data(.)"></xsl:attribute>true</term></item></xsl:if>
                                <xsl:for-each select=".//coerp:text_body/coerp:elements/coerp:style">
                                    <item><term type="elements"><xsl:value-of select="."/></term></item>
                                </xsl:for-each>
                                <xsl:if test=".//coerp:text_body/coerp:empty_page/@exists/data(.) eq 'true'"><item><term type="empty_page">true</term></item></xsl:if>
                                <xsl:if test=".//coerp:text_body/coerp:footnotes/@exists/data(.) eq 'true'"><item><term type="footnotes">true</term></item></xsl:if> 
                                <xsl:if test=".//coerp:comments_references/@exists/data(.) eq 'true'"><item><term type="comments_references">true</term></item></xsl:if>
                            </list>
                        </note>
                    </bibl>
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
        <choice><xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute><sic><xsl:value-of select="@reading"/></sic><corr><xsl:value-of select="text()"/></corr></choice></xsl:template>
    
    <xsl:template match=".//coerp:sup">
        <high rend="high"><xsl:value-of select="."/></high>
    </xsl:template>
    
    <xsl:template match="coerp:pb">     
        <xsl:variable name="amount" select=" count(preceding::coerp:pb)+1"></xsl:variable>
        
        <pb>
            <xsl:attribute name="n" select="$amount"/>
            <xsl:if test="preceding-sibling::coerp:fol"><xsl:attribute name="xml:id" select="preceding-sibling::coerp:fol/@n/data(.)"></xsl:attribute></xsl:if>
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