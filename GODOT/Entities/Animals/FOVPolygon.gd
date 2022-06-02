extends CollisionPolygon2D

export var fov_radius = 150
export var hearing_distance = 80
export var view_distance = 300
export var show_fov = true

func get_hearing_shape():
	var points = PoolVector2Array()

	var nb_points = 32
	var pos = Vector2(0,0)
	points.push_back(pos)
	
	for i in range(nb_points + 1):
		var point = deg2rad(i * 360 / nb_points - 90)
		points.push_back(pos + Vector2(cos(point), sin(point)) * self.hearing_distance)
	return points
	
func get_vision_shape():
	var points = PoolVector2Array()

	var nb_points = 32
	var pos = Vector2(0,0)
	var angle_offset = (180 - self.fov_radius) / 2
	points.push_back(pos)
	
	for i in range(nb_points + 1):
		var point = deg2rad(angle_offset + i * (fov_radius - angle_offset) / nb_points - 90)
		points.push_back(pos + Vector2(cos(point), sin(point)) * self.view_distance)
	return points

func _draw():
	if (self.show_fov):
		var hearing_points = get_hearing_shape()
		var vision_points = get_vision_shape()
		draw_polygon(hearing_points, PoolColorArray([Color(1.0, 0.0, 0.0)]))
		draw_polygon(vision_points, PoolColorArray([Color(0.0, 1.0, 0.0)]))

func _ready():
	pass

func _process(delta):
	pass
