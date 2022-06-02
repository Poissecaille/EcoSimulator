extends AnimatedSprite


var terrain
var seeder=RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	seeder.randomize()
	terrain=get_parent().get_node("Terrain")
	var screen_size=Vector2(terrain.width*32,terrain.height*32)
	self.position=Vector2(seeder.randf_range(0, terrain.width*32),seeder.randf_range(0, terrain.height*32))
	self.play()
