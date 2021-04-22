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
	var model = {
		type = _state.type,
		position = _gridToNodePosition()
	}
	_state.node.configure(model)

func _gridToNodePosition() -> Dictionary:
	var position = {}
	var row = _state.position.row
	var column = _state.position.column
	var totalRows = _state.dimensions.grid.rows + _state.dimensions.grid.buffer
	var width = _state.dimensions.block.width
	var height = _state.dimensions.block.height
	position.x = column * width 
	position.y = (totalRows - row - 1) * height + (column % 2) * height / 2
	return position

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
func position() -> Dictionary:
	return _state.pos.duplicate()
func setPosition(pos:Dictionary):
	if _state.pos.row == pos.row && _state.pos.column == pos.column: return
	_state.pos = pos.duplicate()
