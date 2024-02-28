<!-- this is a new xslt file to start the transformation from plain.xml
to a suitable form for DataCite

 -->


<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes"/>

  <!-- Match the root element -->
  <xsl:template match="root">
    <creators>
      <!-- Apply templates to process the child elements -->
      <xsl:apply-templates select="result/contributors/authors"/>
    </creators>
  </xsl:template>

  <!-- Match authors -->
  <xsl:template match="authors">
    <creator>
      <!-- Extract name components -->
      <xsl:variable name="givenName" select="substring-before(name, ', ')"/>
      <xsl:variable name="familyName" select="substring-after(name, ', ')"/>

      <!-- Output creator with name components -->
      <creatorName nameType="Personal">
        <xsl:value-of select="concat($familyName, ', ', $givenName)"/>
      </creatorName>
      <givenName><xsl:value-of select="$givenName"/></givenName>
      <familyName><xsl:value-of select="$familyName"/></familyName>
    </creator>
  </xsl:template>

</xsl:stylesheet>

<!-- this part of code is only as a Test to separate the name node into to two nodes
Given and Family name , which suits the Datacite schema
-->