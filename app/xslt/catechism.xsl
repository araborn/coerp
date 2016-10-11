<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs" 
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    version="2.0">
    <xsl:import href="texts.xsl"/>
    <xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>
           <xsl:template match="sp">
       <div class="tx-speaker">
           <xsl:apply-templates/>
       </div>
   </xsl:template>
    
   
</xsl:stylesheet>