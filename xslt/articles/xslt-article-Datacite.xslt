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
            <resource xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd">
            <!-- Roots of the metadata -->
            <xsl:apply-templates select="root/links"/>

                <alternateIdentifiers>
                    <xsl:apply-templates select="root/identifier"/>
                <xsl:apply-templates select="root/id"/>
                <xsl:apply-templates select="root/zbmath_url"/>
                </alternateIdentifiers>
            <creators>
                <xsl:apply-templates select="root/contributors/authors"/>
            </creators>

                <descriptions>
                <xsl:apply-templates select="root/editorial_contributions/text"/>
                </descriptions>
                       <xsl:apply-templates select="root/title"/>
                <xsl:apply-templates select="root/source/series/publisher"/>
                       <xsl:apply-templates select="root/year"/>
            <subjects>
                <xsl:apply-templates select="root/msc"/>
                <xsl:apply-templates select="root/keywords"/>
            </subjects>
                <xsl:apply-templates select="root/language/languages"/>
                <xsl:apply-templates select="root/document_type/description"/>
               <relatedIdentifiers>
                <xsl:apply-templates select="//references/doi[normalize-space()]"/>
            <!-- Select all references with empty DOI elements -->
            <xsl:apply-templates select="//references[doi[not(normalize-space())]]"/>
            </relatedIdentifiers>
                <rightsList> <!-- this generates the copyrights and legal aspect wihtin the xslt -->
                <rights xml:lang="en"
                        schemeURI="https://api.zbmath.org/v1/"
                        rightsIdentifierScheme="zbMATH"
                        rightsIdentifier="CC-BY-SA 4.0"
                        rightsURI="https://creativecommons.org/licenses/by-sa/4.0/">
                    The zbMATH Open OAI-PMH API is subject to the Terms and Conditions for the zbMATH Open API Service of FIZ Karlsruhe – Leibniz-Institut für Informationsinfrastruktur GmbH.
Content generated by zbMATH Open, such as reviews, classifications, software, or author disambiguation data, are distributed under CC-BY-SA 4.0. This defines the license for the whole dataset, which also contains non-copyrighted bibliographic metadata and reference data derived from I4OC (CC0). Note that the API only provides a subset of the data in the zbMATH Open Web interface. In several cases, third-party information, such as abstracts, cannot be made available under a suitable license through the API. In those cases, we replaced the data with the string
"zbMATH Open Web Interface contents unavailable due to conflicting licenses."</rights>
            </rightsList>
              <relatedItems>
                 <xsl:apply-templates select="root/references" mode="relatedItems"/>
                  <xsl:apply-templates select="root/source"/>
            </relatedItems>
         </resource>
         </xsl:template>
<!-- Template for processing identifiers -->
       <xsl:template match="root/links">
    <xsl:choose>
        <!-- Process the first 'links' node that has a 'doi' identifier -->
        <xsl:when test="self::links[type = 'doi' and normalize-space(identifier) != ''][1]">
            <identifier identifierType="DOI">
                <xsl:value-of select="identifier"/>
            </identifier>
        </xsl:when>
        <!-- If no 'doi' identifier is present, consider 'arxiv' -->
        <xsl:when test="self::links[type = 'arxiv' and normalize-space(identifier) != ''][1] and not(preceding-sibling::links[type = 'doi' and normalize-space(identifier) != ''])">
            <identifier identifierType="ARXIV">
                <xsl:value-of select="identifier"/>
            </identifier>
        </xsl:when>
    </xsl:choose>
</xsl:template>
<!-- Template for processing the rest of the  identifiers of our Metadata and considered as alternative identifiers-->
     <xsl:template match="identifier">
          <xsl:if test="normalize-space(.) != '' and . != 'None'and . != 'none'">
        <alternateIdentifier alternateIdentifierType="zbMATH Identifier">
            <xsl:value-of select="."/>
        </alternateIdentifier>
          </xsl:if>
        </xsl:template>
    <xsl:template match="id">
         <xsl:if test="normalize-space(.) != '' and . != 'None'and . != 'none'">
    <alternateIdentifier alternateIdentifierType="zbMATH Document ID">
        <xsl:value-of select="."/>
    </alternateIdentifier>
         </xsl:if>
    </xsl:template>
     <xsl:template match="zbmath_url">
          <xsl:if test="normalize-space(.) != '' and . != 'None'and . != 'none'">
        <alternateIdentifier alternateIdentifierType="URL">
            <xsl:value-of select="."/>
        </alternateIdentifier>
          </xsl:if>
    </xsl:template>

    <!-- Template for processing authors -->
  <xsl:template match="authors">
    <creator>
        <creatorName nameType="Personal">
            <xsl:choose>
                <xsl:when test="normalize-space(name) = '' or name = 'None' or name = 'none'">:unav</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(name)"/>
                </xsl:otherwise>
            </xsl:choose>
        </creatorName>

        <givenName>
            <xsl:choose>
                <xsl:when test="normalize-space(name) = '' or name = 'None' or name = 'none'">:unav</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(substring-before(name, ','))"/>
                </xsl:otherwise>
            </xsl:choose>
        </givenName>

        <familyName>
            <xsl:choose>
                <xsl:when test="normalize-space(name) = '' or name = 'None' or name = 'none'">:unav</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(substring-after(name, ', '))"/>
                </xsl:otherwise>
            </xsl:choose>
        </familyName>

        <nameIdentifier schemeURI="https://zbmath.org/" nameIdentifierScheme="zbMATH Author Code">
            <xsl:choose>
                <xsl:when test="normalize-space(codes) = '' or codes = 'None' or codes = 'none'">:unav</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(codes)"/>
                </xsl:otherwise>
            </xsl:choose>
        </nameIdentifier>
    </creator>
</xsl:template>


    <!-- Template for processing titles -->
    <xsl:template match="title">
    <titles>
        <title xml:lang="en">
            <xsl:choose>
                <xsl:when test="normalize-space(.) = '' or . = 'None' or . = 'none'">:unkn</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </title>
    </titles>
</xsl:template>


<xsl:template match="publisher">
    <publisher xml:lang="en">
        <xsl:choose>
            <xsl:when test="normalize-space(.) = '' or . = 'None' or . = 'none'">:unav</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </publisher>
</xsl:template>

<xsl:template match="year">
    <publicationYear>
        <xsl:choose>
            <xsl:when test="normalize-space(.) = '' or . = 'None' or . = 'none'">:unav</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </publicationYear>
</xsl:template>


    <!-- Template for processing the language of the document -->
      <xsl:template match="languages">
           <xsl:if test="normalize-space(.) != '' and . != 'None'and . != 'none'">
            <language>
             <xsl:value-of select="."/>
            </language>
           </xsl:if>
            </xsl:template>
    <!-- Template for processing  the document type which can be various and needs to be properly handeld -->
    <xsl:template match="description">
    <resourceType>
        <xsl:choose>
            <xsl:when test="contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'article')">
                <xsl:attribute name="resourceTypeGeneral">JournalArticle</xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'book')">
                <xsl:attribute name="resourceTypeGeneral">Book</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="resourceTypeGeneral">Other</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="."/>
    </resourceType>
</xsl:template>
     <!-- Template for processing source as relatedItem -->
    <xsl:template match="source">
         <relatedItem relationType="IsPublishedIn" relatedItemType="Book">
        <!-- Select ISSN with type 'print' -->
        <relatedItemIdentifier relatedItemIdentifierType="ISSN">
            <xsl:value-of select="descendant::issn[type='print']/number"/>
        </relatedItemIdentifier>
            <!-- Process title -->
            <titles>
                <title>
                    <xsl:value-of select="series/title"/>
                </title>
            </titles>
              <publicationYear>
                <xsl:value-of select="series/year"/>
            </publicationYear>


            <!-- Process publication year -->

            <!-- Process volume -->
            <volume>
                <xsl:value-of select="series/volume"/>
            </volume>
            <!-- Process issue -->
            <issue>
                <xsl:value-of select="series/issue"/>
            </issue>
            <!-- Process pages  start with first page and end with last page -->
            <xsl:variable name="pagesText" select="normalize-space(pages)"/>
            <xsl:variable name="firstPage" select="substring-before($pagesText, '-')"/>
            <xsl:variable name="lastPage" select="substring-after($pagesText, '-')"/>
            <firstPage>
                <xsl:value-of select="$firstPage"/>
            </firstPage>
            <lastPage>
                <xsl:value-of select="$lastPage"/>
            </lastPage>
              <!-- Process publisher -->
              <publisher>
                <xsl:value-of select="series/publisher"/>
            </publisher>
        </relatedItem>
    </xsl:template>

<!-- Template for processing text node into description text with its subproperty -->
        <xsl:template match="text">
            <xsl:if test="normalize-space(.) != '' and . != 'None'and . != 'none'">
        <description xml:lang="en" descriptionType="Abstract">

         <xsl:value-of select="normalize-space(.)"/>

        </description>
            </xsl:if>
        </xsl:template>
     <!-- Template for processing MSC  (Mathematics Subject Classification)
      transforming all its values -->
    <xsl:template match="msc">
         <xsl:if test="normalize-space(.) != '' and . != 'None'and . != 'none'">
    <subject>
        <xsl:attribute name="subjectScheme">
            <xsl:value-of select="scheme"/>
        </xsl:attribute>
        <xsl:attribute name="classificationCode">
            <xsl:value-of select="code"/>
        </xsl:attribute>
        <xsl:value-of select="text"/>
    </subject>
         </xsl:if>
</xsl:template>


       <xsl:template match="keywords">
            <xsl:if test="normalize-space(.) != '' and . != 'None'and . != 'none'">

        <subject subjectScheme="keyword">
            <xsl:value-of select="."/>
        </subject>
            </xsl:if>
        </xsl:template>


  <xsl:template match="doi[normalize-space()]">
        <relatedIdentifier relatedIdentifierType="DOI" relationType="Cites" resourceTypeGeneral="JournalArticle"><xsl:value-of select="normalize-space(.)"/></relatedIdentifier>
    </xsl:template>


    <xsl:template match="references[not(doi[normalize-space()])]">
        <relatedIdentifier relatedIdentifierType="URL" relationType="IsCitedBy"><xsl:value-of select="concat('https://zbmath.org/', zbmath/document_id)"/></relatedIdentifier>
    </xsl:template>




  <!-- Template to match references and transform into relatedItems
each reference has its own relatedItem node and all of its values goes under this node -->
  <xsl:template match="references" mode="relatedItems">
        <relatedItem relatedItemType="JournalArticle" relationType="Cites">
              <!-- the relatedItemIdentifier should have the same value of identifier as they are in the relatedIdentifiers -->
             <relatedItemIdentifier>
    <xsl:choose>
        <xsl:when test="doi[normalize-space()]">
            <xsl:attribute name="relatedItemIdentifierType">DOI</xsl:attribute>
            <xsl:value-of select="doi"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:attribute name="relatedItemIdentifierType">URL</xsl:attribute>
            <xsl:value-of select="concat('https://zbmath.org/', zbmath/document_id)"/>
        </xsl:otherwise>
    </xsl:choose>
</relatedItemIdentifier>
            <creators>
                <xsl:for-each select="zbmath/author_codes">
                    <creator>
                         <creatorName nameType="Personal">
                <xsl:choose>
                     <xsl:when test="normalize-space(.) = '' or . = 'None' or . = 'none'">
                        <xsl:text>:unav</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                    <xsl:when test="contains(translate(substring-after(., '.'), '0123456789.', ''), '-')">
                        <xsl:value-of select="concat(
                            translate(substring(translate(substring-before(., '.'), '0123456789.', ''), 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
                            substring(translate(substring-before(., '.'), '0123456789.', ''), 2),
                            ', ',
                            substring-before(
                                concat(
                                    translate(substring(translate(substring-after(., '.'), '0123456789.', ''), 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
                                    substring(translate(substring-after(., '.'), '0123456789.', ''), 2)
                                ), '-')
                        )"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(
                            translate(substring(translate(substring-before(., '.'), '0123456789.', ''), 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
                            substring(translate(substring-before(., '.'), '0123456789.', ''), 2),
                            ', ',
                            translate(substring(translate(substring-after(., '.'), '0123456789.', ''), 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
                            substring(translate(substring-after(., '.'), '0123456789.', ''), 2)
                        )"/>
                    </xsl:otherwise>
                            </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </creatorName>
                        <givenName>
                            <xsl:choose>
                                 <xsl:when test="normalize-space(.) = '' or . = 'None' or . = 'none'">
                                    <xsl:text>:unav</xsl:text>
                                </xsl:when>
                            <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="contains(translate(substring-after(., '.'), '0123456789.', ''), '-')">
                                    <xsl:value-of select="substring-before(
                                        concat(
                                            translate(substring(translate(substring-after(., '.'), '0123456789.', ''), 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
                                            substring(translate(substring-after(., '.'), '0123456789.', ''), 2)
                                        ), '-')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat(
                                        translate(substring(translate(substring-after(., '.'), '0123456789.', ''), 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
                                        substring(translate(substring-after(., '.'), '0123456789.', ''), 2)
                                    )"/>
                                </xsl:otherwise>
                                </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </givenName>
                        <familyName>
                              <xsl:choose>
                               <xsl:when test="normalize-space(.) = '' or . = 'None' or . = 'none'">
                                    <xsl:text>:unav</xsl:text>
                                </xsl:when>
                              <xsl:otherwise>
                            <xsl:value-of select="concat(
                                translate(substring(translate(substring-before(., '.'), '0123456789.', ''), 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
                                substring(translate(substring-before(., '.'), '0123456789.', ''), 2)
                            )"/>
                              </xsl:otherwise>
                            </xsl:choose>
                        </familyName>
                    </creator>
                </xsl:for-each>
            </creators>
           <titles>
                 <xsl:choose>
                <xsl:when test="normalize-space(text) = '' or text = 'None' or text = 'none'">
                    <title>:unav</title>
                </xsl:when>
                <xsl:when test="contains(text, &quot;''&quot;)">
                    <!-- Extract text between quotes -->
                   <title>
                        <xsl:variable name="text" select="text"/>
                        <xsl:variable name="title-text" select="substring-before(substring-after($text, &quot;''&quot;), &quot;''&quot;)"/>
                        <!-- Remove digits and trailing punctuation -->
                        <xsl:variable name="title-no-digits" select="translate($title-text, '0123456789', '')"/>
                        <xsl:value-of select="normalize-space(
                            translate(
                                $title-no-digits,
                                ',.',
                                ''
                            )
                        )"/>
                    </title>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Extract text after the first comma and before the last comma, excluding digits and removing trailing commas/periods -->
                    <title>
                        <xsl:variable name="text" select="text"/>
                        <xsl:variable name="text-no-digits" select="translate($text, '0123456789', '')"/>
                        <xsl:variable name="first-comma" select="substring-after($text-no-digits, ',')"/>
                        <xsl:variable name="last-part" select="substring-before($text-no-digits, substring-after($text-no-digits, ', '))"/>
                        <xsl:variable name="last-comma" select="substring-before($last-part, ',')"/>
                        <xsl:variable name="result-text" select="normalize-space(concat(substring-before($first-comma, substring-after($first-comma, ', ')), substring-after($first-comma, ', ')))"/>
                        <xsl:value-of select="normalize-space(
                            translate(
                                $result-text,
                                ',.',
                                ''
                            )
                        )"/>
                    </title>
                </xsl:otherwise>
            </xsl:choose>
        </titles>
            <publicationYear>
                <xsl:choose>
                    <xsl:when test="normalize-space(zbmath/year) = '' or zbmath/year = 'None' or zbmath/year = 'none'">
                        <xsl:text>:unav</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="zbmath/year"/>
                    </xsl:otherwise>
                </xsl:choose>
            </publicationYear>
        </relatedItem>
    </xsl:template>
</xsl:stylesheet>
