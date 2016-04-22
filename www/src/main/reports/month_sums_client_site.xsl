<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">
        <xsl:variable name="date" select="substring-before(report/resultset/column/row/month,'T')"/>
        <html lang="ru">
            <head>
                <meta charset="utf-8"/>
                <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <title>
                    <xsl:value-of select='report/meta/name'/>
                </title>
                <!-- Latest compiled and minified CSS -->
                <link rel="stylesheet" href="/css/bootstrap/336/css/bootstrap.min.css"/>
                <link rel="stylesheet" href="../../css/main.css"/>
				
                <script src="/js/jquery/214/jquery.min.js"></script>
                <script src="/js/numeral/153/numeral.min.js"></script>
                <script src="/js/numeral/153/languages.min.js"></script>
                <script src="/js/punycode/140/punycode.min.js"></script>
                <script src="/js/tablesorter/1/jquery.tablesorter.min.js"></script>
                <script src="../../js/main.js"></script>
				
            </head>
            <body>
                <ol class="breadcrumb">
                    <li>
                        <a href="../../">На главную</a>
                    </li>
                    <li>
                        <a href="month_sums">Итоги по месяцам</a>
                    </li>
                    <li>
                        <a>
                            <xsl:attribute name="title">
                                <xsl:value-of select="concat('итоги за месяц начиная с ',$date,' по клиентам')"/>
                            </xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="concat('month_sums_client?month=',$date)"/>
                            </xsl:attribute>
                            Итоги за месяц начиная с <xsl:value-of select="$date"/>
                        </a>
						
                    </li>
                    <li class="active">
                        <xsl:value-of select='report/meta/description'/>
                    </li>
                </ol>
                <div class="container">
                    <div class="page-header">
                        <h1>
                            <xsl:value-of select='report/meta/name'/>
                            <xsl:text> </xsl:text> 
                            <small>
                                <xsl:value-of select='report/meta/description'/>
                            </small>
                        </h1>
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <p>
                                    <strong>Statement: </strong> 
                                    <xsl:value-of select='report/meta/statement'/>
                                </p>
                                <p>
                                    <strong>Statement params:</strong>
                                </p>
                                <ul>
                                    <xsl:apply-templates select='report/meta/params/entry'/>
                                </ul>
							
                                <p>
                                    <strong>Generation timestamp: </strong> 
                                    <xsl:value-of select='report/meta/genDate'/>
                                </p>
                            </div>
                        </div>
												
                    </div>
                    <xsl:apply-templates select='report/resultset/column'/>
                </div>
                <footer>
                    <ul>
                        <li>
                            <a href="https://github.com/alexrook/sqstats">GitHub</a>
                        </li>
                        <li>
                            <a href="../../about.html">About</a>
                        </li>
                    </ul>
                    <p>2015 VKEK IT Dept</p>
                </footer>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match='column'>
        <div class="row">
            <div class="col-lg-12">
                <table class="table table-striped" id="reportTable">
                    <thead>
                        <tr>
                            <th>Сайт</th> 
                            <th>duration</th> 
                            <th>bytes</th> 
                            <th>Число соединений</th> 
                        </tr> 
                    </thead>
                    <tfoot>
                        <tr class="info">
                            <th>
                                Total:
                                <xsl:value-of select="count(row/site)"/>
                                sites
                            </th> 
                            <th></th> 
                            <th class="bytes">
                                <xsl:value-of select="sum(row/bytes)"/>
                            </th> 
                            <th class="conn_count">
                                <xsl:value-of select="sum(row/conn_count)"/>
                            </th> 
                        </tr> 
                    </tfoot>
                    <tbody>
                        <xsl:apply-templates select='row'/>
                    </tbody>
                </table>
            </div>
        </div>
    </xsl:template>
	
    <xsl:template match='row'>
        <xsl:variable name="bytes" select='bytes'/>
        <xsl:variable name="site" select='site'/>
        <tr>
            <td>
                <a>
                    <xsl:attribute name="class">
                        <xsl:text>out-link</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of
                            select="concat('http://',$site)"/>
                    </xsl:attribute>
                    <xsl:value-of select='$site'/>
                </a>
            </td>
            <td class="duration">            
                <xsl:value-of select='duration'/>
            </td>
            <td class="bytes">            
                <xsl:value-of select='$bytes'/>
            </td>
            <td class="conn_count">            
                <xsl:value-of select='conn_count'/>
            </td>
        </tr>
    </xsl:template>
	
    <xsl:template match='entry'>
        <li>
            param <strong class="param-value">
                <xsl:value-of select='value/name'/>
            </strong>
            =
            <strong class="param-value">
                <xsl:value-of select='value/value'/>
            </strong> with
            position <strong>
                <xsl:value-of select='value/posInStmt'/>
            </strong> and
            java.sql.Type <strong>
                <xsl:value-of select='value/sqlTypeNum'/>
            </strong>
			 
        </li>
    </xsl:template>
	
</xsl:stylesheet> 
