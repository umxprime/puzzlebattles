class_name GridModel

class Diamond:
	var _blocks:Dictionary
	var _grid
	func _init(grid, blocks):
		_blocks = blocks
		_grid = grid
	func blocks() -> Dictionary:
		return _blocks.duplicate()
	func haveSameType() -> bool:
		return (_blocks.down.type() == _blocks.left.type() 
		&& _blocks.left.type() == _blocks.up.type() 
		&& _blocks.up.type() == _blocks.right.type())
	func rotate(rotation:int):
		match rotation:
			Enums.Rotation.Clockwise:
				_grid.swap(_blocks.down, _blocks.right)
				_grid.swap(_blocks.down, _blocks.up)
				_grid.swap(_blocks.down, _blocks.left)
			Enums.Rotation.CounterClockwize:
				_grid.swap(_blocks.down, _blocks.left)
				_grid.swap(_blocks.down, _blocks.up)
				_grid.swap(_blocks.down, _blocks.right)
			_:
				pass

var _blocks:Array
var _cursor:CursorModel
var _node:Node
var _dimensions
func _init(node, blocks, cursor, dimensions):
	_blocks = blocks
	_node = node
	_dimensions = dimensions
	_cursor = cursor
	_node.connect("ready", self, "_onViewReady")
	_node.connect("mouseMoved", self, "_onMouseMoved")
	_node.connect("rotate", self, "_onRotate")
func _onViewReady():
	var model = {
		blocks = _blocks.duplicate()
	}
	_node.configure(model)
func _onMouseMoved(pos):
	var state = {
		position = pos,
		dimensions = _dimensions
	}
	var block = BlockModel.nodePositionToGrid(state)
#	var diamond: Diamond = _diamondAt(block.row, block.column)
#	if diamond != null :
#		var blocks = diamond.blocks()
#		print("Left:", blocks.left.type(),
#		" Up:", blocks.up.type(),
#		" Right:", blocks.right.type(),
#		" Down:", blocks.down.type(),
#		" Pos:", blocks.down.position())
	_cursor.setPosition(block)
func node():
	return _node
func blocks() -> Array:
	return _blocks.duplicate()
func columns() -> int :
	return _dimensions.grid.columns
func visibleRows() -> int :
	return _dimensions.grid.rows
func rows() -> int :
	return _dimensions.grid.rows + _dimensions.grid.buffer
func _blockAt(row, column) -> BlockModel :
	if (row < 0 
	|| row + 1 > _dimensions.grid.rows + _dimensions.grid.buffer
	|| column < 0 
	|| column + 1 > _dimensions.grid.columns) :
		return null
	return _blocks[_blockIndex(row, column)]
func blockAt(pos:Dictionary) -> BlockModel :
	return _blockAt(pos.row, pos.column)
func blockRelativeTo(block, location:int) -> BlockModel:
	var pos = block.position()
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
	return blockAt(pos)
func _blockIndex(row, column) -> int:
	return column + row * _dimensions.grid.columns
func blockIndex(pos:Dictionary) -> int :
	return _blockIndex(pos.row, pos.column)
func move(block:BlockModel, pos:Dictionary):
	block.setPosition(pos)
	_blocks[blockIndex(pos)] = block
func _evaluate():
	for row in range(0, visibleRows() - 1):
		for column in range(1, columns() - 1):
			var diamond: Diamond = _diamondAt(row, column)
			if diamond == null : 
				print("null diamond")
				continue
			if diamond != null :
				var blocks = diamond.blocks()
#				print("Eval Left:", blocks.left.type(),
#				" Up:", blocks.up.type(),
#				" Right:", blocks.right.type(),
#				" Down:", blocks.down.type(),
#				" Pos:", blocks.down.position())
			if !diamond.haveSameType():
				continue
			for block in diamond.blocks().values():
				breakSingle(block)
			pass
func _diamondAt(row, column) -> Diamond:
	var down = _blockAt(row, column)
	if down == null: return null
	var up = blockRelativeTo(down, Enums.Location.Over)
	if up == null: return null
	var left = blockRelativeTo(down, Enums.Location.LeftSide)
	if left == null: return null
	var right = blockRelativeTo(down, Enums.Location.RightSide)
	if right == null: return null
	var blocks = {
		up = up,
		down = down,
		left = left,
		right = right
	}
	return Diamond.new(self, blocks)
func cursor()->CursorModel:
	return _cursor
func swap(from:BlockModel, to:BlockModel):
	var fromPos = from.position()
	var toPos = to.position()
	move(from, toPos)
	move(to, fromPos)
func breakSingle(block:BlockModel):
	block.setType(BlockModel.shuffleType())
	while blockRelativeTo(block, Enums.Location.Over) != null :
		swap(block, blockRelativeTo(block, Enums.Location.Over))
func breakDiamond():
	var pos: Dictionary = _cursor.position()
	var diamond: Diamond = _diamondAt(pos.row, pos.column)
	if diamond == null: return
	for block in diamond.blocks():
		breakSingle(block)
func _onRotate(rotation:int):
	var pos: Dictionary = _cursor.position()
	var diamond: Diamond = _diamondAt(pos.row, pos.column)
	if diamond == null: return
	diamond.rotate(rotation)
	
	_evaluate()
