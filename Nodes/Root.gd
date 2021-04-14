extends Control

class_name Root

var _gridModel = GridModel.new(8, 10)
var _gridNode = GridNode.new(_gridModel, 50)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _init():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_child(_gridNode)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
