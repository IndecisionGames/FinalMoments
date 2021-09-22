extends KinematicBody

class_name Zombie

onready var nav: Navigation = $"../Navigation"
onready var player: KinematicBody = $"../Player"

var path = []
var speed = 5

func _ready():
	pass

func _physics_process(delta):
	if len(path) > 0:
		var direction: Vector3 = path[0] - global_transform.origin
		if direction.length() < 1:
			path.remove(0)
		else:
			move_and_slide(direction.normalized() * speed)

func update_path(target_position):
	path = nav.get_simple_path(global_transform.origin, target_position)

func _on_Timer_timeout():
	update_path(player.global_transform.origin)

func _on_Stats_destroy_self():
	queue_free()
