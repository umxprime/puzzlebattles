class_name GridCoordinate

var row:int = 0
var column:int = 0
func _init(row:int, column:int):
	self.row = row
	self.column = column
func _to_string():
	return "row:%d,column:%d" % [self.row, self.column]
func copy() -> GridCoordinate:
	return get_script().new(row, column)
