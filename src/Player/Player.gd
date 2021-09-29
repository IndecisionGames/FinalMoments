extends KinematicBody

onready var gun_controller = $GunController

var speed = 8
var velocity = Vector3()

func _process(delta):
	pass

func _physics_process(delta):

	# Movement
	var direction = Vector3()

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1

	velocity = direction.normalized() * speed

	move_and_slide(velocity)

	# Shoot
	if Input.is_action_pressed("primary_action"):
		gun_controller.shoot()

func _on_Stats_destroy_self():
	# Die
	print("Game Over")
	queue_free()
