extends "Animal.gd"
var alive = true

export var damage = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$HyenaAnimation.play()

func start(pos):
	position = pos
	show()

func _process(delta):
	process_inputs()

	if self.velocity.length() > 0:
		self.velocity = self.velocity.normalized() * speed
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

func process_inputs():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("player_right"):
		velocity.x += 1
	if Input.is_action_pressed("player_left"):
		velocity.x -= 1
	if Input.is_action_pressed("player_down"):
		velocity.y += 1
	if Input.is_action_pressed("player_up"):
		velocity.y -= 1

func _on_HyenaAnimation_animation_finished():
	if not self.alive:
		hide()
		$HyenaAnimation.stop()

func _on_FOVPolygon_body_entered(body):
	if("Sheep" in body.name):
		$FOVPolygon.set_deferred("monitoring", false)
		Behavior = BEHAVIOR.HUNT
		$CollisionShape2D.set_deferred("disabled", true)
		target=body.get_path()
		$HuntTimer.start()

	if("Hyena" in body.name):
		if (want_mate()):
			$FOVPolygon.set_deferred("monitoring", false)
			Behavior = BEHAVIOR.MATE
			$CollisionShape2D.set_deferred("disabled", true)
			target=body.get_path()
			$MateTimer.start()

func _on_HuntTimer_timeout():
	$FOVPolygon.set_deferred("monitoring",true)
	var node = get_node(target)
	if node != null:
		var tmp1 = pow((node.position.x - position.x),2)
		var tmp2 = pow((node.position.y - position.y),2)
		if sqrt( tmp1 + tmp2 )< $FOVPolygon.hearing_distance:
			node.take_damage(damage)
			if node.State == STATE.INFECTED:
				State = STATE.INFECTED
			hunger = min(hunger+damage*10,100)
	Behavior= BEHAVIOR.NORMAL
	$CollisionShape2D.set_deferred("disabled",false)
