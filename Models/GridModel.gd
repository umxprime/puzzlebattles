class_name GridModel

class GridCoordinate:
	var row:int = 0
	var column:int = 0
	func _init(row:int, column:int):
		self.row = row
		self.column = column
	func copy() -> GridCoordinate:
		return GridCoordinate.new(row, column)

class CursorModel:
	var _pos:GridCoordinate
	var _grid:GridModel
	func _init(grid:GridModel, pos:GridCoordinate):
		_grid = grid
		_pos = pos
	func position()->GridCoordinate:
		return _pos
	func moveTo(direction:int):
		var newPos = _pos.copy()
		match direction:
			Direction.Up:
				newPos.y += 1
			Direction.Down:
				newPos.y -= 1
			Direction.Left:
				newPos.x -= 1
			Direction.Right:
				newPos.x += 1
		if (newPos.x < 1 || newPos.x == _grid.columns() - 1):
			return
		if (newPos.y < 0 || newPos.y == _grid.rows() - 1):
			return
		_pos = newPos

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
	func _init(grid:GridModel, pos:GridCoordinate, type = BlockType.Empty):
		_pos = pos
		_grid = grid
		_type = type
	func position() -> GridCoordinate:
		return _pos
	func setPosition(pos:GridCoordinate):
		_pos.row = pos.row
		_pos.column = pos.column
	func cellAt(location:int) -> Cell:
		var pos = _pos.copy()
		match location:
			Location.Over:
				pos.row += 1
			Location.Under:
				pos.row -= 1
			Location.LeftSide:
				pos.column -= 1
			Location.RightSide:
				pos.column += 1
			_:
				return null
		return _grid.cellAt(pos)
	

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
var _cursor:CursorModel
func _init(columns:int, rows:int):
	_columns = columns
	_rows = rows
	_cursor = CursorModel.new(self, GridCoordinate.new(rows / 2, columns / 2))
	_fill()
func cells() -> Array:
	return _cells.duplicate()
func columns() -> int :
	return _columns
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
func swap(from:Cell, to:Cell):
	var fromPos = from.position().copy()
	var toPos = to.position().copy()
	move(from, toPos)
	move(to, fromPos)
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
			type = randi() % (Cell.BlockType.O-Cell.BlockType.A+1) + Cell.BlockType.A
			cell = Cell.new(self, pos, type)
			_cells.append(cell)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
