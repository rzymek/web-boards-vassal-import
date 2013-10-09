package VASSAL.counters

import VASSAL.build.AbstractBuildable
import VASSAL.build.module.Map
import VASSAL.build.module.map.boardPicker.board.HexGrid
import VASSAL.build.widget.PieceSlot
import VASSAL.tools.menu.MenuBarProxy
import VASSAL.tools.menu.MenuManager
import com.google.common.collect.HashMultimap
import java.util.Iterator
import java.util.List
import java.util.NoSuchElementException
import javax.swing.JFrame
import javax.xml.parsers.DocumentBuilderFactory
import org.apache.commons.lang.StringUtils
import org.junit.Test
import org.w3c.dom.Element
import org.w3c.dom.Node
import org.w3c.dom.NodeList
import org.webboards.vassal.Imp

import static extension VASSAL.counters.NodeListIterator.*

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
		val pieces = mod.recurse(PieceSlot).map[it.piece];		
		println(pieces)
		println(pieces.map[images].join('\n'))
		println
		println(pieces.filter(UsePrototype).map[prototypeName+":"+images].join('\n'))
	}

	def dispatch Iterable<String> getImages(Embellishment e) {
		e.imageName.filter[!StringUtils.isEmpty(it)] + getImages(e.inner)
	}   
	def dispatch Iterable<String> getImages(Decorator e) {
		getImages(e.inner)
	}
	def dispatch Iterable<String> getImages(BasicPiece e) {
		#[e.imageName]
	}
	def dispatch Iterable<String> getImages(GamePiece e) {
		#[]
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
