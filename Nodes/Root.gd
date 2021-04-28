extends Control

class_name Root

const dimensions = {
	grid={rows=10, columns=8, buffer=10},
	block={width=46,height=50}
}

var _grid:GridModel
var _cursor:CursorModel

func _init():
	_cursor = _createCursor(dimensions)
	_grid = _createGrid(_cursor, dimensions)

func _createGrid(cursor, dimensions) -> GridModel :
	return GridModel.new(
		GridNode.new(dimensions.block), 
		_createBlocks(dimensions), 
		cursor, 
		dimensions)

func _createCursor(dimensions) -> CursorModel :
	var position = {
		row = dimensions.grid.rows / 2, 
		column = dimensions.grid.columns / 2
	}
	return CursorModel.new(
		CursorNode.new(dimensions.block), 
		position,
		dimensions.grid
	)

func _createBlocks(dimensions) -> Array:
	var state
	var model:BlockModel
	var blocks = []
	var block = preload("res://Scenes/Block.tscn")
	for row in range(0, dimensions.grid.rows + dimensions.grid.buffer):
		for column in range(0, dimensions.grid.columns):
			state = {
				position = {row = row, column = column},
				dimensions = dimensions.duplicate(true),
				node = block.instance(),
				type = BlockModel.shuffleType()
			}
			model = BlockModel.new(state)
			blocks.append(model)
	return blocks

func _clipGrid(dimensions):
	rect_clip_content = true
	var width:int = dimensions.grid.columns * dimensions.block.width
	var height:int = dimensions.grid.rows * dimensions.block.height + (dimensions.block.height / 2)
	var size = Vector2(width, height)
	rect_size = size
	var viewportSize = (get_tree().get_root() as Viewport).size
	rect_position = (viewportSize - size) / 2

func _addGridNode():
	_grid.node().position.y = - dimensions.grid.buffer * dimensions.block.height
	self.add_child(_grid.node())

func _addCursorNode():
	self.add_child(_cursor.node())

# Called when the node enters the scene tree for the first time.
func _ready():
	_clipGrid(dimensions)
	_addGridNode()
	_addCursorNode()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
