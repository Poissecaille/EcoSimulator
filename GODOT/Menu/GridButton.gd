extends GridContainer

var MAX_BTN_TEXT_LENGTH = 8
var persos = ["Shape 1", "Shape 2", "Shape 3", "Shape 4"]

func _ready():
	for i in range(len(persos)):
		var name = persos[i]
#		essaye de faire rentrer tous les boutons dans le
#		container OUH OUH OUH
		if(len(name) > MAX_BTN_TEXT_LENGTH):
			name = name.substr(0, MAX_BTN_TEXT_LENGTH)
		var btn = Button.new()
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		btn.text = name
		btn.connect(
			"pressed",
			self,
			"click_the_dynamic_button_mother_fucker",
			[persos[i]]
		)
		self.add_child(btn)

func click_the_dynamic_button_mother_fucker(name):
	print("Add new shape -> ", name)
