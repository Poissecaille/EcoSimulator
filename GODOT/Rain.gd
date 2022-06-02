extends Particles2D

var rain_size
var terrain
var time = 0

export var timer_rain_variation = 5
var rain_direction = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	terrain=get_parent().get_node("Terrain")
	print(terrain.height)
	rain_size = Vector3(terrain.width*32*1.5,terrain.height*-6,0)
	self.process_material.set_emission_box_extents(rain_size)

	# print(self.process_material.get_emission_box_extents())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time+=delta
	if (time > timer_rain_variation):
		time -= timer_rain_variation
		rain_direction.randomize()
		self.process_material.set_gravity(Vector3(rain_direction.randf_range(-50.0, 50.0),100,0))
		# print(self.process_material.get_gravity())
