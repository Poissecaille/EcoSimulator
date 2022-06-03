extends Camera2D

export (bool) var key = true
export (bool) var wheel = true
export (int) var zoom_out_limit = 4
export (int) var camera_speed = 450
export (int) var camera_margin = 50

const camera_zoom_speed = Vector2(0.05, 0.05)

var camera_zoom = get_zoom()
var camera_movement = Vector2()
var _prev_mouse_pos = null
var __keys = [false, false, false, false]

func _physics_process(delta):
	if key:
		if __keys[0]:
			camera_movement.x -= camera_speed * delta
		if __keys[1]:
			camera_movement.y -= camera_speed * delta
		if __keys[2]:
			camera_movement.x += camera_speed * delta
		if __keys[3]:
			camera_movement.y += camera_speed * delta
	
	position += camera_movement * get_zoom()
	
	camera_movement = Vector2(0, 0)
	_prev_mouse_pos = get_local_mouse_position()

func _unhandled_input(event):
	if Input.is_key_pressed(KEY_T):
		if camera_zoom.x + camera_zoom_speed.x < zoom_out_limit and\
			camera_zoom.y + camera_zoom_speed.y < zoom_out_limit:
				camera_zoom += camera_zoom_speed
				set_zoom(camera_zoom)
	if Input.is_key_pressed(KEY_Y):
		if camera_zoom.x - camera_zoom_speed.x > 1 and\
			camera_zoom.y - camera_zoom_speed.y > 1:
				camera_zoom -= camera_zoom_speed
				set_zoom(camera_zoom)

	if event is InputEventMouseButton:
		if wheel:
			if event.button_index == BUTTON_WHEEL_UP and\
			camera_zoom.x - camera_zoom_speed.x > 1 and\
			camera_zoom.y - camera_zoom_speed.y > 1:
				camera_zoom -= camera_zoom_speed
				set_zoom(camera_zoom)
			if event.button_index == BUTTON_WHEEL_DOWN and\
			camera_zoom.x + camera_zoom_speed.x < zoom_out_limit and\
			camera_zoom.y + camera_zoom_speed.y < zoom_out_limit:
				camera_zoom += camera_zoom_speed
				set_zoom(camera_zoom)

	if event.is_action_pressed("ui_left"):
		__keys[0] = true
	if event.is_action_pressed("ui_up"):
		__keys[1] = true
	if event.is_action_pressed("ui_right"):
		__keys[2] = true
	if event.is_action_pressed("ui_down"):
		__keys[3] = true
	if event.is_action_released("ui_left"):
		__keys[0] = false
	if event.is_action_released("ui_up"):
		__keys[1] = false
	if event.is_action_released("ui_right"):
		__keys[2] = false
	if event.is_action_released("ui_down"):
		__keys[3] = false
