class_name Animal
extends KinematicBody2D

export var hunger_rate = 0.5 # Nb of seconds before death
export var is_eating = false
export var is_dying = false
export var health = 100
export var hunger = 100
export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func process_hunger(delta):
	if (!self.is_dying):
		self.hunger -= delta * self.hunger_rate
		if (self.hunger <= 0):
			self.is_dying = true

func _process(delta):
	process_hunger(delta)

