extends KinematicBody2D

export var speed = 100
var health = 10
var screen_size
var terrain
export var is_eating = false
export var is_dying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	terrain=get_parent().get_node("Terrain")
	screen_size = Vector2(terrain.width*32,terrain.height*32)

func start(pos):
	position = pos
	show()
	
	
func _process(delta):
	process_inputs(delta)




func process_inputs(delta):
	$AnimatedSprite.play()
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
	
	move_and_collide(velocity*delta)
	if velocity.y > 0:
		$AnimatedSprite.animation = "walk_bot"
	if velocity.y < 0:
		$AnimatedSprite.animation= "walk_top"
	if velocity.x < 0 && velocity.y ==0: 
		$AnimatedSprite.animation= "walk_left"
	if velocity.x > 0 && velocity.y ==0: 
		$AnimatedSprite.animation= "walk_right"

