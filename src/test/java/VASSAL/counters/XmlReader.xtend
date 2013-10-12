package VASSAL.counters

import com.google.common.collect.HashMultimap
import javax.xml.parsers.DocumentBuilderFactory
import org.junit.Ignore
import org.junit.Test
import org.w3c.dom.Element

import static extension org.webboards.vassal.NodeListIterator.*

class XmlReader {
	@Test @Ignore
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
		children.map[it.getShortName -> it]
			.forEach[map.put(key, value)]
		val types = map.keys.entrySet
			.map[element -> if(count > 1) {
				element+'Array' 
			}else{
				element ; } ];
		'''
		class «node.getShortName» {
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
