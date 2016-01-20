<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output omit-xml-declaration="yes" method="html"/>
    
    <xsl:template match='/'>
        <table class="table table-striped"> 
            <thead> 
                <tr> 
                    <th>Report Name</th> 
                    <th>Statement</th> 
                    <th>
                        Params
                    </th> 
                    <th>    
                        Error?
                    </th> 
                </tr> 
            </thead> 
            <tbody> 
                <xsl:apply-templates select='map-wrapper/map/entry'/>
            </tbody> 
        </table>
    </xsl:template>
    
    <xsl:template match='entry'>
        
        <tr> 
            <xsl:if test="value/meta/error">
                <xsl:attribute name="class">
                    danger
                </xsl:attribute>
            </xsl:if>
            <td class="col-md-1">
                <xsl:value-of select='key'/>
            </td> 
            <td class="col-md-3">
                    <code>
                        <xsl:value-of select='value/meta/statement'/>
                    </code>
            </td> 
            <td class="col-md-5">
                <xsl:apply-templates select="value/meta/params"/>
            </td> 
            <td class="col-md-1">
                <xsl:choose>
                    <xsl:when test="value/meta/error">
                        <small>
                            <xsl:value-of select='value/meta/error/msg'/>
                        </small>
                    </xsl:when>
                    <!--xsl:otherwise>
                        <span class="glyphicon glyphicon-ok"></span>
                    </xsl:otherwise-->
                </xsl:choose>
            </td> 
        </tr> 
    </xsl:template>
    
    <xsl:template match='params'>
        <ul>
            <xsl:for-each select="entry">
                <li>
                    Param name=<var>
                        <xsl:value-of select='value/name'/>
                    </var>,
                    posInStmt=<var>
                        <xsl:value-of select='value/posInStmt'/>
                    </var>,
                    sqlTypeNum=<var>
                        <xsl:value-of select='value/sqlTypeNum'/>
                    </var>,
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <!--xsl:template match='params'>
        <table class="table table-condensed">
            <xsl:for-each select="entry">
                <tr>
                    <td>
                        <var>
                            <xsl:value-of select='value/posInStmt'/>
                        </var>
                    </td>
                    <td>
                        <var>
                            <xsl:value-of select='value/name'/>
                        </var>
                    </td>
                    <td>
                        <var>
                            <xsl:value-of select='value/sqlTypeNum'/>
                        </var>
                    </td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template-->
    
</xsl:stylesheet> 
