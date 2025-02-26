This XML code block is an example of file we process.

```xml
<root>
  <result>
    <biographic_references/>
    <contributors>
      <author_references/>
      <authors>
        <aliases/>
        <checked>1</checked>
        <codes>maynard.james</codes>
        <name>Maynard, James</name>
      </authors>
    </contributors>
  </result>
</root>
```

With the XSLT code block below, we can transform the upper XML block into a new XML file.

```xslt
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foo="http://www.foo.org/" xmlns:bar="http://www.bar.org">
<xsl:template match="/">
<oai_zb_preview>
      <xsl:for-each select="root/result/contributors/authors/name">
        <author><xsl:value-of select="."/></author>
      </xsl:for-each>
      <author_ids>
      <xsl:for-each select="root/result/contributors/authors/codes">
        <author_id><xsl:value-of select="."/></author_id>
      </xsl:for-each>
      </author_ids>
</oai_zb_preview>
</xsl:template>
</xsl:stylesheet>
```

This transformation outputs the result below.

```xml
<oai_zb_preview xmlns:foo="http://www.foo.org/" xmlns:bar="http://www.bar.org">
   <author>Maynard, James</author>
   <author_ids>
      <author_id>maynard.james</author_id>
   </author_ids>
</oai_zb_preview>
```


