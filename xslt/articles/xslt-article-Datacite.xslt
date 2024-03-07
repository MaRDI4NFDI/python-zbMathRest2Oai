
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
    <xsl:apply-templates select="root/result/links"/>
    <creators>
      <xsl:apply-templates select="root/result/contributors/authors"/>
    </creators>
<xsl:apply-templates select="root/result/title"/>
 <xsl:apply-templates select="root/result/document_type"/>
<xsl:apply-templates select="root/result/source/series/publisher"/>
<xsl:apply-templates select="root/result/source/series/year"/>
<descriptions>
<xsl:apply-templates select="root/result/editorial_contributions/text"/>
</descriptions>
<subjects>
 <xsl:apply-templates select="root/result/references/zbmath"/>
      <xsl:apply-templates select="root/result/references/text"/>
      <xsl:apply-templates select="root/result/keywords"/>
      </subjects>
  </xsl:template>
  <xsl:template match="links">
    <identifier identifierType="{type}">
      <xsl:value-of select="identifier"/>
    </identifier>
  </xsl:template>
<xsl:template match="authors">
 <creator>
        <xsl:variable name="givenName" select="substring-before(name, ', ')"/>
        <xsl:variable name="familyName" select="substring-after(name, ', ')"/>

        <creatorName nameType="Personal">
          <xsl:value-of select="concat($familyName, ', ', $givenName)"/>
        </creatorName>
        <givenName><xsl:value-of select="$givenName"/></givenName>
        <familyName><xsl:value-of select="$familyName"/></familyName>
      </creator>
  </xsl:template>
<xsl:template match="title">
    <titles>
      <title xml:lang="en">
        <xsl:value-of select="title"/>
      </title>
    </titles>
  </xsl:template>
<xsl:template match="document_type">
    <resourceType resourceTypeGeneral="JournalArticle">
      <xsl:value-of select="."/>
    </resourceType>
  </xsl:template>
<xsl:template match="publisher">
    <publisher>
        <xsl:value-of select="."/>
    </publisher>
  </xsl:template>
 <xsl:template match="year">
    <publicationYear>
        <xsl:value-of select="."/>
    </publicationYear>
</xsl:template>
 <xsl:template match="text">
      <description xml:lang="en" descriptionType="TechnicalInfo">
        <xsl:value-of select="."/>
      </description>
  </xsl:template>
  <xsl:template match="text">
      <subject>
        <xsl:value-of select="."/>
      </subject>
  </xsl:template>
  <xsl:template match="zbmath">
    <xsl:variable name="mscValues">
      <xsl:apply-templates select="msc"/>
    </xsl:variable>
      <xsl:copy-of select="$mscValues"/>
  </xsl:template>
  <xsl:template match="msc">
    <subjectScheme>
      <xsl:attribute name="classificationCode">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </subjectScheme>
  </xsl:template>
    <xsl:template match="keywords">
    <subject>
      <xsl:value-of select="."/>
    </subject>
  </xsl:template>
</xsl:stylesheet>
<!-- adding the references , keywords and msc's in the subjects node and editing the whole xslt file
in a better way -->

