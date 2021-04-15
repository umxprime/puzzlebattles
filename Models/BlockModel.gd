class_name BlockModel

var _type:int
var _pos:GridCoordinate
var _grid
var _needsDisplay:bool

static func shuffleType()->int:
	return randi() % (Enums.BlockType.U-Enums.BlockType.A+1) + Enums.BlockType.A
	
func _init(grid, pos:GridCoordinate, type = Enums.BlockType.Empty):
	_pos = pos
	_grid = grid
	_type = type
	_needsDisplay = true
func grid():
	return _grid
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
func blockAt(location:int) -> BlockModel:
	var pos = position()
	match location:
		Enums.Location.Over:
			pos.row += 1
		Enums.Location.Under:
			pos.row -= 1
		Enums.Location.LeftSide:
			pos.column -= 1
			if pos.column%2==1:
				pos.row +=1
		Enums.Location.RightSide:
			pos.column += 1
			if pos.column%2==1:
				pos.row +=1
		_:
			return null
	return _grid.blockAt(pos)
func process(delta):
	pass
