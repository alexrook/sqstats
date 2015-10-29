<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes"/>

    <xsl:template match="/*">

	<params>
	    <xsl:apply-templates select="*[local-name()='param']"/>	
	</params>

    </xsl:template>

    <xsl:template match="xsl:param">
	    	    <param>
			<name>
			    <xsl:value-of select="@name"/>
			</name>
			<def-value>
			    <xsl:value-of select="@select"/>
			</def-value>
			<desc>
			    <xsl:value-of select="@*[local-name()='desc']"/>
			</desc>
		    </param>
    </xsl:template>

</xsl:stylesheet>
