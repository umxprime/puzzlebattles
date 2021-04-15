class_name GridModel

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
func blockAt(pos:GridCoordinate) -> BlockModel :
	if (pos.row < 0 || pos.row + 1 > _rows || pos.column < 0 || pos.column + 1 > _columns) :
		return null
	return _blocks[blockIndex(pos)]
func blockIndex(pos:GridCoordinate) -> int :
	return pos.column + pos.row * _columns
func move(block:BlockModel, pos:GridCoordinate):
	block.setPosition(pos)
	_blocks[blockIndex(pos)] = block
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
func _fill():
	var block:BlockModel
	var pos:GridCoordinate
	var type:int
	for row in range(0, _rows):
		for column in range(0, _columns):
			pos = GridCoordinate.new(row, column)
			block = BlockModel.new(self, pos, BlockModel.shuffleType())
			_blocks.append(block)
