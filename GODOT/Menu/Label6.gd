extends Label

var initial_nb = 15
var group_name = "SheepGroup"

func _process(delta):
	var entities = get_tree().get_nodes_in_group(group_name)
	self.text = str(len(entities))

func _ready():
	self.text = str(initial_nb)
