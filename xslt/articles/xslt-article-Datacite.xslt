<xsl:stylesheet version="1.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns="http://datacite.org/schema/kernel-4"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xsi:schemaLocation="http://datacite.org/schema/kernel-4
                https://schema.datacite.org/meta/kernel-4.1/metadata.xsd"
                exclude-result-prefixes="#default">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
            <resource>

            <xsl:apply-templates select="root/result/links"/>
            <creators>
                <xsl:apply-templates select="root/result/contributors/authors"/>
            </creators>
            <relatedItems>
                <xsl:apply-templates select="root/result/title"/>
                <xsl:apply-templates select="root/result/document_type"/>
                <xsl:apply-templates select="root/result/source/series/publisher"/>
                <xsl:apply-templates select="root/result/source/series/year"/>
                <xsl:apply-templates select="root/result/source/series/volume"/>
                <xsl:apply-templates select="root/result/source/series/issue"/>
                <xsl:apply-templates select="root/result/source/pages"/>
            </relatedItems>

                <descriptions>
                <xsl:apply-templates select="root/result/editorial_contributions/text"/>
                </descriptions>
            <subjects>
                <xsl:apply-templates select="root/result/references/zbmath"/>
                <xsl:apply-templates select="root/result/references/text"/>
                <xsl:apply-templates select="root/result/keywords"/>
            </subjects>
             <relatedIdentifiers>
                  <xsl:apply-templates select="root/result/references/doi"/>
               </relatedIdentifiers>
         </resource>
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
            <givenName>
                <xsl:value-of select="$givenName"/>
            </givenName>
            <familyName>
                <xsl:value-of select="$familyName"/>
            </familyName>
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

         <xsl:value-of select="normalize-space(.)"/>

        </description>
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
      <xsl:template match="root/result/references/text">
      <subject>
        <xsl:value-of select="."/>
      </subject>
      </xsl:template>
        <xsl:template match="pages">
        <xsl:variable name="pagesText" select="normalize-space(.)"/>
        <xsl:variable name="firstPage" select="substring-before($pagesText, '-')"/>
        <xsl:variable name="lastPage" select="substring-after($pagesText, '-')"/>
        <firstPage>
            <xsl:value-of select="$firstPage"/>
        </firstPage>
        <lastPage>
            <xsl:value-of select="$lastPage"/>
        </lastPage>
        </xsl:template>
        <xsl:template match="volume">
        <volume>
            <xsl:value-of select="."/>
        </volume>
        </xsl:template>
        <xsl:template match="issue">
        <issue>
            <xsl:value-of select="."/>
        </issue>
       </xsl:template>
    <xsl:template match="references/doi">
        <xsl:variable name="identifierType">
             <xsl:choose>
            <xsl:when test="self::doi">DOI</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="identifierValue" select="." />
        <xsl:choose>
            <xsl:when test="not(normalize-space($identifierValue))">
                <relatedIdentifier relatedIdentifierType="DOI" relationType="IsCitedBy" resourceTypeGeneral="Journal Article">/</relatedIdentifier>
            </xsl:when>
            <xsl:otherwise>
                <relatedIdentifier relatedIdentifierType="{$identifierType}" relationType="IsCitedBy" resourceTypeGeneral="Journal Article">
                    <xsl:value-of select="substring($identifierValue, 1, string-length($identifierValue) - 1)"/>
                </relatedIdentifier>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>






