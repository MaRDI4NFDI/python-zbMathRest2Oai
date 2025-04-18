<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/2005/Atom"
                xmlns:codemeta="https://doi.org/10.5063/SCHEMA/CODEMETA-2.0"
                xmlns:swhdeposit="https://www.softwareheritage.org/schema/2018/deposit"
                xmlns:swh="https://www.softwareheritage.org/schema/2018/deposit"
                xmlns:schema="http://schema.org/">
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


            <xsl:apply-templates select="root/orms_id"/>

            <xsl:apply-templates select="root/programming_languages"/>


                <xsl:apply-templates select="root/related_software"/>


                <xsl:apply-templates select="root/standard_articles"/>


             <xsl:apply-templates select="root/references"/>


            <xsl:apply-templates select="root/id"/>

        </entry>
    </xsl:template>

  <xsl:template match="id" mode="id">
  <id>
    <xsl:text>https://swmath.org/software/</xsl:text>
    <xsl:choose>
      <xsl:when test="starts-with(., 'oai:swmath.org:')">
        <xsl:value-of select="substring-after(., 'oai:swmath.org:')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
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
        <swhdeposit:origin>
            <xsl:attribute name="url">
                <xsl:value-of select="//source_code"/>
            </xsl:attribute>
        </swhdeposit:origin>
    </swhdeposit:reference>
</xsl:template>

    <!-- Template for swhdeposit:metadata-provenance -->
    <xsl:template match="swhdeposit:metadata-provenance">
        <swhdeposit:metadata-provenance>
             <schema:url>
                 <xsl:text>https://api.zbmath.org/v1/</xsl:text>
            </schema:url>
        </swhdeposit:metadata-provenance>
    </xsl:template>




    <!-- Template for authors -->
    <xsl:template match="authors">
        <codemeta:author>
        <codemeta:name>
            <xsl:value-of select="."/>
        </codemeta:name>
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


    <xsl:template match="orms_id">
    <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:relatedLink>
                <xsl:text>https://orms.mfo.de/project@id=</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>.html</xsl:text>
        </codemeta:relatedLink>
    </xsl:if>
</xsl:template>


    <xsl:template match="programming_languages">
     <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:programmingLanguage>
            <xsl:value-of select="."/>
        </codemeta:programmingLanguage>
      </xsl:if>
    </xsl:template>

    <xsl:template match="related_software">
  <xsl:if test="normalize-space(.) != '' and . != 'None'">
      <codemeta:supportingData>
        <codemeta:name>
            <xsl:value-of select="name"/>
        </codemeta:name>
        <codemeta:id>
            <xsl:text>https://swmath.org/software/</xsl:text>
            <xsl:value-of select="id"/>
        </codemeta:id>
      </codemeta:supportingData>
  </xsl:if>
    </xsl:template>

    <xsl:template match="standard_articles">
    <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:referencePublication>
            <!-- Check if 'id' exists and is not 'None' or empty -->
            <xsl:if test="normalize-space(id) != '' and id != 'None'">
                <codemeta:id>
                    <xsl:text>https://zbmath.org/</xsl:text>
                    <xsl:value-of select="id"/>
                </codemeta:id>
            </xsl:if>

            <!-- Check if 'year' exists and is not 'None' or empty -->
            <xsl:if test="normalize-space(year) != '' and year != 'None'">
                <codemeta:datePublished>
                    <xsl:value-of select="year"/>
                </codemeta:datePublished>
            </xsl:if>
        </codemeta:referencePublication>
    </xsl:if>
</xsl:template>

         <xsl:template match="references">
  <xsl:if test="normalize-space(.) != '' and . != 'None'">
      <codemeta:citation>
        <codemeta:id>
            <xsl:text>https://api.zbmath.org/v1/document/</xsl:text>
            <xsl:value-of select="."/>
        </codemeta:id>
      </codemeta:citation>
       </xsl:if>
    </xsl:template>

   <xsl:template match="id">
    <xsl:if test="normalize-space(.) != '' and . != 'None'">
        <codemeta:url>
      <xsl:text>https://api.zbmath.org/v1/software/</xsl:text>
      <xsl:choose>
        <xsl:when test="starts-with(., 'oai:swmath.org:')">
          <xsl:value-of select="substring-after(., 'oai:swmath.org:')"/>
        </xsl:when>
          <xsl:otherwise>
          <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
        </codemeta:url>
      </xsl:if>
   </xsl:template>



</xsl:stylesheet>
