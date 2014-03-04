package org.webboards.vassal

import java.awt.Dimension

class Module {
	public Board board
	public Pieces[] pieces
	public Dimension counterDim;
}

class Board {
	public String image
	public Integer width
	public Integer height
	public Grid grid
}

class Grid {
	public double hexSize
	public double hexWidth
	public int originX
	public int originY
}

class Pieces {
	public String category
	public Piece[] list
}

class Piece {
	public String name
	public String[] images
}
