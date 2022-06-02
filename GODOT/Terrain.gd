extends Node2D
var tile_size = 32

var noise = OpenSimplexNoise.new()
export var height = 40
export var width = 100

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
			if (noise_value < -0.3):
				water.set_cell(x, y, water_tile)
	water.update_bitmask_region()

func fill_forests():	
	var trees = get_node("Trees")
	var trees_tile = trees.tile_set.find_tile_by_name("Trees_Spring")
	var tile_scale = 2.5
	for x in width:
		for y in height:
			var noise_value = noise.get_noise_2d(x, y)
			if (noise_value > 0.3 and noise_value < 0.6):
				trees.set_cell(x*tile_scale, y*tile_scale, trees_tile)

	trees.update_bitmask_region()

var wind_scene = preload("res://Wind.tscn")


func _ready():
	randomize()
	print(randi())
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 10

	# Debug + Extra options TODO Clean
	# noise.persistance = 2
	# noise.lacunarity = 50
	# noise.get_image(width, height).save_png("res://saved_texture.png")

	fill_ground()
	fill_water()
	fill_forests()

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
