extends Node2D

class_name BlockNode

var _visible:bool = true
var _bounds:Rect2
var _half:Vector2
var _isUpdatingPosition:bool = false
var _typeNode:MeshInstance2D

func init(blockSize:Vector2):
	_bounds.position = - blockSize / 2
	_bounds.size = blockSize
	_half = blockSize / 2
	

func configure(model):
	# keep ref to child node corresponding to type
	_typeNode = _node(model)
	# set block size and margin
	var mesh = _typeNode.mesh as QuadMesh
	mesh.size = _bounds.size - Vector2(2, 2)
	# make block visible
	_typeNode.visible = _visible
	# move block on grid
	var pos = Vector2(model.position.x, model.position.y)
	position = pos + _half
#	updatePosition(false)
	

#func updatePosition(animate:bool=true):
#	if !_model.needsDisplay() || _isUpdatingPosition:
#		return
#	var pos:Vector2
#	pos.x = _model.position().column * _bounds.size.x 
#	pos.y = (_model._grid.visibleRows()-_model.position().row-1)*_bounds.size.y + (_model.position().column%2) * _half.y
#	var isEmpty = _model.type() == Enums.BlockType.Empty
#	if isEmpty:
#		_model.setType(BlockModel.shuffleType())
#		_resetVisibility()
#		setVisible(true)
#	if !animate || isEmpty:
#		position = pos + _half
#		_model.setNeedsDisplay(false)
#	else:
#
#		tween.interpolate_property(self,"position",position,pos + _half,.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
#		_isUpdatingPosition = true
#		tween.start()

#func _updatePositionCompleted(object:Object, key:NodePath):
#	_model.setNeedsDisplay(false)
#	_isUpdatingPosition = false

func _resetVisibility():
	_visible = false
	for child in get_children():
		if child is Node2D:
			child.visible = false

func setVisible(value:bool):
	if value == _visible:
		return
	_visible = value
	if _typeNode == null:
		return
	_typeNode.visible = value

func _node(model) -> MeshInstance2D:
	match model.type:
		Enums.BlockType.A:
			return get_node("A") as MeshInstance2D
		Enums.BlockType.E:
			return get_node("E") as MeshInstance2D
		Enums.BlockType.I:
			return get_node("I") as MeshInstance2D
		Enums.BlockType.O:
			return get_node("O") as MeshInstance2D
		Enums.BlockType.U:
			return get_node("U") as MeshInstance2D
		_:
			return null

func _ready():
	pass
#	var tween:Tween = get_node("Tween")
#	tween.connect("tween_completed",self,"_updatePositionCompleted")

func moveCursorToBlock() -> bool:
	return false
#	return _model.grid().cursor().setPosition(_model.position())

func isOver(pos:Vector2):
	var local_pos:Vector2 = make_canvas_position_local(pos)
	return _bounds.has_point(local_pos)
