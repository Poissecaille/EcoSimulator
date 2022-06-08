extends GridContainer

var MAX_BTN_TEXT_LENGTH = 8
# Add an entity name in this array to generate a button
var persos = ["Sheep", "Hyena"]
var rng = RandomNumberGenerator.new()
var MAX_TERRAIN_WIDTH = 32 * 100
var MAX_TERRAIN_HEIGHT = 32 * 100

func _ready():
	add_entity_btn()

func add_entity_btn():
	for i in range(len(persos)):
		var name = persos[i]
		if(len(name) > MAX_BTN_TEXT_LENGTH):
			name = name.substr(0, MAX_BTN_TEXT_LENGTH)
		var btn = Button.new()
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		btn.text = name
		btn.connect(
			"pressed",
			self,
			"click",
			[persos[i]]
		)
		self.add_child(btn)

func random_pos() -> Vector2:
	rng.randomize()
	var x = randi() % MAX_TERRAIN_WIDTH
	var y = randi() % MAX_TERRAIN_HEIGHT

	return Vector2(x, y)

func click(name):
	var root = get_tree().root
	var terrain = root.get_children()[0].get_node("Terrain")
	terrain.spawn_animal(name)
