package VASSAL.counters

import VASSAL.build.module.Map
import VASSAL.build.module.map.boardPicker.board.HexGrid
import VASSAL.build.widget.PieceSlot
import org.webboards.vassal.ModuleLoader
import static extension VASSAL.counters.Importer.*;
class VassalLoaderTest {
	def void test() {
		val modPath = "/home/rzymek/devel/github/vassal-import/Bastogne_v1_3.vmod"
		val mod = ModuleLoader.instace.load(modPath)
		val map = mod.buildables.filter(Map).filter[mapName == 'Main Map'].head.boardPicker.getBoard('Map')

		//		val board = map.boards
		val grid = map.grid as HexGrid

		//		println(map.size);		
		//		println(grid.hexSize);
		//		println(mod.recurse(HexGrid))
		val pieces = mod.recurse(PieceSlot).map[it.piece];

	//		println(pieces)
	//		println(pieces.map[images].join('\n'))
	//		println(pieces.filter(UsePrototype).map[prototypeName+":"+images].join('\n'))
	//		println(mod.recurse(ListWidget).map[it.getAttributeValueString("entryName")].join('\n'));
	}
}
