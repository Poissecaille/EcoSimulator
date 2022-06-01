extends "Animal.gd"
var screen_size
var terrain

# Called when the node enters the scene tree for the first time.
func _ready():
	terrain=get_parent().get_node("Terrain")
	screen_size = Vector2(terrain.width*32,terrain.height*32)

func start(pos):
	position = pos
	show()

func _process(delta):
	$HyenaAnimation.play()
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# $HyenaAnimation.play()
	elif self.is_eating:
		self.speed=0
		$HyenaAnimation.animation = "attack"
		# $HyenaAnimation.play()
	elif self.is_dying:
		self.speed=0
		$HyenaAnimation.animation = "die"
	else:
		$HyenaAnimation.animation = "idle"

	move_and_collide(velocity*delta)

	if velocity.x != 0:
		$HyenaAnimation.animation = "walk"
		if velocity.x > 0:
			$HyenaAnimation.flip_h = true
		else:
			$HyenaAnimation.flip_h = false
	elif velocity.y != 0:
		$HyenaAnimation.animation = "walk"
		if velocity.y > 0:
			$HyenaAnimation.transform.rotated(90)
		else:
			$HyenaAnimation.transform.rotated(-90)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
