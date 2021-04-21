class_name CursorModel

var _pos
var _node:Node
var _grid
func _init(node, pos, grid):
	_node = node
	_pos = pos
	_grid = grid
	_node.connect("ready", self, "_onNodeReady")
func _onNodeReady():
	var state = {
		position = _pos,
		grid = _grid
	}
	_node.configure(state)
func node():
	return _node
func position()->Dictionary:
	return _pos.duplicate()
func moveTo(direction:int) -> bool:
	var newPos = position()
	match direction:
		Enums.Direction.Up:
			newPos.row += 1
		Enums.Direction.Down:
			newPos.row -= 1
		Enums.Direction.Left:
			newPos.column -= 1
		Enums.Direction.Right:
			newPos.column += 1
	return setPosition(newPos)
func _columnsRange() -> PoolIntArray :
	return PoolIntArray([1, _grid.columns - 2])
func _rowsRange() -> PoolIntArray :
	return PoolIntArray([0, _grid.rows - 2])
func setPosition(pos) -> bool:
	if (pos.column < _columnsRange()[0]):
		pos.column = _columnsRange()[0]
	if (pos.column > _columnsRange()[1]):
		if pos.column%2==1 && pos.row > 0:
			pos.row -=1
		pos.column = _columnsRange()[1]
	if (pos.row < _rowsRange()[0]) :
		pos.row = _rowsRange()[0]
	if (pos.row > _rowsRange()[1]):
		pos.row = _rowsRange()[1]
	if _pos.column == pos.column && _pos.row == pos.row:
		return false
	_pos.column = pos.column
	_pos.row = pos.row
	return true
