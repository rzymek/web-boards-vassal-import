package VASSAL.counters

import VASSAL.build.AbstractBuildable
import VASSAL.build.GameModule
import VASSAL.build.module.Map
import VASSAL.build.module.map.SetupStack
import VASSAL.build.module.map.boardPicker.board.HexGrid
import VASSAL.build.module.map.boardPicker.board.MapGrid
import VASSAL.build.module.map.boardPicker.board.ZonedGrid
import VASSAL.build.widget.ListWidget
import VASSAL.build.widget.PieceSlot
import com.google.common.collect.Iterables
import com.google.common.io.Files
import com.google.gson.GsonBuilder
import java.awt.Dimension
import java.io.BufferedReader
import java.io.File
import java.io.FileOutputStream
import java.io.FileReader
import java.io.InputStream
import java.nio.charset.StandardCharsets
import java.util.Arrays
import java.util.zip.ZipFile
import javax.imageio.ImageIO
import org.apache.commons.io.IOUtils
import org.apache.commons.lang.StringUtils
import org.junit.Test
import org.webboards.vassal.Board
import org.webboards.vassal.Grid
import org.webboards.vassal.Module
import org.webboards.vassal.ModuleLoader
import org.webboards.vassal.Piece
import org.webboards.vassal.Pieces

import static extension org.apache.commons.lang.StringUtils.*

class Importer {
	val OUT_BASE = new File("/home/rzymek/devel/github/web-boards/public/games/")

	val gson = new GsonBuilder().setPrettyPrinting.create

	def static void main(String[] args) {
		new Importer().run
		System.exit(0);
	}

//	val modPath = "/home/rzymek/devel/github/vassal-import/Bastogne_v1_3.vmod" -> 'bastogne';
//	val modPath = "/home/rzymek/Dropbox/devel/board/pieklo-na-pacyfiku/seelowe.vmod" -> 'seelowe';
	val modPath = "/home/rzymek/devel/github/vassal-import/RedWinter_v1.1b06.vmod" -> 'red-winter';
//	val modPath = "/home/rzymek/devel/github/vassal-import/Afrika_II_v0.9.vmod" -> 'africa2';

	@Test
	def void vsav() {
		println("Web-Boards Vassal Importer...")
		val mod = ModuleLoader.instace.load(modPath.key)
		
		val f = 'b/savedGame';
		val in = new BufferedReader(new FileReader(f));
		val ds = IOUtils.toString(in);
		println(ds);
		println(GameModule.getGameModule().decode(ds));
		in.close();
	}

	@Test
	def void run() {
		println("Web-Boards Vassal Importer...")
		val mod = ModuleLoader.instace.load(modPath.key)
		val module = new Module();
		val palette= mod.recurse(ListWidget)
			.map [ list |
				new Pieces() => [
					it.category = list.getAttributeValueString("entryName")
					it.list = list.toPieceList
				]
			].filter[!list.empty].toList
		val setup = mod.recurse(SetupStack).map[stack|
			new Pieces() => [
				it.category = stack.configureName
				it.list = stack.toPieceList
			]
		]
		module.pieces = Iterables::concat(palette, setup)
		
		module.board = mod.recurse(Map)
			.filter[mapName == 'Main Map']
			.map[boardPicker.configureComponents]
			.map[
				Arrays::asList(it)].flatten.filter(typeof(VASSAL.build.module.map.boardPicker.Board))
				.map [ board | new Board() => [
					it.image = board.fileName
					it.width = board.size.width
					it.height = board.size.height
					it.grid = board.grid?.convert
				]
			].head
		val archive = new ZipFile(modPath.key);
		var maxCounterSize = module.pieces.map[list.map[images
			.map[getImageSize(it, archive)].filterNull
		].flatten].flatten
			.fold(new Dimension(0,0), [r,t|
				new Dimension(
					Math.max(r.width, t.width),
					Math.max(r.height, t.height)
				)
			])
		module.counterDim = maxCounterSize;	
			
//		bastogne(module)
//		seelowe(module)
		
		val json = gson.toJson(module);
		val target = new File(OUT_BASE, modPath.value) => [mkdirs];
		Files.write(
			json,
			new File(target, "game.json"),
			StandardCharsets.UTF_8
		);
		println(json);
		
		copyImages(module, target, archive)
	}
	
	def copyImages(Module module, File targetDir, ZipFile archive) {
		val target = new File(targetDir, 'images') => [mkdirs]
		copyImage(archive, target, module.board.image);
		module.pieces.map[list.toList].flatten.map[it.images.toList].flatten.forEach[
			copyImage(archive, target, it)
		]		
	}
	
	def copyImage(ZipFile archive, File targetDir, String filename) {
		println(filename);
		archive.get('images/'+filename).writeTo(new File(targetDir, filename))
	}
	
	def void writeTo(InputStream in, File file) {
		val out = new FileOutputStream(file);
		try {
			IOUtils.copy(in, out);
		}finally{
			in.close();
		}
	}
	
	def get(ZipFile archive, String filename) {
		archive.getInputStream(archive.getEntry(filename))
	}
	
	def seelowe(Module module) {
		module.counterDim.width = 80;
		module.counterDim.height = 80;
	}
	
	def toPieceList(AbstractBuildable buildable) {
		buildable.recurse(PieceSlot)
			.map[piece]
			.map [ piece | new Piece() => [
					it.name = piece.name
					it.images = piece.images.filter[!blank]
				]
			].toList				
	}

	def getImageSize(String filename, ZipFile archive) {
		try {
			val in = ImageIO::createImageInputStream(archive.get('images/'+filename));
			if(in == null)
				return null;  
			try {
				val readers = ImageIO::getImageReaders(in);
				if(readers.hasNext()) {
					val reader = readers.next
					reader.input = in;
					return new Dimension(
						reader.getWidth(0),
						reader.getHeight(0)
					);
				} else {
					throw new RuntimeException("can't read "+filename);
				}
			} finally {
				in.close();
			}
		}catch(Exception ex){
			throw new RuntimeException(filename+": "+archive, ex);			
		}
	}

	def bastogne(Module module) {
		module.scale(0.5)
		module.pieces.forEach [
			list = list.filter [
				!name.toLowerCase.endsWith("-tar")
			]
		]
		module.pieces = module.pieces.filter [
			!list.empty
		]
		module.board.image = 'board-low.jpg'
		return module
	}

	def scale(Module mod, double scale) {
		val Board b = mod.board
		b.width = (b.width * scale) as int
		b.height = (b.height * scale) as int
		b.grid.hexSize = b.grid.hexSize * scale
		b.grid.hexWidth = b.grid.hexWidth * scale
		b.grid.originX = (b.grid.originX * scale) as int
		b.grid.originY = (b.grid.originY * scale) as int
		mod.counterDim = new Dimension(
			(mod.counterDim.width * scale) as int,
			(mod.counterDim.height * scale) as int
		)
		return mod
	}

	def dispatch Grid convert(ZonedGrid grid) {
		grid.zones.map[it.grid].filterNull.filter(HexGrid).head?.convert
	}

	def dispatch Grid convert(HexGrid grid) {
		new Grid() => [
			it.hexSize = grid.hexSize
			it.hexWidth = grid.hexWidth
			it.originX = grid.origin.x
			it.originY = grid.origin.y
		]
	}

	def dispatch Grid convert(MapGrid grid) {
		throw new RuntimeException("Unsupported grid: " + grid.class.simpleName)
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
