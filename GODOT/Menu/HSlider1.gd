extends HSlider

func _ready():
	print("Initial Slider1 value => ", self.value)
	self.connect("value_changed", self, "_on_value_changed")

func _on_value_changed(value):
	print("on Slider1 change value => ", value)
