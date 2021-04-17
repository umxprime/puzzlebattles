class_name CursorModel

var _pos:GridCoordinate
var _grid
func _init(grid, pos:GridCoordinate):
	_grid = grid
	_pos = pos
func grid():
	return _grid
func position()->GridCoordinate:
	return _pos.copy()
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
	return PoolIntArray([1, _grid.columns() - 2])
func _rowsRange() -> PoolIntArray :
	return PoolIntArray([0, _grid.visibleRows() - 2])
func setPosition(pos:GridCoordinate) -> bool:
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
