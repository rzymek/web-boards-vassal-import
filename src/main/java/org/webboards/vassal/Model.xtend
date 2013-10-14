package org.webboards.vassal

import de.oehme.xtend.contrib.typescript.TypeScript

@TypeScript
class Module {
	public Board board
	public Pieces[] pieces
}

@TypeScript
class Board {
	public String image
	public Integer width
	public Integer height
	public Grid grid
}

@TypeScript
class Grid {
	public double hexSize
	public double hexWidth
	public int originX
	public int originY
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
