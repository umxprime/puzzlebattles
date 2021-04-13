extends Node2D

class_name GridNode

var _block = preload("res://Block.tscn")
var _gridModel:GridModel
var _blockSize:int
var _cursor:CursorNode

func _init(gridModel:GridModel, blockSize:int):
	_gridModel=gridModel
	_blockSize=blockSize
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var width:int = _gridModel.columns() * _blockSize
	var height:int = _gridModel.rows() * _blockSize + (_blockSize / 2)
	var size = Vector2(width, height)
	var viewportSize = (get_tree().get_root() as Viewport).size
	position = (viewportSize - size) / 2
	for row in range(0,_gridModel.rows()):
		for column in range(0,_gridModel.columns()):
			var cell = _gridModel.cellAt(GridModel.GridCoordinate.new(row,column))
			var block:BlockNode = _block.instance()
			block.init(cell, _blockSize)
			add_child(block)
	_cursor = CursorNode.new(Vector2(_blockSize, _blockSize), _gridModel.cursor())
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
				_gridModel.rotate(GridModel.Rotation.Clockwise)
			else:
				_gridModel.rotate(GridModel.Rotation.CounterClockwize)
			for child in get_children():
				if child is BlockNode:
					(child as BlockNode).updatePosition()
