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
	self.velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		self.velocity.x += 1
	if Input.is_action_pressed("move_left"):
		self.velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		self.velocity.y += 1
	if Input.is_action_pressed("move_up"):
		self.velocity.y -= 1

	if self.velocity.length() > 0:
		self.velocity = self.velocity.normalized() * speed
		# $HyenaAnimation.play()
	elif self.is_eating:
		self.speed=0
		$HyenaAnimation.animation = "attack"
	elif self.is_dying:
		self.speed=0
		self.alive=false
		$HyenaAnimation.animation = "die"
	else:
		$HyenaAnimation.animation = "idle"

	move_and_collide(self.velocity*delta)

	if self.velocity.x != 0:
		$HyenaAnimation.animation = "walk"
		if self.velocity.x > 0:
			$HyenaAnimation.flip_h = true
		else:
			$HyenaAnimation.flip_h = false
	elif self.velocity.y != 0:
		$HyenaAnimation.animation = "walk"
		if self.velocity.y > 0:
			$HyenaAnimation.transform.rotated(90)
		else:
			$HyenaAnimation.transform.rotated(-90)

func _on_HyenaAnimation_animation_finished():
	if not self.alive:
		hide()
		$HyenaAnimation.stop()

func _on_FOVPolygon_body_entered(body:Node):
	pass
