extends Node2D

class_name GridNode

class ComboBreakAnimation:
	var _tween:Tween
	var _blocks:Array
	var _parent:Node
	var _started:bool
	signal finished
	func _init(parent:Node, blocks:Array):
		_blocks = blocks
		_parent = parent
		_tween = Tween.new()
		_started = false
	func started() -> bool:
		return _started
	func start():
		if _started:return
		_started = true
		_parent.add_child(_tween)
		_tween.connect("tween_all_completed", self, "_finished")
		for block in _blocks:
			var node:Node2D = block.node()
			_tween.interpolate_property(node, "scale", node.scale, Vector2(0,0),.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		_tween.start()
	func _finished():
		for block in _blocks:
			var node:Node2D = block.node()
			node.scale = Vector2(1,1)
		emit_signal("finished", _blocks)

class DiamondRotateAnimation:
	var _tween:Tween
	var _blocks:Array
	var _parent:Node
	var _started:bool
	signal finished
	func _init(parent:Node, blocks:Array):
		_blocks = blocks
		_parent = parent
		_tween = Tween.new()
		_started = false
	func started() -> bool:
		return _started
	func start():
		if _started:return
		_started = true
		_parent.add_child(_tween)
		_tween.connect("tween_all_completed", self, "_finished")
		for block in _blocks:
			var node:Node2D = block.node
			var pos:Vector2 = block.pos
			_tween.interpolate_property(node, "position", node.position, pos,.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		_tween.start()
	func _finished():
		emit_signal("finished")

var _blockSize:Dictionary
var _cursor:CursorNode

signal rotate
signal breakDiamond
signal mouseMoved

func _init(appearance):
	_blockSize=appearance.block

func configure(model):
	var node
	for block in model.blocks:
		node = block.node()
		node.init(Vector2(_blockSize.width, _blockSize.height))
		add_child(node)

func _input(event):
	if event is InputEventMouseMotion:
		var local = make_canvas_position_local(event.position)
		emit_signal("mouseMoved", {x = local.x, y = local.y})
	elif event is InputEventMouseButton:
		var local = make_canvas_position_local(event.position)
		if event.pressed:
			emit_signal("mouseMoved", {x = local.x, y = local.y})
			if event.button_index == 1:
				emit_signal("rotate", Enums.Rotation.Clockwise)
			else:
				emit_signal("rotate", Enums.Rotation.CounterClockwize)
#	elif event is InputEventKey:
#		if event.pressed && event.scancode == KEY_SPACE:
##			_model.breakDiamond()
#			emit_signal("breakDiamond")
#			for child in get_children():
#				if child is BlockNode:
#					(child as BlockNode).updatePosition()
