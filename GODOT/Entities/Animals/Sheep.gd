extends "Animal.gd"

enum BEHAVIOR {NORMAL, PANIC, WEAK}
enum STATE {NORMAL, INFECTED}
export(BEHAVIOR) var Behavior = BEHAVIOR.NORMAL
export(STATE) var State = STATE.NORMAL

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

func check_health():
	if (health < max_health/2):
		Behavior= BEHAVIOR.WEAK
	if (health <= 0):
		queue_free()

func get_infected():
	State = STATE.INFECTED
	$InfectionTimer.start()

func take_damage(damage):
	health-= damage
	$PanicTimer.start()
	$MovementTimer.set_wait_time(0.2)
	Behavior= BEHAVIOR.PANIC

func move(delta):
	if velocity.length() > 0:
		match Behavior:
			BEHAVIOR.WEAK:
				velocity = velocity.normalized() * (speed/2)
			BEHAVIOR.NORMAL:
				velocity = velocity.normalized() * speed
			BEHAVIOR.PANIC:
				velocity = velocity.normalized() * (speed*4)
		move_and_collide(velocity*delta)
	
	
func process_inputs():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

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
