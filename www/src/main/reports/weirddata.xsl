<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output omit-xml-declaration="yes" 
                method="html"/>
    
    <xsl:template match='/'>
        <script language="javascript">
           <xsl:text>
                
                $(function () {
                    $('#weirdData a.hasmorereqdata').click(function (event) {
                       event.preventDefault();
                       var cont= $(event.target).parent(); //span
                       console.log(cont);
                       var url = $(event.target).attr('href');
                       console.log(url);
                       $(cont).load(url);;
                    });
                });
            </xsl:text>
        </script>
         
        <table id="weirdData" class="table table-striped table-bordered"> 
            <caption>
                <span class="label label-info pull-right">
                    Weird Requests Data
                </span>
            </caption>
            <thead> 
                <tr> 
                    <th>#</th> 
                    <th>time</th> 
                    <th>from squid</th> 
                    <th>request</th> 
                    <th>Count</th> 
                </tr> 
            </thead> 
            <tbody> 
                <xsl:apply-templates select='report/resultset/column/row'/>
            </tbody> 
        </table>
    </xsl:template>
    
    <xsl:template match='row'>
        <xsl:variable name="vrequest">
            <xsl:choose>
                <xsl:when  test="hasmorereqdata='true'">
                <span style="max-width:350px; word-wrap:break-word; display:inline-block;">
                    <xsl:value-of select='request'/>
                    ...                  
                    <a class="hasmorereqdata" target='_blank'>
                         <xsl:attribute name="href">
                           <xsl:value-of
                                    select="concat('rs/xslt/weirddata_more?id=',id)"/>
                         </xsl:attribute>
                         load more...
                     </a>
                </span>
                </xsl:when>
                <xsl:otherwise>
                    <span style="max-width:350px; word-wrap:break-word; display:inline-block;">
                        <xsl:value-of select='request'/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr> 
           <td class="col-md-1">
                <xsl:value-of select='id'/>
            </td> 
            <td class="col-md-2">
                <xsl:value-of select='request_date'/>
            </td> 
            <td class="col-md-2">
                <xsl:value-of select='from_squid'/>
            </td> 
            <td class="col-md-4">
            
                <xsl:copy-of select='$vrequest'/>
            </td> 
            <td class="col-md-1">
                <xsl:value-of select='count'/>
            </td> 
        </tr>
    </xsl:template>
    
</xsl:stylesheet> 
