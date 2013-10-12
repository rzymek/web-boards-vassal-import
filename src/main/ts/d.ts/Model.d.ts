interface Module {
	pieces: Pieces[];
	board: Board;
} 

interface Board {
	image: string;
	width: number;
	height: number;
	grid: Grid;
} 

interface Grid {
	hexSize: number;
	hexWidth: number;
	originX: number;
	originY: number;
} 

interface Pieces {
	category: string;
	list: Piece[];
} 

interface Piece {
	name: string;
	images: String[];
} 
