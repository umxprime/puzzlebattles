extends Node2D

class_name GridNode

var _block = preload("res://Block.tscn")
var _gridModel:GridModel
var _blockSize:int

func _init(gridModel:GridModel, blockSize:int):
	_gridModel=gridModel
	_blockSize=blockSize
# Called when the node enters the scene tree for the first time.
func _ready():
	for row in range(0,_gridModel.rows()):
		for column in range(0,_gridModel.columns()):
			var cell = _gridModel.cellAt(GridModel.GridCoordinate.new(row,column))
			var block:BlockNode = _block.instance()
			block.init(cell, _blockSize)
			add_child(block)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			print("",event.button_index)
			if event.button_index == 1:
				_gridModel.rotate(GridModel.Rotation.Clockwise)
			else:
				_gridModel.rotate(GridModel.Rotation.CounterClockwize)
			for child in get_children():
				if child is BlockNode:
					(child as BlockNode).updatePosition()
