package org.webboards.vassal

import com.google.common.collect.HashMultiset
import javax.xml.parsers.SAXParserFactory
import org.xml.sax.Attributes
import org.xml.sax.SAXException
import org.xml.sax.helpers.DefaultHandler

class Handler extends DefaultHandler {
	var indent = 0
	val INDENT = '   ';
	val struct = HashMultiset.create

	override startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		val name = qName.substring(qName.lastIndexOf('.') + 1)
		println((0 ..< indent).map[INDENT].join + name);
		indent = indent + 1;
	}

	override endElement(String uri, String localName, String qName) throws SAXException {
		indent = indent - 1;
	}

}

class Importer {
	def static void main(String[] args) {
		val parser = SAXParserFactory.newInstance.newSAXParser
		val handler = new Handler
		parser.parse("buildFile", handler);
	}

}
