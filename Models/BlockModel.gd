class_name BlockModel

var _state

static func shuffleType()->int:
	return randi() % (Enums.BlockType.U-Enums.BlockType.A+1) + Enums.BlockType.A
	
func _init(state:Dictionary):
	_state = state.duplicate(true)
	state.node.connect("ready", self, "_onViewReady")
	
func _onViewReady():
	var model = {
		type = _state.type,
		position = _state.position,
		rows = _state.grid.rows + _state.grid.buffer
	}
	_state.node.configure(model)
	
func node():
	return _state.node
	
func type()->int:
	return _state.type
func setType(type:int):
	_state.type = type
func position() -> Dictionary:
	return _state.pos.duplicate()
func setPosition(pos:Dictionary):
	if _state.pos.row == pos.row && _state.pos.column == pos.column: return
	_state.pos = pos.duplicate()
