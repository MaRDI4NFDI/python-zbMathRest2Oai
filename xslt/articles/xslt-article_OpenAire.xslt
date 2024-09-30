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

            <xsl:apply-templates select="root/zbmath_url"/>

              <creators>
                <xsl:apply-templates select="root/contributors/authors"/>
              </creators>

                <xsl:apply-templates select="root/title"/>
                 <xsl:apply-templates select="root/source/series/publisher"/>
                <xsl:apply-templates select="root/year"/>
                <descriptions>
                <xsl:apply-templates select="root/editorial_contributions/text"/>
                </descriptions>
                 <subjects>
                <xsl:apply-templates select="root/msc"/>
                <xsl:apply-templates select="root/keywords"/>
            </subjects>

                </resource>
        </xsl:template>

        <!-- the URL is the main Identifier for OpenAire-->
        <xsl:template match="zbmath_url">
        <Identifier IdentifierType="URL">
            <xsl:value-of select="."/>
        </Identifier>
       </xsl:template>
     <xsl:template match="authors">
        <creator>
            <creatorName nameType="Personal">
                <xsl:value-of select="name"/>
            </creatorName>
            <givenName>
                <xsl:value-of select="substring-before(name, ',')"/>
            </givenName>
            <familyName>
                <xsl:value-of select="substring-after(name, ', ')"/>
            </familyName>
            <nameIdentifier schemeURI="https://zbmath.org/" nameIdentifierScheme="zbMATH Author Code">
                <xsl:value-of select="codes"/>
            </nameIdentifier>
        </creator>
    </xsl:template>

     <xsl:template match="title">
            <!-- Transform titles into structured titles -->
        <titles>
            <title xml:lang="en">
                <xsl:value-of select="title"/>
            </title>
        </titles>
           </xsl:template>
 <!-- Template for processing publisher -->
            <xsl:template match="publisher">
            <publisher xml:lang="en">
            <xsl:value-of select="."/>
            </publisher>
            </xsl:template>
    <!-- Template for processing publication year -->
          <xsl:template match="year">
            <publicationYear>
             <xsl:value-of select="."/>
            </publicationYear>
            </xsl:template>
    <!-- Template for processing text node into description text with its subproperty -->
        <xsl:template match="text">
            <!-- Transformation of  description text -->
        <description  descriptionType="Abstract">

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

    </xsl:stylesheet>

