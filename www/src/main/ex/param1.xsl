<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output omit-xml-declaration="yes" indent="yes"/>
 <xsl:strip-space elements="*"/>

 <xsl:param name="pTarget" select="'love'"/>
 <xsl:param name="pReplacement" select="'like'"/>

 <xsl:template match="/*">

  <xsl:call-template name="replace">
   <xsl:with-param name="pPattern" select="$pTarget"/>
   <xsl:with-param name="pRep" select="$pReplacement"/>
  </xsl:call-template>

  <xsl:text>&#xA;</xsl:text>

  <xsl:call-template name="replace"/>

  <xsl:text>&#xA;</xsl:text>

  <xsl:apply-templates select="text()">
   <xsl:with-param name="pPattern" select="$pTarget"/>
   <xsl:with-param name="pRep" select="'adore'"/>
  </xsl:apply-templates>
 </xsl:template>

 <xsl:template match="text()" name="replace">
   <xsl:param name="pText" select="."/>
   <xsl:param name="pPattern" select="'hate'"/>
   <xsl:param name="pRep" select="'disapprove'"/>

   <xsl:if test="string-length($pText) >0">
       <xsl:choose>
        <xsl:when test="not(contains($pText, $pPattern))">
          <xsl:value-of select="$pText"/>
        </xsl:when>
        <xsl:otherwise>
         <xsl:value-of select="substring-before($pText, $pPattern)"/>
         <xsl:value-of select="$pRep"/>

         <xsl:call-template name="replace">
           <xsl:with-param name="pPattern" select="$pPattern"/>
           <xsl:with-param name="pRep" select="$pRep"/>
           <xsl:with-param name="pText" select=
            "substring-after($pText, $pPattern)"/>
         </xsl:call-template>
        </xsl:otherwise>
       </xsl:choose>
   </xsl:if>
 </xsl:template>
</xsl:stylesheet>
