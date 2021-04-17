class_name GridModel

class Diamond:
	var _down:BlockModel
	var _left:BlockModel
	var _top:BlockModel
	var _right:BlockModel
	func _init(down:BlockModel, left:BlockModel, top:BlockModel, right:BlockModel):
		_down = down
		_left = left
		_top = top
		_right = right
	func blocks() -> Array:
		return [_down, _left, _top, _right]
	func haveSameType() -> bool:
		return _down.type() == _left.type() && _left.type() == _top.type() && _top.type() == _right.type()

var _blocks=[]
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
func blocks() -> Array:
	return _blocks.duplicate()
func columns() -> int :
	return _columns
func visibleRows() -> int :
	return _visibleRows
func rows() -> int :
	return _rows
func _blockAt(row, column) -> BlockModel :
	if (row < 0 || row + 1 > _rows || column < 0 || column + 1 > _columns) :
		return null
	return _blocks[_blockIndex(row, column)]
func blockAt(pos:GridCoordinate) -> BlockModel :
	return _blockAt(pos.row, pos.column)
func _blockIndex(row, column) -> int:
	return column + row * _columns
func blockIndex(pos:GridCoordinate) -> int :
	return _blockIndex(pos.row, pos.column)
func move(block:BlockModel, pos:GridCoordinate):
	block.setPosition(pos)
	_blocks[blockIndex(pos)] = block
func _evaluate():
	for row in range(0, visibleRows() - 2):
		for column in range(1, columns() - 2):
			var diamond: Diamond = _diamondAt(row, column)
			if diamond == null : continue
			if !diamond.haveSameType():
				continue
			for block in diamond.blocks():
				breakSingle(block)
			pass
func _diamondAt(row, column) -> Diamond:
	var down = _blockAt(row, column)
	if down == null: return null
	var top = down.blockAt(Enums.Location.Over)
	if top == null: return null
	var left = down.blockAt(Enums.Location.LeftSide)
	if left == null: return null
	var right = down.blockAt(Enums.Location.RightSide)
	if right == null: return null
	return Diamond.new(down, left, top, right)
func cursor()->CursorModel:
	return _cursor
func swap(from:BlockModel, to:BlockModel):
	var fromPos = from.position()
	var toPos = to.position()
	move(from, toPos)
	move(to, fromPos)
func breakSingle(block:BlockModel):
	block.setType(Enums.BlockType.Empty)
	while block.blockAt(Enums.Location.Over) != null :
		swap(block, block.blockAt(Enums.Location.Over))
func breakDiamond():
	var block = blockAt(_cursor.position())
	if block.needsDisplay() :
		return
	var over = block.blockAt(Enums.Location.Over)
	if over.needsDisplay() :
		return
	var left = block.blockAt(Enums.Location.LeftSide)
	if left.needsDisplay() :
		return
	var right = block.blockAt(Enums.Location.RightSide)
	if right.needsDisplay() :
		return
	breakSingle(block)
	breakSingle(over)
	breakSingle(left)
	breakSingle(right)
func rotate(rotation:int):
		var block = blockAt(_cursor.position())
		var over = block.blockAt(Enums.Location.Over)
		var left = block.blockAt(Enums.Location.LeftSide)
		var right = block.blockAt(Enums.Location.RightSide)
		match rotation:
			Enums.Rotation.Clockwise:
				swap(block,right)
				swap(block,over)
				swap(block,left)
			Enums.Rotation.CounterClockwize:
				swap(block,left)
				swap(block,over)
				swap(block,right)
			_:
				pass
		_evaluate()
func _fill():
	var block:BlockModel
	var pos:GridCoordinate
	var type:int
	for row in range(0, _rows):
		for column in range(0, _columns):
			pos = GridCoordinate.new(row, column)
			block = BlockModel.new(self, pos, BlockModel.shuffleType())
			_blocks.append(block)
