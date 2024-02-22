import lxml.etree as ET

dom = ET.parse('test/data/software/plain.xml')
xslt = ET.parse('xslt/software/xslt-software-transformation.xslt')
transform = ET.XSLT(xslt)
newdom = transform(dom)
print(ET.tostring(newdom, pretty_print=True))