interface Module {
	pieces: Pieces[];
	board: Board;
} 

interface Board {
	image: string;
} 

interface Pieces {
	category: string;
	list: Piece[];
} 

interface Piece {
	name: string;
	images: String[];
} 
