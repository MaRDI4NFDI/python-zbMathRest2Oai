<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4.1/metadata.xsd"
                xmlns="http://datacite.org/schema/kernel-4">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
         <resource xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd">
            <!-- Roots of the metadata -->
            <xsl:apply-templates select="root/id"/>

             <alternateIdentifiers>
            <xsl:apply-templates select="root/zbmath_url"/>
            </alternateIdentifiers>
            <creators>
                <xsl:apply-templates select="root/authors"/>
            </creators>
                <titles>
                <xsl:apply-templates select="root/name"/>
                 </titles>
                <descriptions>
                <xsl:apply-templates select="root/description"/>
                </descriptions>
      <xsl:apply-templates select="root/standard_articles/year"/>
            <subjects>
                <xsl:apply-templates select="root/classification"/>
                <xsl:apply-templates select="root/keywords"/>
            </subjects>
 <resourceType resourceTypeGeneral="Software"/>
</resource>
</xsl:template>
<xsl:template match="id">
 <identifier identifierType="swMATH">
<xsl:value-of select="."/>
 </identifier>
</xsl:template>
        <xsl:template match="zbmath_url">
        <alternateIdentifier alternateIdentifierType="URL">
            <xsl:value-of select="."/>
        </alternateIdentifier>
        </xsl:template>
 <xsl:template match="authors">
        <creator>
            <creatorName nameType="Personal">
                <xsl:value-of select="."/>
            </creatorName>
            <givenName>
                <xsl:value-of select="substring-after(., ', ')"/>
            </givenName>
            <familyName>
                <xsl:value-of select="substring-before(., ', ')"/>
            </familyName>
        </creator>
    </xsl:template>
  <xsl:template match="name">
    <title>
    <xsl:value-of select="."/>
    </title>
    </xsl:template>
 <xsl:template match="description">
            <!-- Transformation of  description text -->
        <description xml:lang="en" descriptionType="Abstract">
         <xsl:value-of select="."/>
        </description>
        </xsl:template>
  <xsl:template match="year">
            <!-- Transformation of publicationYear -->
        <publicationYear>
         <xsl:value-of select="."/>
        </publicationYear>
        </xsl:template>

        <xsl:template match="classification">
        <subject subjectScheme="msc2020" >
            <xsl:value-of select="."/>
        </subject>
        </xsl:template>
        <xsl:template match="keywords">
            <!-- Transformation of  keywords -->
        <subject subjectScheme="keyword">
            <xsl:value-of select="."/>
        </subject>
        </xsl:template>
</xsl:stylesheet>
