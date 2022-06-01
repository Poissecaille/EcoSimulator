extends Node2D

var height = 40
var width = 100

func fill_ground():
	var ground = get_node("Ground")
	var grass_tile = ground.tile_set.find_tile_by_name("Grass")
	for x in width:
		for y in height:
			ground.set_cell(x, y, grass_tile)
	ground.update_bitmask_region()


func fill_water():
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 30
	noise.persistence = 0.8
	
	var water = get_node("Water")
	var water_tile = water.tile_set.find_tile_by_name("Water")
	for x in width:
		for y in height:
			var noise_value = noise.get_noise_2d(x, y)
			if (noise_value > 0):
				water.set_cell(x, y, water_tile)
	water.update_bitmask_region()

func _ready():
	randomize()
	fill_ground()
	fill_water()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
