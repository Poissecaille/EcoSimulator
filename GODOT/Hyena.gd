extends Area2D


export var speed = 100
var health = 10
var screen_size # Size of the game window.
export var is_eating = false
export var is_dying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

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
		$HyenaAnimation.play()
	elif self.is_dying:
		self.speed=0
		$HyenaAnimation.animation = "die"
	else:
		$HyenaAnimation.animation = "idle"
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if velocity.x != 0:
		$HyenaAnimation.animation = "walk"
		if velocity.x > 0:
			$HyenaAnimation.flip_h = true
		else:
			$HyenaAnimation.flip_h = false
	elif velocity.y != 0:
		if velocity.y > 0:
			$HyenaAnimation.transform.rotated(90)
		else:
			$HyenaAnimation.transform.rotated(-90)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
