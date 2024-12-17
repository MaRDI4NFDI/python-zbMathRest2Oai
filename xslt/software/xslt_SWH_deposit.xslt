<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns:codemeta="https://doi.org/10.5063/SCHEMA/CODEMETA-2.0"
                xmlns:swhdeposit="https://www.softwareheritage.org/schema/2018/deposit"
                xmlns:swh="https://www.softwareheritage.org/schema/2018/deposit"
                xmlns:schema="http://schema.org/">

  <!-- Output XML format with indentation -->
  <xsl:output method="xml" indent="yes"/>

  <!-- Template to process the OAI-PMH root element -->
  <xsl:template match="/oai:OAI-PMH">
    <entry xmlns="http://www.w3.org/2005/Atom"
           xmlns:codemeta="https://doi.org/10.5063/SCHEMA/CODEMETA-2.0"
           xmlns:swhdeposit="https://www.softwareheritage.org/schema/2018/deposit"
           xmlns:swh="https://www.softwareheritage.org/schema/2018/deposit"
           xmlns:schema="http://schema.org/"
           xmlns:oai="http://www.openarchives.org/OAI/2.0/">

      <!-- Extract numeric identifier from the oai identifier and generate the id -->
       <xsl:template match="id">
       <id>
      <xsl:text>https://swmath.org/software/</xsl:text>
      <xsl:value-of select="substring-after(., 'oai:swmath.org:')"/>
       </id>
       </xsl:template>


      <!-- SWH Deposit Metadata -->
      <swh:deposit>
        <swh:reference>
          <swh:origin url="{/oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/*/codemeta:codeRepository}"/>
        </swh:reference>
        <swh:metadata-provenance>
          <schema:url>
            <xsl:value-of select="concat('https://zbmath.org/software/', substring-after(/oai:OAI-PMH/oai:GetRecord/oai:record/oai:header/oai:identifier, ':swmath.org:'))"/>
          </schema:url>
        </swh:metadata-provenance>
      </swh:deposit>

      <!-- Copy additional metadata -->

      <xsl:copy-of select="/oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/*/codemeta:supportingData"/>
      <xsl:copy-of select="/oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/*/codemeta:author"/>
      <xsl:copy-of select="/oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/*/codemeta:name"/>
      <xsl:copy-of select="/oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/*/codemeta:description"/>
      <xsl:copy-of select="/oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/*/codemeta:sameAs"/>
      <xsl:copy-of select="/oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/*/codemeta:codeRepository"/>
      <xsl:copy-of select="/oai:OAI-PMH/oai:GetRecord/oai:record/oai:metadata/*/codemeta:citation"/>
      <codemeta:url>
            <xsl:value-of select="concat('https://api.zbmath.org/software/', substring-after(/oai:OAI-PMH/oai:GetRecord/oai:record/oai:header/oai:identifier, ':swmath.org:'))"/>
          </codemeta:url>


    </entry>
  </xsl:template>

  <!-- Identity template to copy unprocessed nodes (e.g., text nodes) -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
