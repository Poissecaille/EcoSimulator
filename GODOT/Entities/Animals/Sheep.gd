extends KinematicBody2D

enum BEHAVIOR {NORMAL, PANIC, WEAK}
export(BEHAVIOR) var Behavior = BEHAVIOR.NORMAL

export var speed = 50
export var MAX_HEALTH = 10
export var MAX_HUNGER = 10

var hunger
var health
var screen_size
var terrain
var currentVelocity = Vector2.ZERO
var resting = false
var rng = RandomNumberGenerator.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
#	terrain=get_parent().get_node("Terrain")
#	screen_size = Vector2(terrain.width*32,terrain.height*32)
	health=MAX_HEALTH
	hunger=MAX_HUNGER
	
	
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
	if currentVelocity.y > 0:
		$AnimatedSprite.animation = "walk_bot"
	if currentVelocity.y < 0:
		$AnimatedSprite.animation= "walk_top"
	if currentVelocity.x < 0 && currentVelocity.y ==0: 
		$AnimatedSprite.animation= "walk_left"
	if currentVelocity.x > 0 && currentVelocity.y ==0: 
		$AnimatedSprite.animation= "walk_right"
	
	
func check_health():
	if (health< MAX_HEALTH/2):
		Behavior= BEHAVIOR.WEAK
		

func take_damage(damage):
	health-= damage
	$PanicTimer.start()
	$MovementTimer.set_wait_time(0.2)
	Behavior= BEHAVIOR.PANIC
	
	



func move(delta):
	if currentVelocity.length() > 0:
		match Behavior:
			BEHAVIOR.WEAK:
				currentVelocity = currentVelocity.normalized() * (speed/2)
			BEHAVIOR.NORMAL:
				currentVelocity = currentVelocity.normalized() * speed
			BEHAVIOR.PANIC:
				currentVelocity = currentVelocity.normalized() * (speed*4)
		move_and_collide(currentVelocity*delta)
	
	
func process_inputs():
	currentVelocity= Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		currentVelocity.x += 1
	if Input.is_action_pressed("move_left"):
		currentVelocity.x -= 1
	if Input.is_action_pressed("move_down"):
		currentVelocity.y += 1
	if Input.is_action_pressed("move_up"):
		currentVelocity.y -= 1

	


func _on_RegenTimer_timeout():
	if(health< MAX_HEALTH and hunger > MAX_HUNGER/2):
		health+=1
		hunger-=1
	


func _on_MovementTimer_timeout():
	if(resting):
		currentVelocity = Vector2.ZERO
	else :
		currentVelocity.x=rng.randi_range(-1,1)
		currentVelocity.y=rng.randi_range(-1,1)
	resting = not resting
	



func _on_PanicTimer_timeout():
	Behavior = BEHAVIOR.NORMAL
	$MovementTimer.set_wait_time(2)


func _on_TestActionTimer_timeout():
	pass
