extends Node2D
var tile_size = 32

var noise = OpenSimplexNoise.new()
export var height = 100
export var width = 100
export var tree_density = 50
var beach_width = 10
var tree_density_generator = RandomNumberGenerator.new()

export var sheep_number = 10
export var hyena_number = 10

func fill_ocean():
	var ocean = get_node("Ocean")
	var ocean_tile = ocean.tile_set.find_tile_by_name("Ocean")
	for x in range(-(width*2), width*2):
		for y in range(-(height*2), height*2):
			if ((y < 0 || y > height) || (x < 0 || x > width)):
				ocean.set_cell(x, y, ocean_tile)
	ocean.update_bitmask_region()

func fill_beach():
	var beach = get_node("Beach")
	var beach_tile = beach.tile_set.find_tile_by_name("Beach")
	for x in range(-beach_width, width+beach_width):
		for y in range(-beach_width, height+beach_width):
			if ((y < beach_width || y > height - beach_width) || (x < beach_width || x > width - beach_width)):
				beach.set_cell(x, y, beach_tile)
	beach.update_bitmask_region()

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
				if (tree_density_generator.randf_range(0, 100) <= tree_density):
					trees.set_cell(x*tile_scale, y*tile_scale, trees_tile)

	trees.update_bitmask_region()

func spawn_animal(animal, x, y):
	var root = get_tree().root
	var vector = Vector2(x, y)
	var formated_scene = "res://Entities/Animals/%s.tscn"
	var scene_path = formated_scene % animal
	var group_name = animal + "Group"
	var entity_scene = load(scene_path)
	if entity_scene:
		var entity = entity_scene.instance()
		entity.start(vector)
		entity.add_to_group(group_name)
		root.call_deferred("add_child", entity)

func random_pos() -> Vector2:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x = randi() % (width * 32)
	var y = randi() % (height * 32)

	return Vector2(x, y)

func fill_sheeps(current_sheeps = 0):
	if (current_sheeps >= sheep_number):
		return

	var pos = random_pos()
	var noise_value = noise.get_noise_2d(pos.x, pos.y)
	if (noise_value > -0.3 and noise_value < 0):
		spawn_animal("Sheep", pos.x, pos.y)
		current_sheeps += 1

	fill_sheeps(current_sheeps)

func fill_hyenas(current_hyenas = 0):
	if (current_hyenas >= hyena_number):
		return

	var pos = random_pos()

	var noise_value = noise.get_noise_2d(pos.x, pos.y)
	if (noise_value > 0 and noise_value < 0.3):
		spawn_animal("Hyena", pos.x, pos.y)
		current_hyenas += 1

	fill_hyenas(current_hyenas)

var wind_scene = preload("res://Wind.tscn")

func _ready():
	randomize()
	tree_density_generator.randomize()
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 10

	# Debug + Extra options TODO Clean
	#var test = OpenSimplexNoise.new()
	#test.seed = randi()
	#test.persistance = 2
	#test.lacunarity = 50
	# noise.get_image(width, height).save_png("res://saved_texture.png")

	fill_ocean()
	fill_beach()
	fill_ground()
	fill_water()
	fill_forests()
	fill_sheeps()
	fill_hyenas()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
