<!-- XSLT code to transform the zbmath metadata acoording the metadata Scheme of Datacite
Made by Shiraz Malla Mohamad member of zbmath Team-->
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
<!-- we have here the roots of the metadata : extracted from our plain.xml and then transformed to the file called
Test_Reference.xml following the properties and subproperties of the metadata Schema of Datacite.
below we can find every root and its matched node as well -->
            <xsl:apply-templates select="root/links"/>
                <xsl:apply-templates select="root/identifier"/>

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
             <relatedIdentifiers>
            <xsl:apply-templates select="root/references"/>
            </relatedIdentifiers>
         </resource>
         </xsl:template>
<!-- Template for processing identifiers -->
        <xsl:template match="links">
            <!-- Transform links into identifiers -->
        <identifier identifierType="{type}">
            <xsl:value-of select="identifier"/>
        </identifier>
        </xsl:template>
     <xsl:template match="identifier">
        <identifier relatedIdentifierType="DOI" relationType="IsCitedBy">
            <xsl:value-of select="."/>
        </identifier>
        </xsl:template>
    <!-- Template for processing authors -->
         <xsl:template match="authors">
             <!-- Transform authors into creators -->
    <creator>
      <!-- Transform 'codes' element into 'creatorName' -->
      <creatorName nameType="Personal">
        <xsl:value-of select="codes"/>
      </creatorName>
      <!-- Split 'name' into 'givenName' and 'familyName' -->
      <givenName>
        <xsl:value-of select="substring-before(name, ', ')"/>
      </givenName>
      <familyName>
        <xsl:value-of select="substring-after(name, ', ')"/>
      </familyName>
    </creator>
  </xsl:template>
    <!-- Template for processing titles -->
        <xsl:template match="title">
            <!-- Transform titles into structured titles -->
        <titles>
            <title xml:lang="en">
                <xsl:value-of select="title"/>
            </title>
        </titles>
        </xsl:template>
    <!-- Template for processing description -->
        <xsl:template match="description">
            <!-- Transform description with its  resourceType -->
        <resourceType resourceTypeGeneral="JournalArticle">
            <xsl:value-of select="."/>
        </resourceType>
        </xsl:template>
    <!-- Template for processing publisher -->
        <xsl:template match="publisher">
            <!-- Transform publisher -->
        <publisher>
            <xsl:value-of select="."/>
        </publisher>
        </xsl:template>
     <!-- Template for processing publication year -->
        <xsl:template match="year">
            <!-- Transform year -->
        <publicationYear>
            <xsl:value-of select="."/>
        </publicationYear>
        </xsl:template>
<!-- Template for processing text node into description text with its subproperty -->
        <xsl:template match="text">
            <!-- Transformation of  description text -->
        <description xml:lang="en" descriptionType="TechnicalInfo">

         <xsl:value-of select="normalize-space(.)"/>

        </description>
        </xsl:template>
     <!-- Template for processing MSC node  (Mathematics Subject Classification)
      transforming all its valuable nodes -->
    <xsl:template match="msc">
        <!-- Transformaion of  MSC  -->
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

<!-- Template for processing keywords it is also under the subject section with MSC'S
with its own subjectscheme -->

       <xsl:template match="keywords">
            <!-- Transformation of  keywords -->
        <subject subjectScheme="keyword">
            <xsl:value-of select="."/>
        </subject>
        </xsl:template>
<!-- Template for processing pages -->
        <xsl:template match="pages">
            <!-- Transformation of  pages separating our xml node into two nodes first and last page -->
        <xsl:variable name="pagesText" select="normalize-space(.)"/>
        <xsl:variable name="firstPage" select="substring-before($pagesText, '-')"/>
        <xsl:variable name="lastPage" select="substring-after($pagesText, '-')"/>
        <firstPage>
            <xsl:value-of select="$firstPage"/>
        </firstPage>
        <lastPage>
            <xsl:value-of select="$lastPage"/>
        </lastPage>
            <!-- Template for processing volume -->
        </xsl:template>
    <!-- Transformation of  volume -->
        <xsl:template match="volume">
        <volume>
            <xsl:value-of select="."/>
        </volume>
        </xsl:template>
    <!-- Template for processing issue -->
        <xsl:template match="issue">
            <!-- Transformation of issue-->
        <issue>
            <xsl:value-of select="."/>
        </issue>

       </xsl:template>
  <!-- Template to match references and transform into relatedItems
  references has also two iportant sections
  the first section has doi node and it is an important related identifier but it is not
  available in all of references
  the second part has the zbmath document_id which is our own identifier
  and it is available in all of references -->
  <xsl:template match="references">
    <!-- Transformation of references
    relateditem - relateditem identifier and related identifiers
    using out all of our valuable references nodes in order to provide a perfect matching with Datacite-->

    <xsl:variable name="position" select="position()"/>

    <!-- Select only the doi elements that have non-empty values -->
    <xsl:variable name="nonEmptyDOIs" select="doi[normalize-space()]"/>

    <!-- Check if there are any non-empty doi elements -->
    <xsl:if test="$nonEmptyDOIs">
        <xsl:for-each select="$nonEmptyDOIs">
            <relatedItem relatedItemType="Journal Article" relationType="Cites">
                <relatedItemIdentifier relatedItemIdentifierType="DOI">
                    <xsl:value-of select="."/>
                </relatedItemIdentifier>
                <position>
                    <xsl:value-of select="$position"/>
                </position>
                <titles>
                    <title>
                        <xsl:value-of select="../text"/>
                    </title>
                </titles>
                <!-- Loop through contributors
                here we use the author_id or author_codes as identifiers-->
                <contributors>
                    <xsl:for-each select="../zbmath/author_codes">
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
                <!-- Related Item Identifier  and here we use the document_id
                which is the zbmath identifer as we mentioned above -->
                <relatedItemIdentifier relationType="Cites">
                    <xsl:value-of select="../zbmath/document_id"/>
                </relatedItemIdentifier>
                <!-- Subjects -->
                <subjects>
                    <xsl:for-each select="../zbmath/msc">
                        <subject subjectScheme="msc2020" classificationCode="{.}"/>
                    </xsl:for-each>
                </subjects>
                <!-- Publication Year -->
                <publicationYear>
                    <xsl:value-of select="../zbmath/year"/>
                </publicationYear>
            </relatedItem>
        </xsl:for-each>
    </xsl:if>
</xsl:template>
</xsl:stylesheet>

