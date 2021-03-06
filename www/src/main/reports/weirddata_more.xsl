<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output omit-xml-declaration="yes" 
                method="text"/>
    <xsl:template match='/'>
        <xsl:apply-templates select='report/resultset/column/row'/>
    </xsl:template>
        
    <xsl:template match='row'>
        <xsl:text>
            <xsl:value-of select='request'/>
        </xsl:text>
    </xsl:template>
    
</xsl:stylesheet> 
