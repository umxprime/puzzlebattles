extends Node2D

class_name GridNode


var _blockSize:Dictionary
var _cursor:CursorNode

signal rotate
signal breakDiamond

func _init(size):
	_blockSize=size
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func configure(model):
	var node
	for block in model.blocks:
		node = block.node()
		node.init(Vector2(_blockSize.width, _blockSize.height))
		add_child(node)
#	_cursor = CursorNode.new(_blockSize, _model.cursor())
#	add_child(_cursor)

func _overBlock(pos:Vector2) -> BlockNode:
	for child in get_children():
		if child is BlockNode:
			if child.isOver(pos):
				return child
	return null

func _input(event):
	pass
#	if event is InputEventMouseMotion:
#		var block:BlockNode = _overBlock(event.position)
#		if block != null:
#			if block.moveCursorToBlock() :
#				_cursor.updatePosition()
#	elif event is InputEventMouseButton:
#		if event.pressed:
#			var block:BlockNode = _overBlock(event.position)
#			if block != null:
#				if block.moveCursorToBlock() :
#					_cursor.updatePosition()
#			if event.button_index == 1:
#				emit_signal("rotate", Enums.Rotation.Clockwise)
##				_model.rotate(Enums.Rotation.Clockwise)
#			else:
#				emit_signal("rotate", Enums.Rotation.CounterClockwize)
##				_model.rotate(Enums.Rotation.CounterClockwize)
#			for child in get_children():
#				if child is BlockNode:
#					(child as BlockNode).updatePosition()
#	elif event is InputEventKey:
#		if event.pressed && event.scancode == KEY_SPACE:
##			_model.breakDiamond()
#			emit_signal("breakDiamond")
#			for child in get_children():
#				if child is BlockNode:
#					(child as BlockNode).updatePosition()
