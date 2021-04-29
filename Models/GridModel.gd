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

var DEFAULT_STATE = BlockModel.DefaultState.new()
var WILLBREAK_STATE = BlockModel.WillBreakState.new()
var BREAKING_STATE = BlockModel.BreakingState.new()
var FALLING_STATE = BlockModel.FallingState.new()

var _cursor:CursorModel
var _node:Node
var _level
func _init(node, level, cursor):
	_level = level.duplicate(true)
	_node = node
	_cursor = cursor
	_node.connect("ready", self, "_onViewReady")
	_node.connect("mouseMoved", self, "_onMouseMoved")
	_node.connect("rotate", self, "_onRotate")
func _onViewReady():
	var model = {
		blocks = _level.blocks.duplicate()
	}
	_node.configure(model)
func _onMouseMoved(pos):
	var state = {
		position = pos,
		level = _level
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
	return _level.blocks.duplicate()
func columns() -> int :
	return _level.dimensions.grid.columns
func visibleRows() -> int :
	return _level.dimensions.grid.rows
func rows() -> int :
	return _level.dimensions.grid.rows + _level.dimensions.grid.buffer
func _blockAt(row, column, blocks) -> BlockModel :
	if (row < 0 
	|| row + 1 > _level.dimensions.grid.rows + _level.dimensions.grid.buffer
	|| column < 0 
	|| column + 1 > _level.dimensions.grid.columns) :
		return null
	return blocks[_blockIndex(row, column)]
func blockAt(pos:Dictionary, blocks) -> BlockModel :
	return _blockAt(pos.row, pos.column, blocks)
func blockRelativeTo(block, location:int, blocks) -> BlockModel:
	var pos = block.position()
	match location:
		Enums.Direction.Up:
			pos.row += 1
		Enums.Direction.Down:
			pos.row -= 1
		Enums.Direction.LeftUp:
			pos.column -= 1
			if pos.column%2==1:
				pos.row +=1
		Enums.Direction.RightUp:
			pos.column += 1
			if pos.column%2==1:
				pos.row +=1
		Enums.Direction.LeftDown:
			pos.column -= 1
			if pos.column%2==0:
				pos.row -=1
		Enums.Direction.RightDown:
			pos.column += 1
			if pos.column%2==0:
				pos.row -=1
		_:
			return null
	return blockAt(pos, blocks)
func _blockIndex(row, column) -> int:
	return column + row * _level.dimensions.grid.columns
func blockIndex(pos:Dictionary) -> int :
	return _blockIndex(pos.row, pos.column)
func move(block:BlockModel, pos:Dictionary):
	block.setPosition(pos)
	_level.blocks[blockIndex(pos)] = block
	
var _animation
func _evaluate():
	if _animation != null :
		return
	var blocksToEvaluate = blocks()
	var blocksWillingToBreak = []
	for row in range(0, visibleRows() - 1):
		for column in range(1, columns() - 1):
			var diamond: Diamond = _diamondAt(row, column)
			if diamond == null : 
				print("null diamond")
				continue
#				print("Eval Left:", blocks.left.type(),
#				" Up:", blocks.up.type(),
#				" Right:", blocks.right.type(),
#				" Down:", blocks.down.type(),
#				" Pos:", blocks.down.position())
			if !diamond.haveSameType():
				continue
			if diamond.blocks().up.type() < Enums.BlockType.A :
				continue
			var blocks = diamond.blocks().values()
			blocksWillingToBreak += blocks
			for block in blocks:
				blocksToEvaluate[blockIndex(block.position())] = null
#				block.setState(WILLBREAK_STATE)
				blocksWillingToBreak += _evaluateSurroundings(block, blocksToEvaluate)
#				breakSingle(block)
	if blocksWillingToBreak.size() == 0 :
		return
	_animation = GridNode.ComboBreakAnimation.new(_node, blocksWillingToBreak)
	_animation.connect("finished", self, "_comboBreakAnimFinished")
	_animation.start()
func _comboBreakAnimFinished(blocks) :
	_animation = null
	for block in blocks:
		breakSingle(block)
#		block.setState(BREAKING_STATE)
	_evaluate()
func _evaluateSurroundings(block, blocksToEvaluate) -> Array :
	var blocksWillingToBreak = []
	for position in range(Enums.Direction.Up, Enums.Direction.RightDown + 1):
		var relative = blockRelativeTo(block, position, _level.blocks)
		if relative == null: continue
		if blocksToEvaluate[blockIndex(relative.position())] == null : continue
		if relative.type() != block.type():
			continue
		blocksToEvaluate[blockIndex(relative.position())] = null
#		relative.setState(WILLBREAK_STATE)
		blocksWillingToBreak.append(relative)
		blocksWillingToBreak += _evaluateSurroundings(relative, blocksToEvaluate)
	return blocksWillingToBreak
func _diamondAt(row, column) -> Diamond:
	var down = _blockAt(row, column, _level.blocks)
	if down == null: return null
	var up = blockRelativeTo(down, Enums.Direction.Up, _level.blocks)
	if up == null: return null
	var left = blockRelativeTo(down, Enums.Direction.LeftUp, _level.blocks)
	if left == null: return null
	var right = blockRelativeTo(down, Enums.Direction.RightUp, _level.blocks)
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
	match _level.insertion :
		Enums.BlockInsertion.Shuffle :
			block.setType(BlockModel.shuffleType())
		Enums.BlockInsertion.Unknown :
			block.setType(Enums.BlockType.Unknown)
	while blockRelativeTo(block, Enums.Direction.Up, _level.blocks) != null :
		swap(block, blockRelativeTo(block, Enums.Direction.Up, _level.blocks))
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
