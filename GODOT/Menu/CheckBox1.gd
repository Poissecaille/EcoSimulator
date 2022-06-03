extends CheckBox

func _ready():
	self.connect("pressed", self, "toggle_entity_fov", ["Hyena"])

func toggle_entity_fov(entity_name):
	var group_name = entity_name + "Group"
	var entities = get_tree().get_nodes_in_group(group_name)
	for e in entities:
		var fov_polygon = e.get_children()[0]
		fov_polygon.toggle_fov(!fov_polygon.show_fov)
