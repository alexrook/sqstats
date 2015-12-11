<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">
        <html lang="ru">
            <head>
                <meta charset="utf-8"/>
                <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <title>
                    <xsl:value-of select='report/meta/name'/>
                </title>
                <!-- Latest compiled and minified CSS -->
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" 
                      integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" 
                      crossorigin="anonymous"/>

            </head>
            <body>
                <div class="container">
                    <div class="page-header">
                        <h1>
                            <xsl:value-of select='report/meta/name'/>
                            <xsl:text> </xsl:text> 
                            <small>
                                <xsl:value-of select='report/meta/description'/>
                            </small>
                        </h1>
                        <p>
                            <strong>Statement: </strong> 
                            <xsl:value-of select='report/meta/statement'/>
                        </p>
                        <p>
                            <strong>Generation date: </strong> 
                            <xsl:value-of select='report/meta/genDate'/>
                        </p>
                    </div>
                    <xsl:apply-templates select='report/resultset/column'/>
        

                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match='column'>
        <div class="row">
            <div class="col-md-12">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>day</th> 
                            <th>duration</th> 
                            <th>bytes</th> 
                            <th>Connection count</th> 
                        </tr> 
                    </thead>
                    <tbody>
                        <xsl:apply-templates select='row'/>
                    </tbody>
                </table>
            </div>
        </div>
    </xsl:template>
    <xsl:template match='row'>
        <tr>
            <td>            
                <xsl:value-of select='day'/>
            </td>
            <td>            
                <xsl:value-of select='duration'/>
            </td>
            <td>            
                <xsl:value-of select='bytes'/>
            </td>
            <td>            
                <xsl:value-of select='conn_count'/>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet> 
