class_name BlockModel

class BlockState:
	var _model: BlockModel
	func _init(model:BlockModel):
		_model = model
	func enter():pass
	func handle(state:BlockState) -> BlockState:
		return self
	func exit():pass

class BlockWaitState:
	extends BlockState
	func handle(state:BlockState) -> BlockState:
		return state

class BlockRotateState:
	extends BlockState
	var _rotated: bool = false
	func enter():
		pass
	func handle(state:BlockState) -> BlockState:
		if !_rotated : return self
		return state

class BlockBreakState:
	extends BlockState
	var _broken: bool = false
	func enter():
		pass
	func handle(state:BlockState) -> BlockState:
		if !_broken : return self
		return state
	func _finished():
		_broken = true
		_model.setState(BlockWaitState.new(_model))

class BlockFallState:
	extends BlockState

var _state

signal stateChanged(from, to)

static func shuffleType()->int:
	return randi() % (Enums.BlockType.U-Enums.BlockType.A+1) + Enums.BlockType.A
	
func _init(state:Dictionary):
	_state = state.duplicate(true)
	state.node.connect("ready", self, "_onViewReady")
	
func _onViewReady():
	_updateNode()
	
func _updateNode():
	var model = {
		type = _state.type,
		position = gridToNodePosition(_state)
	}
	_state.node.configure(model)

static func gridToNodePosition(state) -> Dictionary:
	var row = state.position.row
	var column = state.position.column
	var totalRows = state.dimensions.grid.rows + state.dimensions.grid.buffer
	var width = state.dimensions.block.width
	var height = state.dimensions.block.height
	var offset = (column % 2) * height / 2
	var x = column * width 
	var y = (totalRows - row - 1) * height + offset
	return {x = x, y = y}

static func nodePositionToGrid(state) -> Dictionary:
	var x = state.position.x
	var y = state.position.y
	var totalRows = state.dimensions.grid.rows + state.dimensions.grid.buffer
	var width = state.dimensions.block.width
	var height = state.dimensions.block.height
	var column = int(x / width)
	var offset = (column % 2) * height / 2
	var row =  int(totalRows - ((y - offset) / height))
	return {row = row, column = column}

func node():
	return _state.node
	
#func setState(state:BlockState) -> bool:
#	var newState: BlockState = _state.handle(state)
#	var stateChanged: bool = _state != newState
#	if stateChanged:
#		_state.exit()
#		var previousState = _state
#		_state = newState
#		_state.enter()
#		emit_signal("stateChanged", previousState, newState)
#	return stateChanged
func type()->int:
	return _state.type
func setType(type:int):
	_state.type = type
	node().updateType(type)
func position() -> Dictionary:
	return _state.position.duplicate()
func setPosition(pos:Dictionary):
	if _state.position.row == pos.row && _state.position.column == pos.column: return
	_state.position = pos.duplicate()
	node().updatePosition(gridToNodePosition(_state))
