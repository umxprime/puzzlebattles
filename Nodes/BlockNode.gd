extends Node2D

class_name BlockNode

var _cell:GridModel.Cell
var _visible:bool = true

func init(cell:GridModel.Cell):
	_cell = cell
	_node().visible = _visible
	updatePosition()

func updatePosition():
	var x:int = _cell.position().column*16 + 8
	var y:int = (_cell._grid.rows()-_cell.position().row-1)*16 + 8 + (_cell.position().column%2) * 8
	position = Vector2(x, y)

func setVisible(value:bool):
	if value == _visible:
		return
	_visible = value
	var node:Node2D = _node()
	if node == null:
		return
	node.visible = value

func _node() -> Node2D:
	match _cell._type:
		GridModel.Cell.BlockType.A:
			return get_node("A") as Node2D
		GridModel.Cell.BlockType.E:
			return get_node("E") as Node2D
		GridModel.Cell.BlockType.I:
			return get_node("I") as Node2D
		GridModel.Cell.BlockType.O:
			return get_node("O") as Node2D
		GridModel.Cell.BlockType.U:
			return get_node("U") as Node2D
		_:
			return null

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		if make_input_local(event).position.length_squared() < 64:
			_cell._grid.cursor().setPosition(_cell.position())
