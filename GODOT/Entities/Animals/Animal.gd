class_name Animal
extends KinematicBody2D

export var hunger_rate = 0.5 # Nb of seconds before death
export var regen_rate = 1 # Nb of seconds 1 health regen with hunger
export var is_eating = false
export var is_dying = false
export var health = 100
export var max_health = 100
export var max_hunger = 100
export var hunger = 100
export var speed = 200
export var mate_cooldown = 120
export var max_child_per_mate = 1

var targetMate
var targetMateNode
var targetMatePosition
var targetHunt
var targetHuntNode
var targetHuntPosition

var velocity = Vector2.ZERO

enum BEHAVIOR {NORMAL, HUNT, PANIC, WEAK, MATE}
enum STATE {NORMAL, INFECTED}
export(BEHAVIOR) var Behavior = BEHAVIOR.NORMAL
export(STATE) var State = STATE.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func process_hunger(delta):
	if (!self.is_dying):
		self.hunger -= delta * self.hunger_rate
		if (self.hunger <= 0):
			self.is_dying = true

func process_regen(delta):
	if (health < max_health and hunger > max_hunger/2):
		health += regen_rate * delta
		hunger -= regen_rate * delta

func want_hunt():
	if (State != STATE.NORMAL || Behavior != BEHAVIOR.NORMAL):
		return false
	if (hunger < (0.6 * max_hunger)):
		return false
	return true

func check_health():
	if (health < max_health/2):
		Behavior= BEHAVIOR.WEAK
	if (health <= 0):
		queue_free()

func get_infected():
	State = STATE.INFECTED
	$InfectionTimer.start()

func is_stuck():
	var transform2d = get_transform()
	var down = test_move(transform2d, Vector2(0, 1))
	var up = test_move(transform2d, Vector2(0, -1))
	var right = test_move(transform2d, Vector2(1, 0))
	var left = test_move(transform2d, Vector2(-1, 0))

	return down && up && right && left

func move(delta):
	if velocity.length() > 0:
		match Behavior:
			BEHAVIOR.WEAK:
				velocity = velocity.normalized() * (speed/2)
			BEHAVIOR.NORMAL:
				velocity = velocity.normalized() * speed
			BEHAVIOR.MATE:
				velocity = Vector2.ZERO
			BEHAVIOR.PANIC:
				velocity = velocity.normalized() * (speed*4)
		if is_stuck():
			while (is_stuck()):
				position.x = position.x + 5
				position.y = position.y + 5
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

func _process(delta):
	process_hunger(delta)
	if (Behavior == BEHAVIOR.HUNT and targetHunt != null and targetHunt.get_ref() != null):
		targetHuntNode = get_node(targetHunt.get_ref().get_path())
		targetHuntPosition = targetHuntNode.position
		velocity.x = targetHuntNode.position.x - position.x
		velocity.y = targetHuntNode.position.y - position.y

	if (Behavior == BEHAVIOR.MATE and targetMate != null and targetMate.get_ref() != null):
		targetMateNode = get_node(targetMate.get_ref().get_path())
		targetMatePosition = targetMateNode.position
		velocity.x = targetMateNode.position.x - position.x
		velocity.y = targetMateNode.position.y - position.y
