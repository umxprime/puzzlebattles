class_name GridModel

class GridCoordinate:
	var row:int = 0
	var column:int = 0
	func _init(row:int, column:int):
		self.row = row
		self.column = column
	func _to_string():
		return "row:%d,column:%d" % [self.row, self.column]
	func copy() -> GridCoordinate:
		return GridCoordinate.new(row, column)

class CursorModel:
	var _pos:GridCoordinate
	var _grid:GridModel
	func _init(grid:GridModel, pos:GridCoordinate):
		_grid = grid
		_pos = pos
	func grid():
		return _grid
	func position()->GridCoordinate:
		return _pos.copy()
	func moveTo(direction:int) -> bool:
		var newPos = position()
		match direction:
			Direction.Up:
				newPos.row += 1
			Direction.Down:
				newPos.row -= 1
			Direction.Left:
				newPos.column -= 1
			Direction.Right:
				newPos.column += 1
		return setPosition(newPos)
	func setPosition(pos:GridCoordinate) -> bool:
		if (pos.column < 1):
			pos.column = 1
		if (pos.column >= _grid.columns() - 1):
			if pos.column%2==1 && pos.row > 0:
				pos.row -=1
			pos.column = _grid.columns() - 2
		if (pos.row < 0) :
			pos.row = 0
		if (pos.row >= _grid.visibleRows() - 1):
			pos.row = _grid.visibleRows() - 2
		if _pos.column == pos.column && _pos.row == pos.row:
			return false
		_pos.column = pos.column
		_pos.row = pos.row
		return true

class Cell:
	enum BlockType {
		Unknown = 0,
		Empty = 1,
		A = 2,
		E = 3,
		I = 4,
		O = 5,
		U = 6,
		Y = 7
	}
	var _type:int
	var _pos:GridCoordinate
	var _grid:GridModel
	var _needsDisplay:bool
	
	static func shuffleType()->int:
		return randi() % (Cell.BlockType.U-Cell.BlockType.A+1) + Cell.BlockType.A
		
	func _init(grid:GridModel, pos:GridCoordinate, type = BlockType.Empty):
		_pos = pos
		_grid = grid
		_type = type
		_needsDisplay = true
	func setNeedsDisplay(value:bool) :
		_needsDisplay = value
	func needsDisplay() -> bool :
		return _needsDisplay
	func type()->int:
		return _type
	func setType(type:int):
		_type = type
	func position() -> GridCoordinate:
		return _pos.copy()
	func setPosition(pos:GridCoordinate):
		_needsDisplay = true
		_pos.row = pos.row
		_pos.column = pos.column
	func cellAt(location:int) -> Cell:
		var pos = position()
		match location:
			Location.Over:
				pos.row += 1
			Location.Under:
				pos.row -= 1
			Location.LeftSide:
				pos.column -= 1
				if pos.column%2==1:
					pos.row +=1
			Location.RightSide:
				pos.column += 1
				if pos.column%2==1:
					pos.row +=1
			_:
				return null
		return _grid.cellAt(pos)
	func process(delta):
		pass
	

enum Location {
	Over,
	Under,
	LeftSide,
	RightSide
}

enum Direction {
	Up,
	Down
	Left,
	Up
}

enum Rotation {
	Clockwise,
	CounterClockwize
}

var _cells=[]
var _columns:int
var _rows:int
var _visibleRows:int
var _cursor:CursorModel
func _init(columns:int, rows:int):
	_columns = columns
	_visibleRows = rows
	_rows = rows * 2
	_cursor = CursorModel.new(self, GridCoordinate.new(rows / 2, columns / 2))
	_fill()
func cells() -> Array:
	return _cells.duplicate()
func columns() -> int :
	return _columns
func visibleRows() -> int :
	return _visibleRows
func rows() -> int :
	return _rows
func cellAt(pos:GridCoordinate) -> Cell :
	if (pos.row < 0 || pos.row + 1 > _rows || pos.column < 0 || pos.column + 1 > _columns) :
		return null
	return _cells[cellIndex(pos)]
func cellIndex(pos:GridCoordinate) -> int :
	return pos.column + pos.row * _columns
func move(cell:Cell, pos:GridCoordinate):
	cell.setPosition(pos)
	_cells[cellIndex(pos)] = cell
func cursor()->CursorModel:
	return _cursor
func swap(from:Cell, to:Cell):
	var fromPos = from.position()
	var toPos = to.position()
	move(from, toPos)
	move(to, fromPos)
func breakSingle(cell:Cell):
	cell.setType(Cell.BlockType.Empty)
	while cell.cellAt(Location.Over) != null :
		swap(cell, cell.cellAt(Location.Over))
func breakDiamond():
	var cell = cellAt(_cursor.position())
	if cell.needsDisplay() :
		return
	var over = cell.cellAt(Location.Over)
	if over.needsDisplay() :
		return
	var left = cell.cellAt(Location.LeftSide)
	if left.needsDisplay() :
		return
	var right = cell.cellAt(Location.RightSide)
	if right.needsDisplay() :
		return
	breakSingle(cell)
	breakSingle(over)
	breakSingle(left)
	breakSingle(right)
func rotate(rotation:int):
		var cell = cellAt(_cursor.position())
		var over = cell.cellAt(Location.Over)
		var left = cell.cellAt(Location.LeftSide)
		var right = cell.cellAt(Location.RightSide)
		match rotation:
			Rotation.Clockwise:
				swap(cell,right)
				swap(cell,over)
				swap(cell,left)
			Rotation.CounterClockwize:
				swap(cell,left)
				swap(cell,over)
				swap(cell,right)
			_:
				pass
func _fill():
	var cell:Cell
	var pos:GridCoordinate
	var type:int
	for row in range(0, _rows):
		for column in range(0, _columns):
			pos = GridCoordinate.new(row, column)
			cell = Cell.new(self, pos, Cell.shuffleType())
			_cells.append(cell)
