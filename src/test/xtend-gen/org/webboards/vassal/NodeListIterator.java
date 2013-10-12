package org.webboards.vassal;

import java.util.Iterator;
import java.util.NoSuchElementException;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

@SuppressWarnings("all")
public class NodeListIterator implements Iterator<Node>, Iterable<Node> {
  private int index = 0;
  
  private NodeList n;
  
  public NodeListIterator(final NodeList n) {
    this.n = n;
  }
  
  public boolean hasNext() {
    int _length = this.n.getLength();
    boolean _lessThan = (this.index < _length);
    return _lessThan;
  }
  
  public Node next() {
    boolean _hasNext = this.hasNext();
    if (_hasNext) {
      final Node item = this.n.item(this.index);
      int _plus = (this.index + 1);
      this.index = _plus;
      return item;
    } else {
      NoSuchElementException _noSuchElementException = new NoSuchElementException();
      throw _noSuchElementException;
    }
  }
  
  public void remove() {
    UnsupportedOperationException _unsupportedOperationException = new UnsupportedOperationException();
    throw _unsupportedOperationException;
  }
  
  public Iterator<Node> iterator() {
    NodeListIterator _nodeListIterator = new NodeListIterator(this.n);
    return _nodeListIterator;
  }
  
  public static Iterable<Node> iterator(final NodeList n) {
    NodeListIterator _nodeListIterator = new NodeListIterator(n);
    return _nodeListIterator;
  }
}
