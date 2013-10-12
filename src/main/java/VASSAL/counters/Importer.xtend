package VASSAL.counters

import VASSAL.build.AbstractBuildable
import VASSAL.build.module.Map
import VASSAL.build.widget.ListWidget
import VASSAL.build.widget.PieceSlot
import com.google.gson.GsonBuilder
import org.apache.commons.lang.StringUtils
import org.junit.Test
import org.webboards.vassal.Board
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
		val modPath = "/home/rzymek/devel/github/vassal-import/Bastogne_v1_3.vmod"		
		val mod = ModuleLoader.instace.load(modPath)
		val module = new Module();
		module.pieces = mod.recurse(ListWidget).map[list|
				new Pieces() => [
					it.category = list.getAttributeValueString("entryName")
					it.list = list.recurse(PieceSlot).map[piece].map[piece|
//						if(piece.images.size > 1) {
//							println(piece);
//						}
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
				]
			].head
		println(gson.toJson(module))	
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
