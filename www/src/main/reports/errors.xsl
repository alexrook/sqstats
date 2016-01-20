<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output omit-xml-declaration="yes" method="html"/>
    
    <xsl:template match='/'>
        <table class="table"> 
             <thead> 
                <tr> 
                    <th>Report Name</th> 
                    <th>Msg</th> 
                    <th>StackTrace</th> 
                </tr> 
            </thead> 
            <tbody> 
                <xsl:apply-templates select='map-wrapper/map/entry'/>
            </tbody> 
        </table>
    </xsl:template>
    
    <xsl:template match='entry'>
        <tr> 
            <td class="col-md-1">
                <xsl:value-of select='key'/>
            </td> 
            <td class="col-md-1">
                <xsl:value-of select='value/msg'/>
            </td> 
            <td class="col-md-7">
                <textarea class="form-control" readonly="true" palceholder=".col-md-4">
                    <xsl:value-of select='value/stackTrace'/>
                </textarea>
            </td> 
        </tr> 
    </xsl:template>
</xsl:stylesheet> 
