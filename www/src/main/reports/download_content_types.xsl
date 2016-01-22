<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output omit-xml-declaration="yes" method="html"/>
    
    <xsl:template match='/'>
        <table class="table table-striped table-bordered"> 
            <caption>
                <span class="label label-info pull-right">
                    Download Content Types
                </span>
            </caption>
            <thead> 
                <tr> 
                    <th>Content Type</th> 
                    <th>Description</th> 
                </tr> 
            </thead> 
            <tbody> 
                <xsl:apply-templates select='report/resultset/column/row'/>
            </tbody> 
        </table>
    </xsl:template>
    
    <xsl:template match='row'>
        <tr> 
            <td class="col-md-4">
                <xsl:value-of select='value'/>
            </td> 
            
            <td class="col-md-6">
                <xsl:apply-templates select='description'/>
            </td> 
        </tr>
    </xsl:template>
    
</xsl:stylesheet> 
