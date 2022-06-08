extends CheckBox

var show = true

func _ready():
	self.connect("pressed", self, "toggle_entity_fov", [["Hyena", "Sheep"]])

func toggle_entity_fov(entity_names):
	for entity_name in entity_names:
		var group_name = entity_name + "Group"
		var entities = get_tree().get_nodes_in_group(group_name)
		for e in entities:
			var fov_polygon = e.get_children()[0]
			if(show):
				fov_polygon.toggle_fov(true)
			else:
				fov_polygon.toggle_fov(false)
	show = !show
