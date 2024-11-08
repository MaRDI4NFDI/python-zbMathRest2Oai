<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version ="1.0"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:datacite="http://datacite.org/schema/kernel-4"
                xmlns:oaire="http://www.openarchives.org/OAI/2.0/oai_dc/"
                xmlns="http://namespace.openaire.eu/schema/oaire/"
                xsi:schemaLocation="http://namespace.openaire.eu/schema/oaire/ https://www.openaire.eu/schema/repo-lit/4.0/openaire.xsd"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
       <resource xsi:schemaLocation="http://namespace.openaire.eu/schema/oaire/ https://www.openaire.eu/schema/repo-lit/4.0/openaire.xsd">

           <xsl:apply-templates select="root/zbmath_url"/>

              <datacite:creators>
                <xsl:apply-templates select="root/authors"/>
              </datacite:creators>

                 <datacite:titles>
                <xsl:apply-templates select="root/name"/>
                 </datacite:titles>
                <xsl:apply-templates select="root/description"/>

           <datacite:subjects>
                <xsl:apply-templates select="root/classification"/>
                <xsl:apply-templates select="root/keywords"/>
            </datacite:subjects>

             <datacite:relatedIdentifiers>
                 <xsl:apply-templates select="root/homepage"/>
                <xsl:apply-templates select="root/standard_articles/id"/>
             </datacite:relatedIdentifiers>

  </resource>

    </xsl:template>




</xsl:stylesheet>