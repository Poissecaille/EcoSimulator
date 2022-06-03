extends Node2D


enum WEATHER {CLEARED,RAINY,FOGGY}
export(WEATHER) var Weather = WEATHER.CLEARED

var nb_wings = 5
var seeder
var terrain
var screen_size
var rain_size
var wind
var rain
var fog

func _ready():
	wind = preload("res://Wind.tscn")
	rain = preload("res://Rain.tscn")
	fog = preload("res://Fog.tscn")
	terrain=self.get_parent().get_child(0)
	seeder=RandomNumberGenerator.new()
	seeder.randomize()
	screen_size=Vector2(terrain.width*32,-terrain.height/2) 
	#update_weather(WEATHER.RAINY)
	#get_weather()
	
func weather_cycle():
	if(Weather == WEATHER.CLEARED):
		for i in range(nb_wings):
			var wind_instance = wind.instance()
			wind_instance.position=Vector2(seeder.randf_range(0, terrain.width*32),seeder.randf_range(0, terrain.height*32))
			wind_instance.play("blow")
			add_child(wind_instance)
			
	elif(Weather == WEATHER.RAINY):
		nb_wings=15
		var rain_instance = rain.instance()
		add_child(rain_instance)
		rain_size = Vector3(terrain.width*32*1.5,0,0)
		rain_instance.position=Vector2(terrain.width/2,0)
		rain_instance.process_material.set_emission_box_extents(rain_size)
		for i in range(nb_wings):
			var wind_instance = wind.instance()
			wind_instance.position=Vector2(seeder.randf_range(0, terrain.width*32),seeder.randf_range(0, terrain.height*32))
			wind_instance.play("blow")
			add_child(wind_instance)
			
	elif(Weather == WEATHER.FOGGY):
		nb_wings=0
		var fog_instance = fog.instance()
		fog_instance.position=screen_size/2
		fog_instance.set_scale(Vector2(10,10))
		add_child(fog_instance)

func clear_chilren(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func update_weather(weather):
	clear_chilren(self)
	self.Weather=weather
	weather_cycle()

func get_weather():
	print(self.Weather)
	return self.Weather
