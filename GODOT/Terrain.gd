extends Node2D

var height = 40
var width = 100

var noise = OpenSimplexNoise.new()

func fill_ground():
	var ground = get_node("Ground")
	var grass_tile = ground.tile_set.find_tile_by_name("Grass")
	for x in width:
		for y in height:
			ground.set_cell(x, y, grass_tile)
	ground.update_bitmask_region()


func fill_water():	
	var water = get_node("Water")
	var water_tile = water.tile_set.find_tile_by_name("Water")
	for x in width:
		for y in height:
			var noise_value = noise.get_noise_2d(x, y)
			print(noise_value)
			if (noise_value > 0.3):
				water.set_cell(x, y, water_tile)
	water.update_bitmask_region()

func _ready():
	randomize()
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 10

	# Debug + Extra options TODO Clean
	# noise.persistance = 2
	# noise.lacunarity = 50
	# noise.get_image(100, 40).save_png("res://saved_texture.png")

	fill_ground()
	fill_water()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
