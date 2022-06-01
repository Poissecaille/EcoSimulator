extends Particles2D

var screen_size
var terrain

# Called when the node enters the scene tree for the first time.
func _ready():
	terrain=get_parent().get_node("Terrain")
	screen_size = Vector3(terrain.width*32,terrain.height*-16,0)
	self.process_material.set_emission_box_extents(screen_size)
	print(self.process_material.get_emission_box_extents())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
