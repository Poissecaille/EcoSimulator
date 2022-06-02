extends "Animal.gd"
var screen_size
var terrain
var alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$HyenaAnimation.play()
	terrain=get_parent().get_node("Terrain")
	screen_size = Vector2(terrain.width*32,terrain.height*32)

func start(pos):
	position = pos
	show()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if self.alive:
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
	elif self.is_eating:
		self.speed=0
		$HyenaAnimation.animation = "attack"
	elif self.is_dying:
		self.speed=0
		self.alive=false
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


func _on_HyenaAnimation_animation_finished():
	if not self.alive:
		hide()
		$HyenaAnimation.stop()
