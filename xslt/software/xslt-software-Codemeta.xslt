<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/2005/Atom"
                xmlns:codemeta="https://doi.org/10.5063/SCHEMA/CODEMETA-2.0"
                xmlns:swhdeposit="https://www.softwareheritage.org/schema/2018/deposit"
                xmlns:swh="https://www.softwareheritage.org/schema/2018/deposit"
                xmlns:schema="http://schema.org">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <entry>

            <xsl:apply-templates select="root/id" mode="id"/>

            <xsl:apply-templates select="root/swhdeposit:deposit"/>


                <xsl:apply-templates select="root/authors"/>


            <xsl:apply-templates select="root/name"/>

            <xsl:apply-templates select="root/description"/>

            <xsl:apply-templates select="root/homepage"/>

            <xsl:apply-templates select="root/source_code"/>

            <xsl:apply-templates select="root/keywords"/>

            <xsl:apply-templates select="root/operating_systems"/>

            <xsl:apply-templates select="root/dependencies"/>

            <xsl:apply-templates select="root/orms_id"/>

            <xsl:apply-templates select="root/programming_languages"/>
            <schema:identifier>
            <xsl:apply-templates select="root/id" mode="codemeta-identifier"/>
            </schema:identifier>


            <xsl:apply-templates select="root/classification"/>




            <xsl:apply-templates select="root/articles_count"/>



                <xsl:apply-templates select="root/related_software"/>



                <xsl:apply-templates select="root/standard_articles"/>


            <xsl:apply-templates select="root/zbmath_url"/>

        </entry>
    </xsl:template>

    <xsl:template match="id"  mode="id">
        <id>
            <xsl:text>https://zbmath.org/</xsl:text>
            <xsl:value-of select="."/>
        </id>
    </xsl:template>

    <xsl:template match="swhdeposit:deposit">
        <swhdeposit:deposit>
            <xsl:apply-templates select="swhdeposit:reference"/>
            <xsl:apply-templates select="swhdeposit:metadata-provenance"/>
        </swhdeposit:deposit>
    </xsl:template>

    <!-- Template for swhdeposit:reference -->
    <xsl:template match="swhdeposit:reference">
        <swhdeposit:reference>
            <xsl:apply-templates select="swhdeposit:object"/>
        </swhdeposit:reference>
    </xsl:template>

    <!-- Template for swhdeposit:object -->
    <xsl:template match="swhdeposit:object">
        <swhdeposit:object swhid="{@swhid}"/>
    </xsl:template>

    <!-- Template for swhdeposit:metadata-provenance -->
    <xsl:template match="swhdeposit:metadata-provenance">
        <swhdeposit:metadata-provenance>
            <xsl:apply-templates select="schema:url"/>
        </swhdeposit:metadata-provenance>
    </xsl:template>

    <!-- Template for schema:url -->
    <xsl:template match="schema:url">
      <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <schema:url>
            <xsl:value-of select="."/>
        </schema:url>
      </xsl:if>
    </xsl:template>

    <!-- Template for authors -->
    <xsl:template match="authors">
        <codemeta:author>
        <codemeta:name>
            <xsl:value-of select="."/>
        </codemeta:name>
        <codemeta:givenName>
            <xsl:value-of select="normalize-space(substring-after(., ','))"/>
        </codemeta:givenName>
        <codemeta:familyName>
            <xsl:value-of select="substring-before(., ',')"/>
        </codemeta:familyName>
        </codemeta:author>
    </xsl:template>

    <xsl:template match="description">
     <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:description>
            <xsl:value-of select="."/>
        </codemeta:description>
      </xsl:if>
    </xsl:template>

    <xsl:template match="homepage">
     <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:sameAs>
            <xsl:value-of select="."/>
        </codemeta:sameAs>
     </xsl:if>
    </xsl:template>

    <xsl:template match="source_code">
     <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:codeRepository>
            <xsl:value-of select="."/>
        </codemeta:codeRepository>
     </xsl:if>
    </xsl:template>

    <xsl:template match="license_terms">
       <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:license>
            <xsl:value-of select="."/>
        </codemeta:license>
       </xsl:if>
    </xsl:template>

    <xsl:template match="keywords">
     <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:keywords>
            <xsl:value-of select="."/>
        </codemeta:keywords>
      </xsl:if>
    </xsl:template>

    <xsl:template match="name">
        <codemeta:name>
            <xsl:value-of select="."/>
        </codemeta:name>
    </xsl:template>

    <xsl:template match="operating_systems">
     <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:operatingSystem>
            <xsl:value-of select="."/>
        </codemeta:operatingSystem>
     </xsl:if>
    </xsl:template>

     <xsl:template match="dependencies">
        <xsl:if test="normalize-space(.) != '' and . != 'None'">
            <codemeta:softwareRequirements>
                <xsl:value-of select="."/>
            </codemeta:softwareRequirements>
        </xsl:if>
    </xsl:template>

    <xsl:template match="orms_id">
     <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <schema:identifier>
            <codemeta:type>schema:PropertyValue</codemeta:type>
            <schema:value>
                <xsl:value-of select="."/>
            </schema:value>
        </schema:identifier>
     </xsl:if>
    </xsl:template>

    <xsl:template match="programming_languages">
     <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:programmingLanguage>
            <xsl:value-of select="."/>
        </codemeta:programmingLanguage>
      </xsl:if>
    </xsl:template>

       <xsl:template match="id" mode="codemeta-identifier">
          <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:type>schema:PropertyValue</codemeta:type>
        <schema:value>
            <xsl:text>zbmath-</xsl:text>
            <xsl:value-of select="."/>
        </schema:value>
          </xsl:if>
       </xsl:template>

    <xsl:template match="classification">
     <xsl:if test="normalize-space(.) != '' and . != 'None'">
            <schema:categoryCode>
                <xsl:value-of select="."/>
            </schema:categoryCode>
     </xsl:if>
    </xsl:template>

    <xsl:template match="articles_count">
      <xsl:if test="normalize-space(.) != '' and . != 'None'">
            <schema:numberofItems>
                <xsl:value-of select="."/>
            </schema:numberofItems>
        </xsl:if>
    </xsl:template>

    <xsl:template match="related_software">
  <xsl:if test="normalize-space(.) != '' and . != 'None'">
      <codemeta:supportingData>
        <codemeta:name>
            <xsl:value-of select="name"/>
        </codemeta:name>
        <codemeta:identifier>
            <xsl:value-of select="id"/>
        </codemeta:identifier>
      </codemeta:supportingData>
  </xsl:if>
    </xsl:template>

    <xsl:template match="standard_articles">


      <codemeta:referencePublication>
           <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:identifier>
            <xsl:value-of select="id"/>
        </codemeta:identifier>
           </xsl:if>
          <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:datePublished>
            <xsl:value-of select="year"/>
        </codemeta:datePublished>
          </xsl:if>
      </codemeta:referencePublication>

    </xsl:template>

    <xsl:template match="zbmath_url">
  <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:url>
            <xsl:value-of select="."/>
        </codemeta:url>
       </xsl:if>
    </xsl:template>

</xsl:stylesheet>
