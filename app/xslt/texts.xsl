<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output method="xhtml" encoding="UTF-8" indent="no"/>
    <!-- Header -->
    <xsl:template match="text_profile">
        <xsl:choose>
            <xsl:when test="/text_layout[@exists='true']">
                <div class="TextTooltip" id="ToolTextLayout">Text Layout</div>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>