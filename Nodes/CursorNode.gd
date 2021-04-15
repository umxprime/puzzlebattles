extends Node2D

class_name CursorNode

var _cellSize:Vector2
var _model:CursorModel

func _init(cellSize:Vector2, model:CursorModel):
	_cellSize = cellSize
	_model = model
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	var points:PoolVector2Array = PoolVector2Array(
		[
			Vector2(0,_cellSize.y), 
			Vector2(_cellSize.x, _cellSize.y),
			Vector2(_cellSize.x, _cellSize.y*0.5),
			Vector2(2*_cellSize.x, _cellSize.y*0.5),
			Vector2(2*_cellSize.x, _cellSize.y),
			Vector2(3*_cellSize.x, _cellSize.y),
			Vector2(3*_cellSize.x, 2*_cellSize.y),
			Vector2(2*_cellSize.x, 2*_cellSize.y),
			Vector2(2*_cellSize.x, 2.5*_cellSize.y),
			Vector2(_cellSize.x, 2.5*_cellSize.y),
			Vector2(_cellSize.x, 2*_cellSize.y),
			Vector2(0, 2*_cellSize.y),
			Vector2(0, _cellSize.y),
		]
	)
	draw_polyline(points, Color.white, 4, true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func updatePosition():
	position.x = (_model.position().column * _cellSize.x) - _cellSize.x
	position.y = ((_model.grid().visibleRows() - _model.position().row - 2.5) * _cellSize.y) + (_cellSize.y * 0.5 * (_model.position().column%2))
