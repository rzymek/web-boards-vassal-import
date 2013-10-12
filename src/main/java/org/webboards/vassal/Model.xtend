package org.webboards.vassal

import de.oehme.xtend.contrib.typescript.TypeScript

@TypeScript
class Module {
	public Pieces[] pieces
	public Board board
}

@TypeScript
class Board {
	public String image
}

@TypeScript
class Pieces {
	public String category
	public Piece[] list
}

@TypeScript
class Piece {
	public String name
	public String[] images
}
