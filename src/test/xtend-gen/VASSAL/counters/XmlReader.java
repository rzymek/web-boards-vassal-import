package VASSAL.counters;

import VASSAL.counters.Importer;
import com.google.common.collect.HashMultimap;
import com.google.common.collect.Iterables;
import com.google.common.collect.Multiset;
import com.google.common.collect.Multiset.Entry;
import java.io.InputStream;
import java.util.Set;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Ignore;
import org.junit.Test;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.webboards.vassal.NodeListIterator;

@SuppressWarnings("all")
public class XmlReader {
  @Test
  @Ignore
  public void run() {
    try {
      DocumentBuilderFactory _newInstance = DocumentBuilderFactory.newInstance();
      final DocumentBuilder parser = _newInstance.newDocumentBuilder();
      InputStream _resourceAsStream = Importer.class.getResourceAsStream("/buildFile");
      final Document doc = parser.parse(_resourceAsStream);
      Element _documentElement = doc.getDocumentElement();
      CharSequence _printNodes = XmlReader.printNodes(_documentElement);
      InputOutput.<CharSequence>println(_printNodes);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public static CharSequence printNodes(final Element node) {
    CharSequence _xblockexpression = null;
    {
      NodeList _childNodes = node.getChildNodes();
      Iterable<Node> _iterator = NodeListIterator.iterator(_childNodes);
      final Iterable<Element> children = Iterables.<Element>filter(_iterator, Element.class);
      final HashMultimap<String,Element> map = HashMultimap.<String, Element>create();
      final Function1<Element,Pair<String,Element>> _function = new Function1<Element,Pair<String,Element>>() {
        public Pair<String,Element> apply(final Element it) {
          String _shortName = XmlReader.getShortName(it);
          Pair<String,Element> _mappedTo = Pair.<String, Element>of(_shortName, it);
          return _mappedTo;
        }
      };
      Iterable<Pair<String,Element>> _map = IterableExtensions.<Element, Pair<String,Element>>map(children, _function);
      final Procedure1<Pair<String,Element>> _function_1 = new Procedure1<Pair<String,Element>>() {
        public void apply(final Pair<String,Element> it) {
          String _key = it.getKey();
          Element _value = it.getValue();
          map.put(_key, _value);
        }
      };
      IterableExtensions.<Pair<String,Element>>forEach(_map, _function_1);
      Multiset<String> _keys = map.keys();
      Set<Entry<String>> _entrySet = _keys.entrySet();
      final Function1<Entry<String>,Pair<String,String>> _function_2 = new Function1<Entry<String>,Pair<String,String>>() {
        public Pair<String,String> apply(final Entry<String> it) {
          String _element = it.getElement();
          String _xifexpression = null;
          int _count = it.getCount();
          boolean _greaterThan = (_count > 1);
          if (_greaterThan) {
            String _element_1 = it.getElement();
            String _plus = (_element_1 + "Array");
            _xifexpression = _plus;
          } else {
            String _element_2 = it.getElement();
            _xifexpression = _element_2;
          }
          Pair<String,String> _mappedTo = Pair.<String, String>of(_element, _xifexpression);
          return _mappedTo;
        }
      };
      final Iterable<Pair<String,String>> types = IterableExtensions.<Entry<String>, Pair<String,String>>map(_entrySet, _function_2);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("class ");
      String _shortName = XmlReader.getShortName(node);
      _builder.append(_shortName, "");
      _builder.append(" {");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      _builder.append("private node: any;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("constructor(node:any) {");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("this.node = node;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("}  ");
      _builder.newLine();
      _builder.append("\t");
      final Function1<Pair<String,String>,String> _function_3 = new Function1<Pair<String,String>,String>() {
        public String apply(final Pair<String,String> it) {
          StringConcatenation _builder = new StringConcatenation();
          String _key = it.getKey();
          _builder.append(_key, "");
          _builder.append("():any { return this.node[\'");
          String _key_1 = it.getKey();
          Set<Element> _get = map.get(_key_1);
          Element _head = IterableExtensions.<Element>head(_get);
          String _tagName = _head.getTagName();
          _builder.append(_tagName, "");
          _builder.append("\'];}");
          return _builder.toString();
        }
      };
      Iterable<String> _map_1 = IterableExtensions.<Pair<String,String>, String>map(types, _function_3);
      String _join = IterableExtensions.join(_map_1, "\n");
      _builder.append(_join, "	");
      _builder.newLineIfNotEmpty();
      _builder.append("}");
      _builder.newLine();
      _xblockexpression = (_builder);
    }
    return _xblockexpression;
  }
  
  public static String getShortName(final Element it) {
    String _tagName = it.getTagName();
    String _tagName_1 = it.getTagName();
    int _lastIndexOf = _tagName_1.lastIndexOf(".");
    int _plus = (_lastIndexOf + 1);
    String _substring = _tagName.substring(_plus);
    return _substring;
  }
}
