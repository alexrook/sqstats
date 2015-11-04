<xsl:stylesheet version="2.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sqstats="uri:sqstats:reports">
 <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <sqstats:meta>
    <name e="x">some report name
        <b>ddd</b>
    </name>
    <desc>some report desc</desc>
  </sqstats:meta>

   <xsl:param name="pDate" select="'dddd'" sqstats:desc="bla bla bla tra" sqstats:type="'String'" />
   
   
   <xsl:template match="/">
 
     <xsl:call-template name="some">
      <xsl:with-param name="pDate" select="$pDate"/>
     </xsl:call-template>

   </xsl:template>

    <xsl:template  name="some">
       <xsl:param name="pDate" select="'eee'"/>
       <result>
          <down>
             <xsl:value-of select="document('http://localhost:8080/p1t.xml')"/>
          </down>
          <param>
             <xsl:value-of select="$pDate"/>
          </param>
          <xsl:apply-templates select="document('http://localhost:8080/s.xml')/*"/>
       </result>
    </xsl:template>

    <xsl:template  match="*">
               <xsl:value-of select="."/>
    </xsl:template>
  
</xsl:stylesheet>
