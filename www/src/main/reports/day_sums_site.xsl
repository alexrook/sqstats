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
				<style>
					footer {
							margin-top: 30px;
							padding: 15px 30px;
							color: #999;
							text-align: left;
							background-color: #2A2730;
							border-top: 1px solid #e5e5e5;
						}		
											
					footer>ul {
							float:right;
							padding-left: 0px;
							margin-bottom: 20px;
					}
					
					footer>ul li {
						display: inline-block;
					}
					
					.report-params {
						float:right;
					}

					.param-value {
						display: inline;
						font-size: 115%;
						font-weight: 700;
						color: blue;
						line-height: 1;
						text-align: center;
						white-space: nowrap;
						vertical-align: baseline;
					}
				</style>

            </head>
            <body>
				<ol class="breadcrumb">
					 <li><a href="#">На главную</a></li>
					 <li>
						<a href="day_sums">Итоги по дням</a>
					 </li>
					 <li class="active"><xsl:value-of select='report/meta/description'/></li>
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
						<li><a href="https://github.com/alexrook/sqstats">GitHub</a></li>
						<li><a href="../about/">About</a></li>
					</ul>
					<p>2015 VKEK IT Depth</p>
				</footer>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match='column'>
        <div class="row">
            <div class="col-lg-12">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Cайт</th> 
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
                            <th>
								<xsl:value-of select="sum(row/bytes)"/>
							</th> 
                            <th>
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
		<xsl:variable name="date" select="substring-before(day,'T')"/>
		<xsl:variable name="site" select='site'/>
		<xsl:variable name="bytes" select='bytes'/>
        <tr>
            <td>
				<a>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('перейти к ', $site)"/>
					</xsl:attribute>
					<xsl:attribute name="href">
						<xsl:value-of
									  select="concat('http://',$site)"/>
					</xsl:attribute>
					<xsl:value-of select='$site'/>
				</a>
				
			</td>
            <td>            
                <xsl:value-of select='duration'/>
            </td>
            <td>            
                <xsl:value-of select='$bytes'/>
            </td>
            <td>            
                <xsl:value-of select='conn_count'/>
            </td>
        </tr>
    </xsl:template>
	
	<xsl:template match='entry'>
		<li>
			param <strong class="param-value"><xsl:value-of select='value/name'/></strong>
			=
			<strong class="param-value"><xsl:value-of select='value/value'/></strong> with
			position <strong><xsl:value-of select='value/posInStmt'/></strong> and
			java.sql.Type <strong><xsl:value-of select='value/sqlTypeNum'/></strong>
			 
		</li>
	</xsl:template>
</xsl:stylesheet> 