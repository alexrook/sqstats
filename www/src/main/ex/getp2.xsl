<xsl:stylesheet version="2.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes"/>

	<xsl:template match="/*">
		<report>
			<xsl:apply-templates
						select="*[substring-before(name(),
						local-name())='sqstats:']"/>
			<params>
				<xsl:apply-templates select="*[local-name()='param']"/>
			</params>
		</report>
	</xsl:template>

	<xsl:template match="xsl:param">
			<param>
				<name>
					<xsl:value-of select="@name"/>
				</name>
				<def-value>
					<xsl:value-of select="@select"/>
				</def-value>
				<xsl:apply-templates
						select="@*[substring-before(name(),
						local-name())='sqstats:']"/>
			</param>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:element name="{local-name()}">
					<xsl:apply-templates select="@*"/>
					<xsl:apply-templates select="child::node()"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="text()">
			<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="@*">
		<xsl:element name="{local-name()}">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
