class_name BlockModel

class State:
	func enter():pass
	func handle(state:State) -> State:
		return self
	func exit():pass

class DefaultState:
	extends State
	func handle(state:State) -> State:
		return state

class WillBreakState:
	extends State
	var markedForDeletion:bool = false
	func handle(state:State) -> State:
		if state is BreakingState:
			return state 
		return self

class RotateState:
	extends State
	var _rotated: bool = false
	func enter():
		pass
	func handle(state:State) -> State:
		if !_rotated : return self
		return state

class BreakingState:
	extends State
	signal finished
	var _broken:bool
	func enter():
		_broken = false
		pass
	func handle(state:State) -> State:
		if _broken && state is DefaultState:
			return state
		return self
	func _finished():
		_broken = true
		emit_signal("finished")

class FallingState:
	extends State

var _state
signal stateChanged(from, to)

static func shuffleType()->int:
	return randi() % (Enums.BlockType.U-Enums.BlockType.A+1) + Enums.BlockType.A
	
func _init(state:Dictionary):
	_state = state.duplicate(true)
	_state.state = DefaultState.new()
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
	var width = state.appearance.block.width
	var height = state.appearance.block.height
	var offset = (column % 2) * height / 2
	var x = column * width 
	var y = (totalRows - row - 1) * height + offset
	return {x = x, y = y}

static func nodePositionToGrid(state) -> Dictionary:
	var x = state.position.x
	var y = state.position.y
	var totalRows = state.level.dimensions.grid.rows + state.level.dimensions.grid.buffer
	var width = state.level.appearance.block.width
	var height = state.level.appearance.block.height
	var column = int(x / width)
	var offset = (column % 2) * height / 2
	var row =  int(totalRows - ((y - offset) / height))
	return {row = row, column = column}

func node():
	return _state.node
	
func setState(state:State) -> bool:
	var currentState: State = _state.state
	var newState: State = currentState.handle(state)
	var stateChanged: bool = currentState != newState
	if stateChanged:
		var previousState = currentState
		previousState.exit()
		_state.state = newState
		newState.enter()
		emit_signal("stateChanged", previousState, newState)
	return stateChanged
func state() -> State:
	return _state.state
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
func mark():
	node().mark()
