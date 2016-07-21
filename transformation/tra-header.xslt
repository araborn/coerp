<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:coerp="http://coerp.uni-koeln.de/schema/coerp"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs coerp tei"
    version="2.0">
    <xsl:output omit-xml-declaration="no" indent="yes"/>
    
    <xsl:template name="header" match="//coerp:coerp_header">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title><xsl:value-of select=".//coerp:short_title/data(.)"/></title>
                   
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
                        <xsl:if test=".//coerp:translator/data(.)">
                            <author role="translator"><xsl:value-of select=".//coerp:translator/data(.)"/></author>
                        </xsl:if>
                        <!-- Verknüpfung mit Kommentar Änderug muss noch hergestellt werden-->
                        <title type="main"><xsl:value-of select=".//coerp:title/data(.)"/></title>
                        <title type="short"><xsl:value-of select=".//coerp:short_title/data(.)"/></title>
                        <date>
                            <xsl:variable name="from" select=".//coerp:year/coerp:from/data(.)"/>
                            <xsl:variable name="to" select=".//coerp:year/coerp:to/data(.)"/>
                            <xsl:if test=" $from != $to">
                                <xsl:attribute name="from" ><xsl:value-of select="$from"/></xsl:attribute>
                                <xsl:attribute name="to" ><xsl:value-of select="$to"/></xsl:attribute>
                                <xsl:value-of select="$from"/> - <xsl:value-of select="$to"/>
                            </xsl:if>
                            <xsl:if test=" $from = $to">
                                <xsl:attribute name="when" ><xsl:value-of select="$from"/></xsl:attribute>                                
                                <xsl:value-of select="$from"/>
                            </xsl:if>
                        </date>
                        <date type="this_edition">
                            <xsl:variable name="from" select=".//coerp:this_edition/coerp:from/data(.)"/>
                            <xsl:variable name="to" select=".//coerp:this_edition/coerp:to/data(.)"/>
                            <xsl:if test=" $from != $to">
                                <xsl:attribute name="from" ><xsl:value-of select="$from"/></xsl:attribute>
                                <xsl:attribute name="to" ><xsl:value-of select="$to"/></xsl:attribute>
                                <xsl:value-of select="$from"/> - <xsl:value-of select="$to"/>
                            </xsl:if>
                            <xsl:if test=" $from = $to">
                                <xsl:attribute name="when" ><xsl:value-of select="$from"/></xsl:attribute>                                
                                <xsl:value-of select="$from"/>
                            </xsl:if>
                        </date>
                        <idno>
                            <xsl:attribute name="type" select="substring-before(./coerp:text_profile/coerp:source/data(.),' ')"/>
                            <xsl:value-of select="substring-after(./coerp:text_profile/coerp:source/data(.),' ')"/>
                        </idno>
                        <note type="genre">
                            <xsl:attribute name="subtype"><xsl:value-of select=".//coerp:genre/@key/data(.)"/></xsl:attribute>
                            <xsl:value-of select=".//coerp:genre/data(.)"/>
                        </note>
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
    
    
</xsl:stylesheet>