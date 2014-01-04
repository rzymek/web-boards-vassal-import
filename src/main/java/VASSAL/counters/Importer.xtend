package VASSAL.counters

import VASSAL.build.AbstractBuildable
import VASSAL.build.module.Map
import VASSAL.build.module.map.boardPicker.board.HexGrid
import VASSAL.build.widget.ListWidget
import VASSAL.build.widget.PieceSlot
import com.google.gson.GsonBuilder
import org.apache.commons.lang.StringUtils
import org.junit.Test
import org.webboards.vassal.Board
import org.webboards.vassal.Grid
import org.webboards.vassal.Module
import org.webboards.vassal.ModuleLoader
import org.webboards.vassal.Piece
import org.webboards.vassal.Pieces
import VASSAL.build.module.map.boardPicker.board.MapGrid

class Importer {
	val gson = new GsonBuilder()
		.setPrettyPrinting
		.create
	def static void main(String[] args) {
		new Importer().run
		System.exit(0);
	}
	
	@Test
	def void run() {
		println("Vassal Counter Sheet...")
		val modPath = "/home/rzymek/tmp/bfg/BattleForGermany.vmod"///home/rzymek/devel/github/vassal-import/Bastogne_v1_3.vmod"		
		val mod = ModuleLoader.instace.load(modPath)
		val module = new Module();
		module.pieces = mod.recurse(ListWidget).map[list|
				new Pieces() => [
					it.category = list.getAttributeValueString("entryName")
					it.list = list.recurse(PieceSlot).map[piece].map[piece|
						new Piece() => [
							it.name = piece.name
							it.images = piece.images						
						]
					].toList 
				]
			].toList 
		module.board = mod.recurse(Map)
			.filter[mapName=='Main Map']
			.map[boardPicker.getBoard('Map')]
			.map[board|
				new Board() => [
					it.image = board.fileName
					it.width = board.size.width
					it.height = board.size.height
					it.grid = board.grid.convert
				]
			].head
		println(gson.toJson(module))	
	}
	def dispatch convert(HexGrid grid){
		new Grid() => [ 
			it.hexSize = grid.hexSize
			it.hexWidth = grid.hexWidth
			it.originX = grid.origin.x
			it.originY = grid.origin.y
		]
	}
	def dispatch Grid convert(MapGrid grid){
		throw new RuntimeException("Unsupported grid: "+grid)
	}
	
	def dispatch Iterable<String> getImages(Embellishment e) {
		getImages(e.inner) + e.imageName.filter[!StringUtils.isEmpty(it)] 
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
		
	def static <T> Iterable<T> recurse(AbstractBuildable b, Class<T> type) {
		b.buildables.filter(type) + b.buildables.filter(AbstractBuildable).map[recurse(type)].flatten
	}
}
