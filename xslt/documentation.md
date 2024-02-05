In this document, we'd like to show how the XLST can process the XML file generated with src/zbmath_rest2oai/getAsXml.py.

Environment request:

JDK version 8

Maven 3

Install the package :

https://github.com/physikerwelt/xstlprocJ

Point to the folder xstlprocJ, copy the files xslt-article-transformation.xslt and plain.xml, then execute the shell command:

```shell
:~/xstlprocJ$ bash xsltprocJ xslt-article-transformation.xslt plain.xml
Warning: at xsl:stylesheet on line 2 column 255 of xslt-article-transformation.xslt:
  Running an XSLT 1 stylesheet with an XSLT 2 processor

```

This command outputs the following XML document.

```xml
<?xml version="1.0" encoding="UTF-8"?><oai_zb_preview xmlns:oai_zb_preview="https://zbmath.org/OAI/2.0/oai_zb_preview/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:zbmath="https://zbmath.org/zbmath/elements/1.0/"><author>Maynard, James</author><author_ids><author_id>maynard.james</author_id></author_ids><classifications><classification>11N05</classification><classification>11N36</classification></classifications></oai_zb_preview>maz@BE000078:~/xstlprocJ$
```
