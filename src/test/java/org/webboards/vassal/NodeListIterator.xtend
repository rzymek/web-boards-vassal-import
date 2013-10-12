package org.webboards.vassal

import java.util.Iterator
import java.util.NoSuchElementException
import org.w3c.dom.Node
import org.w3c.dom.NodeList

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
