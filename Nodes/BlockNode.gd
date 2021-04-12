extends Node2D

class_name BlockNode

var _cell:GridModel.Cell
var _visible:bool = true
var _bounds:AABB
var _half:Vector2
func init(cell:GridModel.Cell, blockSize:int):
	_cell = cell
	_bounds.position = Vector3(-blockSize/2, -blockSize/2, 0)
	_bounds.size.x = blockSize
	_bounds.size.y = blockSize
	_half = Vector2(_bounds.size.x / 2, _bounds.size.y / 2)
	var node:MeshInstance2D = _node()
	var mesh = node.mesh as QuadMesh
	mesh.size.x = blockSize - 2
	mesh.size.y = blockSize - 2
	node.visible = _visible
	updatePosition(false)
	

func updatePosition(animate:bool=true):
	if ! _cell.needsDisplay() :
		return
	var pos:Vector2
	pos.x = _cell.position().column * _bounds.size.x 
	pos.y = (_cell._grid.rows()-_cell.position().row-1)*_bounds.size.y + (_cell.position().column%2) * _half.y
	if !animate:
		position = pos + _half
		_cell.setNeedsDisplay(false)
	else:
		var tween:Tween = get_node("Tween")
		tween.connect("tween_completed",self,"_updatePositionCompleted")
		tween.interpolate_property(self,"position",position,pos + _half,.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()

func _updatePositionCompleted(object:Object, key:NodePath):
	_cell.setNeedsDisplay(false)

func setVisible(value:bool):
	if value == _visible:
		return
	_visible = value
	var node:Node2D = _node()
	if node == null:
		return
	node.visible = value

func _node() -> MeshInstance2D:
	match _cell._type:
		GridModel.Cell.BlockType.A:
			return get_node("A") as MeshInstance2D
		GridModel.Cell.BlockType.E:
			return get_node("E") as MeshInstance2D
		GridModel.Cell.BlockType.I:
			return get_node("I") as MeshInstance2D
		GridModel.Cell.BlockType.O:
			return get_node("O") as MeshInstance2D
		GridModel.Cell.BlockType.U:
			return get_node("U") as MeshInstance2D
		_:
			return null

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		if isOver(event.position):
			moveCursorToBlock()

func moveCursorToBlock():
	_cell._grid.cursor().setPosition(_cell.position())

func isOver(pos:Vector2):
	var local_pos:Vector2 = make_canvas_position_local(pos)
	return _bounds.has_point(Vector3(local_pos.x, local_pos.y, 0))
