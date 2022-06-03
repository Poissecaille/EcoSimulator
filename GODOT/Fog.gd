extends Sprite

var screen_size
var terrain
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	terrain=get_parent().get_node("Terrain")
	screen_size = Vector2(terrain.width*32,terrain.height*32)
	self.position=screen_size/2
	self.set_scale(Vector2(self.texture.get_width()/1000,self.texture.get_height()/1000))

