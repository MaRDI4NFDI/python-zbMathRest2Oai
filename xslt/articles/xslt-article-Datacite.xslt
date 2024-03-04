<!-- this is a new xslt file to start the transformation from plain.xml
to a suitable form for DataCite
 -->


<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="root">
    <xsl:copy>
<!-- editing this part again to make it better for the whole file -->
      <xsl:apply-templates select="result/links"/>
      <xsl:apply-templates select="result/contributors/authors"/>
         <xsl:apply-templates select="result/title"/>
      <xsl:apply-templates select="result/publisher"/>
      <xsl:apply-templates select="result/year"/>
      <xsl:apply-templates select="result/document_type"/>

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
  <!-- adding the publisher and publication Year -->
<xsl:template match="source">
    <publisher>
        <xsl:value-of select="."/>
    </publisher>
  </xsl:template>
  <xsl:template match="source">
    <publicationYear>
        <xsl:value-of select="."/>
    </publicationYear>
</xsl:template>
  <!-- adding the resourceType node -->
    <xsl:template match="document_type">
    <resourceType resourceTypeGeneral="JournalArticle">
      <xsl:value-of select="."/>
    </resourceType>
  </xsl:template>
</xsl:stylesheet>


