<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output omit-xml-declaration="yes" 
                method="html"/>
    
    <xsl:template match='/'>
        <table class="table table-striped table-bordered"> 
            <caption>
                <span class="label label-info pull-right">
                    Site Groups
                </span>
            </caption>
            <thead> 
                <tr> 
                    <th>#</th> 
                    <th>Регулярное выражение</th> 
                    <th>Имя группы</th> 
                    <th>substring?</th> 
                    <th>Описание</th> 
                </tr> 
            </thead> 
            <tbody> 
                <xsl:apply-templates select='report/resultset/column/row'/>
            </tbody> 
        </table>
    </xsl:template>
    
    <xsl:template match='row'>
        <tr> 
            <td class="col-md-1">
                <xsl:value-of select='id'/>
            </td> 
            <td class="col-md-3">
                <xsl:value-of select='regex'/>
            </td> 
            <td class="col-md-2">
                <xsl:apply-templates select='name'/>
            </td> 
            <td class="col-md-1">
                <xsl:apply-templates select='substr'/>
            </td> 
            <td class="col-md-3">
                <xsl:apply-templates select='description'/>
            </td> 
        </tr>
    </xsl:template>
    
</xsl:stylesheet> 
