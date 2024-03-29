﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns="urn:schemas-microsoft-com:office:spreadsheet"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:user="urn:my-scripts"
  xmlns:o="urn:schemas-microsoft-com:office:office"
  xmlns:x="urn:schemas-microsoft-com:office:excel"
  xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">

  <xsl:template match="/">
    <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
      xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:x="urn:schemas-microsoft-com:office:excel"
      xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
      xmlns:html="http://www.w3.org/TR/REC-html40">
      <xsl:apply-templates/>
    </Workbook>
  </xsl:template>


  <xsl:template match="/*">
    <Worksheet>
      <xsl:attribute name="ss:Name">
        <xsl:value-of select="local-name(/*/*)" />
      </xsl:attribute>
      <Table x:FullColumns="1" x:FullRows="1">
        <Row>
          <xsl:for-each select="*[position() = 1]/*">
            <Cell>
              <Data ss:Type= "String">
                <!--<xsl:value-of select="translate(local-name(), '0x20', ' ')" />-->
                <xsl:value-of select="local-name()" />
              </Data>
            </Cell>
          </xsl:for-each>
        </Row>
        <xsl:apply-templates/>
      </Table>
    </Worksheet>
  </xsl:template>


  <xsl:template match="/*/*">
    <Row>
      <xsl:apply-templates/>
    </Row>
  </xsl:template>


  <xsl:template match="/*/*/*">
    <Cell>
      <xsl:choose>
        <xsl:when test="(local-name() = 'AUTO') or (local-name() = 'Manual') or (local-name() = '누계량')">
          <Data ss:Type="Number">
            <xsl:value-of select="." />
          </Data>
        </xsl:when>
        <xsl:otherwise>
          <Data ss:Type="String">
            <xsl:value-of select="." />
          </Data>
        </xsl:otherwise>
      </xsl:choose>
    </Cell>
  </xsl:template>


</xsl:stylesheet>