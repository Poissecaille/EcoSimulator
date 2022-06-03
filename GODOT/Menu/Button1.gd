extends Button

var weathers = ["Clear", "Rain", "Fog"]
var current_weather = "Clear"

func _ready():
	self.text = "Clear"
	self.connect("pressed", self, "_button_pressed")

func _button_pressed():
#	HEHE
	var scene = self.get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Weather")
	var index
	if(current_weather == "Clear"):
		index = 1
		current_weather = weathers[index]
	elif(current_weather == "Rain"):
		index = 2
		current_weather = weathers[index]
	elif(current_weather == "Fog"):
		index = 0
		current_weather = weathers[index]
	self.text = current_weather
	scene.update_weather(index)
	update()

