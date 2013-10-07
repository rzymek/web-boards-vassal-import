package org.webboards.vassal

import com.google.common.collect.HashMultiset
import javax.xml.parsers.SAXParserFactory
import org.xml.sax.Attributes
import org.xml.sax.SAXException
import org.xml.sax.helpers.DefaultHandler
import java.util.Stack

class Handler extends DefaultHandler {
	var indent = 0
	val INDENT = '   ';
	public val struct = HashMultiset.create
	val stack = new Stack

	override startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		val name = qName.substring(qName.lastIndexOf('.') + 1)
		stack.push(name)
		val path = stack.join('/');
		struct.add(stack.clone)
//		println((0 ..< indent).map[INDENT].join + path);
		indent = indent + 1;
	}

	override endElement(String uri, String localName, String qName) throws SAXException {
		stack.pop
		indent = indent - 1;
	}

}

class Importer {
	def static void main(String[] args) {
		val parser = SAXParserFactory.newInstance.newSAXParser
		val handler = new Handler
		parser.parse("buildFile", handler);
		println(handler.struct.toString);
	}

}
