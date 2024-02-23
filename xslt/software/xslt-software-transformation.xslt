<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://datacite.org/schema/kernel-4"  >
<xsl:template match="/">
<resource>

    <identifier identifierType="swMATH">
        <xsl:value-of select="root/result/id"/>
    </identifier>
    <creators>
        <xsl:value-of select="root/result/authors"/>

    </creators>
    <resourceType resourceTypeGeneral="Software"/>
    <titles>
        <title>
            <xsl:value-of select="root/result/name"/>
        </title>
    </titles>
    <description>
        <xsl:value-of select="root/result/description"/>
    </description>
    <publicationYear>
        <xsl:value-of select="root/result/standard_articles/year"/>
    </publicationYear>

    <xsl:choose>
        <xsl:when test= "root/result/source_code != ''">
            <!-- will be instantiated for item #1 and item #2 -->
            <publisher>
            <xsl:value-of select="root/result/source_code"/>
            </publisher>
        </xsl:when>
        <xsl:otherwise>
            <contributor contributorType="HostingInstitution">
                <xsl:value-of select="root/result/homepage" />
             </contributor>
        </xsl:otherwise>
    </xsl:choose>
<rightsList>
    <xsl:choose>
        <xsl:when test= "root/result/license_terms != ''">
            <!-- will be instantiated for item #1 and item #2 -->
            <rights>
            <xsl:value-of select="root/result/license_terms"/>
            </rights>
        </xsl:when>
        <xsl:otherwise>
            <rights>
                <xsl:value-of select="concat('No',' license')" />
             </rights>
        </xsl:otherwise>
    </xsl:choose>

</rightsList>
    <subjects>
    <xsl:for-each select="root/result/classification">
        <subject><xsl:value-of select="."/></subject>
      </xsl:for-each>

        <subject>
            <xsl:value-of select="root/result/keywords"/>
        </subject>
     </subjects>
    <xsl:for-each select="root/result/related_software">
        <related_software>
        <id><xsl:value-of select="id"/></id>
            <name><xsl:value-of select="name"/></name>
        </related_software>
      </xsl:for-each>

    <xsl:for-each select="root/result/standard_articles/id">
        <relatedIdentifier relationType="IsReferencedBy"><xsl:value-of select="."/></relatedIdentifier>
      </xsl:for-each>
<alternateIdentifiers>
      <relatedIdentifier relationType="IsDescribedBy">
        <xsl:value-of disable-output-escaping="yes" select="concat('https://orms.mfo.de/project@terms=', '&amp;', 'id=' , root/result/orms_id, '.html')"/>
    </relatedIdentifier>

    <alternateIdentifier alternateIdentifierType="url">
        <xsl:value-of disable-output-escaping="yes" select="concat('https://zbmath.org/software/?q=si%3A',root/result/id)" />
    </alternateIdentifier>
  </alternateIdentifiers>
</resource>
</xsl:template>
</xsl:stylesheet>
