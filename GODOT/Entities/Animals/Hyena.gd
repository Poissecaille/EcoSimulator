extends "Animal.gd"
var alive = true
var rng = RandomNumberGenerator.new()

export var damage = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$HyenaAnimation.play()

func start(pos):
	position = pos
	show()

func _process(delta):
	#process_inputs()
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

func want_mate():
	if (Behavior != BEHAVIOR.MATE && $MateCooldownTimer.time_left < 1):
		return true
	return false

func _on_FOVPolygon_body_entered(body):
	if (body == self):
		return

	if("Sheep" in body.name):
		if (want_hunt()):
			$FOVPolygon.set_deferred("monitoring", false)
			Behavior = BEHAVIOR.HUNT
			$CollisionShape2D.set_deferred("disabled", true)
			self.targetHunt=weakref(body)
			$HuntTimer.start()

	if("Hyena" in body.name):
		if (want_mate()):
			$FOVPolygon.set_deferred("monitoring", false)
			$CollisionShape2D.set_deferred("disabled", true)
			self.targetMate=weakref(body)
			self.targetMate.get_ref().Behavior = BEHAVIOR.MATE
			self.Behavior = BEHAVIOR.MATE
			$MateTimer.set_wait_time(10)
			$MateTimer.start()

func _on_HuntTimer_timeout():
	$FOVPolygon.set_deferred("monitoring",true)
	if targetHunt.get_ref() != null:
		var node = get_node(targetHunt.get_ref().get_path())
		var tmp1 = pow((node.position.x - position.x),2)
		var tmp2 = pow((node.position.y - position.y),2)
		if sqrt( tmp1 + tmp2 )< $FOVPolygon.hearing_distance:
			node.take_damage(damage)
			if node.State == STATE.INFECTED:
				State = STATE.INFECTED
			hunger = min(hunger+damage*10,100)
	Behavior= BEHAVIOR.NORMAL
	$CollisionShape2D.set_deferred("disabled",false)


func _on_MovementTimer_timeout():
	velocity.x=rng.randi_range(-1,1)
	velocity.y=rng.randi_range(-1,1)

func start_mate_cooldown():
	if ($MateCooldownTimer.time_left >= 0):
		$MateCooldownTimer.stop()
		$MateCooldownTimer.set_wait_time(self.mate_cooldown)
		$MateCooldownTimer.start()

func _on_MateTimer_timeout():
	if self != null:
		$FOVPolygon.set_deferred("monitoring",true)
		if self.targetMateNode != null && self.targetMateNode.get_ref() != null:
			var tmp1 = pow((self.targetMateNode.get_ref().position.x - position.x),2)
			var tmp2 = pow((self.targetMateNode.get_ref().position.y - position.y),2)
			if sqrt( tmp1 + tmp2 )< $FOVPolygon.hearing_distance:
				var child_count = rng.randi_range(1, self.max_child_per_mate)
				for _x in range(0, child_count):
					var child = get_parent().spawn_animal("Hyena", position.x, position.y)
					child.call_deferred("start_mate_cooldown")
				if self.targetMateNode.get_ref().State == STATE.INFECTED:
					State = STATE.INFECTED
			self.start_mate_cooldown()
			self.targetMateNode.get_ref().Behavior = BEHAVIOR.NORMAL
			self.targetMateNode.get_ref().start_mate_cooldown()

		Behavior = BEHAVIOR.NORMAL
		$CollisionShape2D.set_deferred("disabled",false)
