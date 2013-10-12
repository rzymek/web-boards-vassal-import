package VASSAL.counters;

import VASSAL.build.Buildable;
import VASSAL.build.module.Map;
import VASSAL.build.module.map.BoardPicker;
import VASSAL.build.module.map.boardPicker.Board;
import VASSAL.build.module.map.boardPicker.board.HexGrid;
import VASSAL.build.module.map.boardPicker.board.MapGrid;
import VASSAL.build.widget.PieceSlot;
import VASSAL.counters.GamePiece;
import VASSAL.counters.Importer;
import VASSAL.launch.BasicModule;
import com.google.common.base.Objects;
import com.google.common.collect.Iterables;
import java.util.List;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.webboards.vassal.ModuleLoader;

@SuppressWarnings("all")
public class VassalLoaderTest {
  public void test() {
    try {
      final String modPath = "/home/rzymek/devel/github/vassal-import/Bastogne_v1_3.vmod";
      ModuleLoader _instace = ModuleLoader.getInstace();
      final BasicModule mod = _instace.load(modPath);
      List<Buildable> _buildables = mod.getBuildables();
      Iterable<Map> _filter = Iterables.<Map>filter(_buildables, Map.class);
      final Function1<Map,Boolean> _function = new Function1<Map,Boolean>() {
        public Boolean apply(final Map it) {
          String _mapName = it.getMapName();
          boolean _equals = Objects.equal(_mapName, "Main Map");
          return Boolean.valueOf(_equals);
        }
      };
      Iterable<Map> _filter_1 = IterableExtensions.<Map>filter(_filter, _function);
      Map _head = IterableExtensions.<Map>head(_filter_1);
      BoardPicker _boardPicker = _head.getBoardPicker();
      final Board map = _boardPicker.getBoard("Map");
      MapGrid _grid = map.getGrid();
      final HexGrid grid = ((HexGrid) _grid);
      Iterable<PieceSlot> _recurse = Importer.<PieceSlot>recurse(mod, PieceSlot.class);
      final Function1<PieceSlot,GamePiece> _function_1 = new Function1<PieceSlot,GamePiece>() {
        public GamePiece apply(final PieceSlot it) {
          GamePiece _piece = it.getPiece();
          return _piece;
        }
      };
      final Iterable<GamePiece> pieces = IterableExtensions.<PieceSlot, GamePiece>map(_recurse, _function_1);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}
