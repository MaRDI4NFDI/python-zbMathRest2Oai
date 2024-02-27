<!-- this is a new xslt file to start the transformation from plain.xml
to a suitable form for DataCite
 -->


<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="root/result/contributors/authors/name"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="name">
    <givenName>
      <xsl:value-of select="substring-before(., ',')"/>
    </givenName>
    <familyName>
      <xsl:value-of select="substring-after(., ',')"/>
    </familyName>
  </xsl:template>

</xsl:stylesheet>

<!-- this part of code is only as a Test to separate the name node into to two nodes
Given and Family name , which suits the Datacite schema
-->