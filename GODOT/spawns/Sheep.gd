extends "pawn.gd"

onready var Grid = get_parent()
var direction
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	update_look_direction(Vector2(1, 0))

func _process(delta):
	pass



func input_based_movement():
	var input_direction = get_input_direction()
	if not input_direction:
		return
	update_look_direction(input_direction)

	var target_position = Grid.request_move(self, input_direction)
	if target_position:
		move_to(target_position)
	else:
		return


func get_input_direction():
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)

func update_look_direction(direction):
	#$Sprite.rotation = direction.angle()
	self.direction = direction

func move_to(target_position):
	set_process(false)

	if(direction.y == 1):
		$AnimationPlayer.play("walk_down")
	if(direction.y == -1):
		$AnimationPlayer.play("walk_up")
	if(direction.x == 1 && direction.y == 0):
		$AnimationPlayer.play("walk_right")
	if(direction.x == -1 && direction.y == 0):
		$AnimationPlayer.play("walk_left")
		
	# Move the node to the target cell instantly,
	# and animate the sprite moving from the start to the target cell
	var move_direction = (target_position - position).normalized()
		
	$Tween.interpolate_property(
		self,"position",
		position,target_position,
		$AnimationPlayer.current_animation_length,
		Tween.TRANS_LINEAR, Tween.EASE_IN)

	$Tween.start()

	# Stop the function execution until the animation finished
	yield($AnimationPlayer, "animation_finished")
	
	set_process(true)

func _on_MovementTimer_timeout():
	var x = rng.randi_range(-1,1)
	var y = rng.randi_range(-1,1)
	
	var input_direction = Vector2(x,y)
	if not input_direction:
		return
	update_look_direction(input_direction)

	var target_position = Grid.request_move(self, input_direction)
	if target_position:
		move_to(target_position)
	else:
		return
