extends Particles2D

var screen_size
var terrain
var time = 0
# var timer_on = false
var timer_limit = 5
var rain_direction = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	#timer_on=true
	terrain=get_parent().get_node("Terrain")
	screen_size = Vector3(terrain.width*32,terrain.height*-16,0)
	self.process_material.set_emission_box_extents(screen_size)
	print(self.process_material.get_emission_box_extents())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if(timer_on):
	time+=delta

	if (time > timer_limit):
		time -= timer_limit
		#print(fmod(time,1)*1000)
		rain_direction.randomize()
		self.process_material.set_gravity(Vector3(rain_direction.randf_range(-50.0, 50.0),100,0))
		print(self.process_material.get_gravity())
