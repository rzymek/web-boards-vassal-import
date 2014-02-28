package VASSAL.counters

import VASSAL.build.AbstractBuildable
import VASSAL.build.module.Map
import VASSAL.build.module.map.boardPicker.board.HexGrid
import VASSAL.build.module.map.boardPicker.board.MapGrid
import VASSAL.build.module.map.boardPicker.board.ZonedGrid
import VASSAL.build.widget.ListWidget
import VASSAL.build.widget.PieceSlot
import com.google.common.io.Files
import com.google.gson.GsonBuilder
import java.io.File
import java.nio.charset.StandardCharsets
import java.util.Arrays
import org.apache.commons.lang.StringUtils
import org.junit.Test
import org.webboards.vassal.Board
import org.webboards.vassal.Grid
import org.webboards.vassal.Module
import org.webboards.vassal.ModuleLoader
import org.webboards.vassal.Piece
import org.webboards.vassal.Pieces

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
//		val modPath = "/home/rzymek/tmp/bfg/BattleForGermany.vmod"		
//		val modPath = "/home/rzymek/Dropbox/devel/board/pieklo-na-pacyfiku/Kryptonim_Lew_Morski.vmod"
//		val modPath = "/home/rzymek/devel/github/vassal-import/Bastogne_v1_3.vmod";
		val modPath = "/home/rzymek/devel/github/vassal-import/RedWinter_v1.1b06.vmod";
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
//					].filter[//bastgne
//						!name.toLowerCase.endsWith("-tar")
					].toList 
				]
			].filter[!list.empty]
			.toList 
		module.board = mod.recurse(Map)
			.filter[mapName=='Main Map']
			.map[boardPicker.configureComponents]
			.map[Arrays::asList(it)]
			.flatten
			.filter(typeof(VASSAL.build.module.map.boardPicker.Board))
			.map[board|
				new Board() => [
					it.image = board.fileName
					it.width = board.size.width
					it.height = board.size.height
					it.grid = board.grid?.convert
				]
			].head
		
		val json = gson.toJson(module);
		val target = new File("/home/rzymek/devel/github/mboards/public/games/red-winter/") => [mkdirs];
		Files.write(
			json, 
			new File(target,"game.json"), 
			StandardCharsets.UTF_8
		);
		println(json);		
	}
	def dispatch Grid convert(ZonedGrid grid){
		grid.zones.map[it.grid].filterNull.filter(HexGrid).head?.convert		
	}
	
	def dispatch Grid convert(HexGrid grid){
		new Grid() => [ 
			it.hexSize = grid.hexSize
			it.hexWidth = grid.hexWidth
			it.originX = grid.origin.x
			it.originY = grid.origin.y
		]
	}
	def dispatch Grid convert(MapGrid grid){
		throw new RuntimeException("Unsupported grid: "+grid.class.simpleName)
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
