<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="/">
        <html lang="ru">
            <head>
                <meta charset="utf-8"/>
                <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <title>
                    <xsl:value-of select="report/meta/name"/>
                </title>
                <!-- Latest compiled and minified CSS -->
                <link rel="stylesheet" href="/css/bootstrap/336/css/bootstrap.min.css"/>
                <link rel="stylesheet" href="../../css/main.css"/>

                <script src="/js/jquery/214/jquery.min.js"/>
                <script src="/js/numeral/153/numeral.min.js"/>
                <script src="/js/numeral/153/languages.min.js"/>
                <script src="/js/punycode/140/punycode.min.js"/>
                <script src="/js/tablesorter/1/jquery.tablesorter.min.js"></script>
                <script src="../../js/main.js"/>

                <style>
                    td .nav a {
                    padding:3px;
                    }
                    .glyphicon {
                        line-height: inherit;
                    }
                </style>

            </head>
            <body>
                <ol class="breadcrumb">
                    <li>
                        <a href="../../">На главную</a>
                    </li>
                    <li class="active">
                        <xsl:value-of select="report/meta/description"/>
                    </li>
                </ol>
                <div class="container">
                    <div class="page-header">
                        <h1>
                            <xsl:value-of select="report/meta/name"/>
                            <xsl:text> </xsl:text>
                            <small>
                                <xsl:value-of select="report/meta/description"/>
                            </small>
                        </h1>
                        <p>
                            <strong>Statement:</strong>
                            <xsl:value-of select="report/meta/statement"/>
                        </p>
                        <p>
                            <strong>Generation date: </strong>
                            <xsl:value-of select="report/meta/genDate"/>
                        </p>
                    </div>
                    <xsl:apply-templates select="report/resultset/column"/>


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
                    <p>2016 VKEK IT Dept</p>
                </footer>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="column">
        <div class="row">
            <div class="col-lg-12">
                <table class="table table-striped" id="reportTable">
                    <thead>
                        <tr>
                            <th>Год</th>
                            <th>duration</th>
                            <th>bytes</th>
                            <th>Число соединений</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr class="info">
                            <th>
                                Total:
                                <xsl:value-of select="count(row/year)"/>
                                years
                            </th>
                            <th/>
                            <th class="bytes">
                                <xsl:value-of select="sum(row/bytes)"/>
                            </th>
                            <th class="conn_count">
                                <xsl:value-of select="sum(row/conn_count)"/>
                            </th>
                        </tr>
                    </tfoot>
                    <tbody>
                        <xsl:apply-templates select="row"/>
                    </tbody>
                </table>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="row">
       
	<xsl:variable name="vyear" select="year"/>
        <xsl:variable name="bytes" select="bytes"/>
        <tr>
            <td>
                <ul class="nav nav-pills">
                    <li><xsl:value-of select="$vyear"/></li>
                    <li>
                        <a>
                            <xsl:attribute name="title">
                                <xsl:value-of select="concat('итоги за ',$vyear,' год по пользователям')"/>
                            </xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat('year_sums_client?year=',$vyear)"/>
                            </xsl:attribute>
                            <span class="glyphicon glyphicon-user"></span>
                        </a>
                    </li>
                    <li>
                        <a>
                            <xsl:attribute name="title">
                                <xsl:value-of select="concat('загрузки за ',$vyear,' год')"/>
                            </xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat('year_client_download?year=',$vyear)"/>
                            </xsl:attribute>
                            <span class="glyphicon glyphicon-cloud-download"></span>
                        </a>
                    </li>
                </ul>

            </td>
            <td class="duration">
                <xsl:value-of select="duration"/>
            </td>
            <td class="bytes">
                <xsl:attribute name="title">
                        <xsl:value-of select="concat('итого за ',$vyear, ' год по сайтам')"/>
                </xsl:attribute>
                <xsl:value-of select="$bytes"/>
            </td>
            <td class="conn_count">
                <xsl:value-of select="conn_count"/>
            </td>

        </tr>
    </xsl:template>
</xsl:stylesheet>
