extends Control

class_name Root

var _grid:GridModel
var _cursor:CursorModel
var _level:Dictionary

func _init():
	_level = _createLevel()
	_cursor = _createCursor(_level)
	_grid = _createGrid(_cursor, _level)

func _createGrid(cursor, level) -> GridModel :
	return GridModel.new(
		GridNode.new(level.appearance), 
		level, 
		cursor)

func _createCursor(level) -> CursorModel :
	var position = {
		row = level.dimensions.grid.rows / 2, 
		column = level.dimensions.grid.columns / 2
	}
	return CursorModel.new(
		CursorNode.new(level), 
		position,
		level
	)

func _createLevel() -> Dictionary:
	var dimensions = {
		grid={rows=10, columns=8, buffer=10}
	}
	var appearance = {
		block = {width=46,height=50}
	}
	var state
	var model:BlockModel
	var blocks = []
	var block = preload("res://Scenes/Block.tscn")
	for row in range(0, dimensions.grid.rows + dimensions.grid.buffer):
		for column in range(0, dimensions.grid.columns):
			state = {
				position = {row = row, column = column},
				dimensions = dimensions.duplicate(true),
				appearance = appearance.duplicate(true),
				node = block.instance(),
				type = BlockModel.shuffleType()
			}
			model = BlockModel.new(state)
			blocks.append(model)
	return {
		dimensions = dimensions,
		blocks = blocks,
		appearance = appearance
	}

func _clipGrid(level):
	rect_clip_content = true
	var width:int = level.dimensions.grid.columns * level.appearance.block.width
	var height:int = level.dimensions.grid.rows * level.appearance.block.height + (level.appearance.block.height / 2)
	var size = Vector2(width, height)
	rect_size = size
	var viewportSize = (get_tree().get_root() as Viewport).size
	rect_position = (viewportSize - size) / 2

func _addGridNode(level):
	_grid.node().position.y = - level.dimensions.grid.buffer * level.appearance.block.height
	self.add_child(_grid.node())

func _addCursorNode():
	self.add_child(_cursor.node())

# Called when the node enters the scene tree for the first time.
func _ready():
	_clipGrid(_level)
	_addGridNode(_level)
	_addCursorNode()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
