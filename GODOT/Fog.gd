extends Sprite

var screen_size
var terrain
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():

	print("parent:",get_parent().get_node("Terrain"))
	terrain=get_parent().get_node("Terrain")
	screen_size = Vector3(terrain.width*32,terrain.height*32,0)

