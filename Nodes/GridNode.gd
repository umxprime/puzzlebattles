extends Node2D

class_name GridNode

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _block = preload("res://Block.tscn")
var _gridModel:GridModel

func _init(gridModel:GridModel):
	_gridModel=gridModel
	
# Called when the node enters the scene tree for the first time.
func _ready():
	for row in range(0,_gridModel.rows()):
		for column in range(0,_gridModel.columns()):
			var cell = _gridModel.cellAt(GridModel.GridCoordinate.new(row,column))
			var blockInstance:Node2D = _block.instance()
			blockInstance.position = Vector2(column*16 + 8, row*16 + 8 + (column%2) * 8)
			match cell._type:
				cell.BlockType.A:
					blockInstance.get_node("A").visible = true
				cell.BlockType.E:
					blockInstance.get_node("E").visible = true
				cell.BlockType.I:
					blockInstance.get_node("I").visible = true
				cell.BlockType.O:
					blockInstance.get_node("O").visible = true
			add_child(blockInstance)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
