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
