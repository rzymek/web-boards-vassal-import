package org.webboards.vassal

import com.google.common.collect.HashMultimap
import java.util.Iterator
import java.util.NoSuchElementException
import javax.xml.parsers.DocumentBuilderFactory
import org.junit.Test
import org.w3c.dom.Element
import org.w3c.dom.Node
import org.w3c.dom.NodeList

import static extension org.webboards.vassal.NodeListIterator.*

class Importer {
	def static void main(String[] args) {
		new Importer().run
	}
	
	@Test
	def void run() {
		val parser = DocumentBuilderFactory.newInstance.newDocumentBuilder
		val doc = parser.parse(Importer.getResourceAsStream("/buildFile"));
		println(printNodes(doc.documentElement));
	}
	
	def static printNodes(Element node) { 
		val children = node.childNodes
			.iterator
			.filter(Element);
		val HashMultimap<String, Element> map = HashMultimap.create
		children.map[it.shortName -> it]
			.forEach[map.put(key, value)]
		val types = map.keys.entrySet
			.map[element -> if(count > 1) {
				element+'Array' 
			}else{
				element 
			}];
		'''
		class «node.shortName» {
			private node: any;
			constructor(node:any) {
				this.node = node;
			}  
			«types.map['''«key»():any { return this.node['«map.get(key).head.tagName»'];}'''].join('\n')»
		}
«««		«types.map[key].join('\n')»
		'''		
	}
	
	def static getShortName(Element it) {
		tagName.substring(tagName.lastIndexOf('.') + 1)
	}
}

class NodeListIterator implements Iterator<Node>, Iterable<Node> {
	var index = 0
	NodeList n

	new(NodeList n) {
		this.n = n;
	}

	override hasNext() {
		index < n.length
	}

	override next() {
		if (hasNext) {
			val item = n.item(index);
			index = index + 1;
			return item;
		} else {
			throw new NoSuchElementException();
		}
	}

	override remove() {
		throw new UnsupportedOperationException();
	}

	override iterator() {
		new NodeListIterator(n);
	}
	static def Iterable<Node> iterator(NodeList n) {
		new NodeListIterator(n);
	}
}
