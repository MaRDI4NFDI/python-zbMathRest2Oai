<!-- this is a new xslt file to start the transformation from plain.xml
to a suitable form for DataCite
-->


<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="root">
    <xsl:copy>

      <xsl:apply-templates select="result/links"/>
      <xsl:apply-templates select="result/contributors/authors"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="links">
    <identifier identifierType="{type}">
      <xsl:value-of select="identifier"/>
    </identifier>
  </xsl:template>


  <xsl:template match="authors">
    <creators>
      <creator>
        <xsl:variable name="givenName" select="substring-before(name, ', ')"/>
        <xsl:variable name="familyName" select="substring-after(name, ', ')"/>

        <creatorName nameType="Personal">
          <xsl:value-of select="concat($familyName, ', ', $givenName)"/>
        </creatorName>
        <givenName><xsl:value-of select="$givenName"/></givenName>
        <familyName><xsl:value-of select="$familyName"/></familyName>
      </creator>
    </creators>

  </xsl:template>
  <!-- adding the title node -->
    <xsl:template match="root">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="title">
    <titles>
      <title xml:lang="en">
        <xsl:value-of select="title"/>
      </title>
    </titles>
  </xsl:template>

</xsl:stylesheet>

