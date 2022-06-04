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
var velocity = Vector2.ZERO

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

func _process(delta):
	process_hunger(delta)
	
