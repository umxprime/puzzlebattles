extends Control

class_name GridNode

var _block = preload("res://Scenes/Block.tscn")
var _model:GridModel
var _blockSize:Vector2
var _cursor:CursorNode

func _init(model:GridModel, blockSize:Vector2):
	_model=model
	_blockSize=blockSize
	
# Called when the node enters the scene tree for the first time.
func _ready():
	rect_clip_content = true
	var width:int = _model.columns() * _blockSize.x
	var height:int = _model.visibleRows() * _blockSize.y + (_blockSize.y / 2)
	var size = Vector2(width, height)
	rect_size = size
	var viewportSize = (get_tree().get_root() as Viewport).size
	rect_position = (viewportSize - size) / 2
	for row in range(0,_model.rows()):
		for column in range(0,_model.columns()):
			var model = _model.blockAt(GridCoordinate.new(row,column))
			var node:BlockNode = _block.instance()
			node.init(model, _blockSize)
			add_child(node)
	_cursor = CursorNode.new(_blockSize, _model.cursor())
	add_child(_cursor)

func _overBlock(pos:Vector2) -> BlockNode:
	for child in get_children():
		if child is BlockNode:
			if child.isOver(pos):
				return child
	return null

func _input(event):
	if event is InputEventMouseMotion:
		var block:BlockNode = _overBlock(event.position)
		if block != null:
			if block.moveCursorToBlock() :
				_cursor.updatePosition()
	elif event is InputEventMouseButton:
		if event.pressed:
			var block:BlockNode = _overBlock(event.position)
			if block != null:
				if block.moveCursorToBlock() :
					_cursor.updatePosition()
			if event.button_index == 1:
				_model.rotate(Enums.Rotation.Clockwise)
			else:
				_model.rotate(Enums.Rotation.CounterClockwize)
			for child in get_children():
				if child is BlockNode:
					(child as BlockNode).updatePosition()
	elif event is InputEventKey:
		if event.pressed && event.scancode == KEY_SPACE:
			_model.breakDiamond()
			for child in get_children():
				if child is BlockNode:
					(child as BlockNode).updatePosition()
