extends KinematicBody

class_name Zombie

onready var nav: Navigation = $"../Navigation"
onready var player: KinematicBody = $"../Player"
onready var attack_timer: Timer = $AttackTimer

var default_material = load("res://resources/ZombieDefaultMaterial.tres")
var attack_material = load("res://resources/ZombieAttackMaterial.tres")

var path = []
var speed = 5
var attacking_speed_multiplier = 3

var attack_target: Vector3
var return_target: Vector3

enum state {
	SEEKING,
	ATTACKING,
	RETURNING,
	RESTING
}

var current_state = state.SEEKING

func _ready():
	$MeshInstance.set_surface_material(0, default_material)

func _physics_process(delta):
	match current_state:
		state.SEEKING:
			if len(path) > 0:
				var direction: Vector3 = path[0] - global_transform.origin
				if direction.length() < 1:
					path.remove(0)
				else:
					move_and_slide(direction.normalized() * speed)
		state.ATTACKING:
			move_and_attack()
		state.RETURNING:
			move_and_attack()
		state.RESTING:
			pass

func move_and_attack():
	var attack_vector: Vector3 = attack_target - global_transform.origin
	var direction: Vector3 = attack_vector.normalized()
	var distance = attack_vector.length()

	move_and_slide(direction * speed * attacking_speed_multiplier)

	match current_state:
		state.ATTACKING:
			if distance < 2.5:
				current_state = state.RETURNING
				attack_target = return_target
		state.RETURNING:
			if distance < 0.5:
				current_state = state.RESTING
				$MeshInstance.set_surface_material(0, default_material)
				collide_with_other_zombies(true)
				attack_timer.start()

func collide_with_other_zombies(should_collide):
	set_collision_mask_bit(2, should_collide)
	set_collision_layer_bit(2, should_collide)

func update_path(target_position):
	path = nav.get_simple_path(global_transform.origin, target_position)

func _on_Stats_destroy_self():
	queue_free()

func _on_AttackArea_body_entered(body):
	if body == player:
		attack_target = player.global_transform.origin
		return_target = global_transform.origin
		current_state = state.ATTACKING
		$MeshInstance.set_surface_material(0, attack_material)
		collide_with_other_zombies(false)

func _on_PathUpdateTimer_timeout():
	update_path(player.global_transform.origin)

func _on_AttackTimer_timeout():
	current_state = state.SEEKING
