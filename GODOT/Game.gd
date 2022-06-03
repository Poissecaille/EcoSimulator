extends Node2D

var terrain
var screen_size
var seeder

export var nb_wings = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	var wind = preload("res://Wind.tscn")
	seeder=RandomNumberGenerator.new()
	seeder.randomize()
	terrain=self.get_child(0)
	screen_size=Vector2(terrain.width*32,terrain.height*32)
	for i in range(nb_wings):
		var instance = wind.instance()
		instance.position=Vector2(seeder.randf_range(0, terrain.width*32),seeder.randf_range(0, terrain.height*32))
		instance.play("blow")
		add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
