extends "Animal.gd"

var resting = false
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.

func _ready():
	rng.randomize()

func start(pos):
	position = pos
	show()

func _process(delta):
	$AnimatedSprite.play()
	check_health()
	#process_inputs()
	move(delta)
	update_animation()

func update_animation():
	if velocity.y > 0:
		$AnimatedSprite.animation = "walk_bot"
	if velocity.y < 0:
		$AnimatedSprite.animation= "walk_top"
	if velocity.x < 0 && velocity.y ==0:
		$AnimatedSprite.animation= "walk_left"
	if velocity.x > 0 && velocity.y ==0:
		$AnimatedSprite.animation= "walk_right"


func take_damage(damage):
	health-= damage
	$PanicTimer.start()
	$MovementTimer.set_wait_time(0.2)
	Behavior= BEHAVIOR.PANIC

func _on_MovementTimer_timeout():
	if(resting):
		velocity = Vector2.ZERO
	else :
		velocity.x=rng.randi_range(-1,1)
		velocity.y=rng.randi_range(-1,1)
	resting = not resting

func _on_PanicTimer_timeout():
	Behavior = BEHAVIOR.NORMAL
	$MovementTimer.set_wait_time(2)

func _on_TestActionTimer_timeout():
	pass

func _on_InfectionTimer_timeout():
	State = STATE.NORMAL

func want_mate():
	if (Behavior != BEHAVIOR.MATE && $MateCooldownTimer.time_left == 0):
		return true
	return false

func _on_FOVPolygon_body_entered(body):
	# TODO : Figure out why decting itself
	if (body == self):
		return

	if("Sheep" in body.name):
		if (want_mate()):
			$FOVPolygon.set_deferred("monitoring", false)
			$CollisionShape2D.set_deferred("disabled", true)
			self.targetMate=weakref(body)
			self.targetMate.get_ref().Behavior = BEHAVIOR.MATE
			$MateTimer.set_wait_time(10)
			$MateTimer.start()

	if("Hyena" in body.name):
		$FOVPolygon.set_deferred("monitoring", false)
		Behavior = BEHAVIOR.PANIC
		$PanicTimer.start()

func start_mate_cooldown():
	if ($MateCooldownTimer.time_left >= 0):
		$MateCooldownTimer.stop()
		$MateCooldownTimer.set_wait_time(self.mate_cooldown)
		$MateCooldownTimer.start()

func _on_MateTimer_timeout():
	if self != null:
		$FOVPolygon.set_deferred("monitoring",true)
		if self.targetMateNode != null:
			var tmp1 = pow((self.targetMateNode.position.x - position.x),2)
			var tmp2 = pow((self.targetMateNode.position.y - position.y),2)
			if sqrt( tmp1 + tmp2 )< $FOVPolygon.hearing_distance:
				var child_count = rng.randi_range(1, self.max_child_per_mate)
				for _x in range(0, child_count):
					var child = get_parent().spawn_animal("Sheep", position.x, position.y)
					child.start_mate_cooldown()
				if self.targetMateNode.State == STATE.INFECTED:
					State = STATE.INFECTED
			self.start_mate_cooldown()
			self.targetMateNode.Behavior = BEHAVIOR.NORMAL
			self.targetMateNode.start_mate_cooldown()

		Behavior = BEHAVIOR.NORMAL
		$CollisionShape2D.set_deferred("disabled",false)
