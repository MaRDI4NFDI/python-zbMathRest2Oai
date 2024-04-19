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

            <xsl:apply-templates select="root/links"/>
            <creators>
                <xsl:apply-templates select="root/contributors/authors"/>
            </creators>

                <descriptions>
                <xsl:apply-templates select="root/editorial_contributions/text"/>
                </descriptions>
                       <xsl:apply-templates select="root/title"/>
                <xsl:apply-templates select="root/document_type/description"/>
                <xsl:apply-templates select="root/source/series/publisher"/>
                <xsl:apply-templates select="root/source/series/year"/>
                <xsl:apply-templates select="root/source/series/volume"/>
                <xsl:apply-templates select="root/source/series/issue"/>
                <xsl:apply-templates select="root/source/pages"/>
            <subjects>
                <xsl:apply-templates select="root/msc"/>
                <xsl:apply-templates select="root/keywords"/>
            </subjects>
             <relatedItems>
            <xsl:apply-templates select="root/references"/>
            </relatedItems>
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
        <xsl:template match="description">
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
    <xsl:template match="msc">
    <subject>
      <xsl:attribute name="subjectScheme">
        <xsl:value-of select="scheme"/>
      </xsl:attribute>
      <xsl:attribute name="classificationCode">
        <xsl:value-of select="code"/>
      </xsl:attribute>
    </subject>
    <subject>
      <xsl:value-of select="text"/>
    </subject>
    </xsl:template>


       <xsl:template match="keywords">
        <subject subjectScheme="keyword">
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
  <!-- Template to match references and transform into relatedItems -->
  <xsl:template match="references">
    <xsl:variable name="position" select="position()"/>

      <relatedItem relatedItemType="Journal Article" relationType="Cites">
        <relatedItemIdentifier relatedItemIdentifierType="DOI">
          <xsl:value-of select="doi"/>
        </relatedItemIdentifier>
        <position>
          <xsl:value-of select="position"/>
        </position>
        <titles>
          <title>
            <xsl:value-of select="text"/>
          </title>
        </titles>
        <!-- Loop through contributors -->
          <contributors>
  <xsl:for-each select="zbmath/author_codes">
            <contributor contributorType="Other">
              <contributorName nameType="Personal">
                <xsl:value-of select="."/>
              </contributorName>
              <givenName>
                <xsl:value-of select="substring-before(., '.')"/>
              </givenName>
              <familyName>
                <xsl:value-of select="substring-after(., '.')"/>
              </familyName>
            </contributor>
         </xsl:for-each>
          </contributors>
        <!-- Related Item Identifier -->
        <relatedItemIdentifier relationType="Cites">
          <xsl:value-of select="zbmath/document_id"/>
        </relatedItemIdentifier>
        <!-- Subjects -->
        <subjects>
          <xsl:for-each select="zbmath/msc">
            <subject subjectScheme="classificationCode">
              <xsl:value-of select="."/>
            </subject>
          </xsl:for-each>
        </subjects>
        <!-- Publication Year -->
        <publicationYear>
          <xsl:value-of select="zbmath/year"/>
        </publicationYear>
      </relatedItem>
  </xsl:template>
</xsl:stylesheet>