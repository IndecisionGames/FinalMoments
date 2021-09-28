extends Node

class_name Stats

export var max_hp = 4
var current_hp = 0

signal destroy_self

func _ready():
	current_hp = max_hp

func take_hit(damage):
	current_hp -= damage
	print("Hit for ", damage, ". Current hp: ", current_hp)

	if current_hp <= 0:
		die()

func die():
	emit_signal("destroy_self")
