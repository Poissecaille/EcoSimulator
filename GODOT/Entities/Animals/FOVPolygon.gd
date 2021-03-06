extends Area2D

export var fov_radius = 150
export var hearing_distance = 80
export var view_distance = 300
export var show_fov = false
var parent_owner_id = null

var visionShape

func get_hearing_shape():
	var points = PoolVector2Array()

	var nb_points = 32
	var pos = Vector2(0,0)
	points.push_back(pos)

	for i in range(nb_points + 1):
		var point = deg2rad(i * 360 / nb_points)
		points.push_back(pos + Vector2(cos(point), sin(point)) * self.hearing_distance)
	return points

func get_vision_shape():
	var points = PoolVector2Array()

	var nb_points = 32
	var pos = Vector2(0,0)
	var angle_offset = (180 - self.fov_radius) / 2
	points.push_back(pos)

	var angle = rad2deg(get_parent().velocity.angle()) - 90
	for i in range(nb_points + 1):
		var point = deg2rad(angle_offset + i * (fov_radius - angle_offset) / nb_points + angle)
		points.push_back(pos + Vector2(cos(point), sin(point)) * self.view_distance)
	points.push_back(Vector2(0,0))
	return points

func _draw():
	if (self.show_fov):
		var hearing_points = get_hearing_shape()
		var vision_points = get_vision_shape()
		draw_polygon(hearing_points, PoolColorArray([Color(1.0, 0.0, 0.0)]))
		draw_polygon(vision_points, PoolColorArray([Color(0.0, 1.0, 0.0)]))

func should_render_fov():
	for entity_name in ["Hyena", "Sheep"]:
		var group_name = entity_name + "Group"
		var entities = get_tree().get_nodes_in_group(group_name)
		if(len(entities) > 0):
			var fov_polygon = entities[0].get_children()[0]
			self.toggle_fov(fov_polygon.show_fow)

func _ready():
##	for entity_name in ["Hyena", "Sheep"]:
#	var entity_name = "Sheep"
#	var group_name = entity_name + "Group"
#	var entities = get_tree().get_nodes_in_group(group_name)
#	if(len(entities) > 0):
#		var fov_polygon = entities[0].get_children()[0]
#		self.toggle_fov(fov_polygon.show_fow)
	self.parent_owner_id = self.create_shape_owner(self.owner)
	visionShape = ConvexPolygonShape2D.new()
	var hearShape = ConvexPolygonShape2D.new()
	visionShape.set_point_cloud(get_vision_shape())
	hearShape.set_point_cloud(get_hearing_shape())
	var visionCollision = CollisionShape2D.new()
	var hearCollision = CollisionShape2D.new()

	visionCollision.set_shape(visionShape)
	hearCollision.set_shape(hearShape)
	add_child(visionCollision)
	add_child(hearCollision)
	pass

func _process(delta):
	# Drawings
	var v = get_parent().velocity
	if (v[0] != 0 || v[1] != 0):
		if (self.show_fov):
			update()
		visionShape.set_point_cloud(get_vision_shape())

	var vision_shape = ConvexPolygonShape2D.new()
	vision_shape.set_point_cloud(get_vision_shape())
	self.shape_owner_clear_shapes(parent_owner_id)
	self.shape_owner_add_shape(parent_owner_id, vision_shape)
	pass

func toggle_fov(show):
	self.show_fov = show
	if (show):
		var hearing_points = get_hearing_shape()
		var vision_points = get_vision_shape()
		draw_polygon(hearing_points, PoolColorArray([Color(1.0, 0.0, 0.0)]))
		draw_polygon(vision_points, PoolColorArray([Color(0.0, 1.0, 0.0)]))
	else:
		self.shape_owner_clear_shapes(parent_owner_id)
	update()
