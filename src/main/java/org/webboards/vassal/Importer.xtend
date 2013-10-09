package org.webboards.vassal

import VASSAL.build.AbstractBuildable
import VASSAL.build.module.Map
import VASSAL.build.module.map.boardPicker.board.HexGrid
import VASSAL.build.widget.PieceSlot
import VASSAL.counters.Decorator
import VASSAL.tools.menu.MenuBarProxy
import VASSAL.tools.menu.MenuManager
import com.google.common.collect.HashMultimap
import java.util.Iterator
import java.util.NoSuchElementException
import javax.swing.JFrame
import javax.xml.parsers.DocumentBuilderFactory
import org.junit.Test
import org.w3c.dom.Element
import org.w3c.dom.Node
import org.w3c.dom.NodeList

import static extension org.webboards.vassal.NodeListIterator.*

class XMenuManager extends MenuManager {
    val editorBar = new MenuBarProxy();
	
	override getMenuBarFor(JFrame fc) {
		editorBar.createPeer
	}
	
	override getMenuBarProxyFor(JFrame fc) {
		editorBar
	}

  }
class Importer {
	def static void main(String[] args) {
		new Importer().run
	}
	
	@Test
	def void run() {
		val mod = Imp.run
		val map = mod.buildables.filter(Map).filter[mapName=='Main Map'].head.boardPicker.getBoard('Map')
		println(map)
//		val board = map.boards
		val grid = map.grid as HexGrid
		println(map.size);		
		println(grid.hexSize);
		
		println(mod.recurse(HexGrid))
		val pieces = mod.recurse(PieceSlot).map[it.piece].filter(Decorator).map[it.inner].join('\n')
		println(pieces)
	}
	
	def <T> Iterable<T> recurse(AbstractBuildable b, Class<T> type) {
		b.buildables.filter(type) + b.buildables.filter(AbstractBuildable).map[recurse(type)].flatten
	}
	
	def void run1() {
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
