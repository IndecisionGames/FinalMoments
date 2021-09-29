extends Spatial

onready var player = $Player
onready var hand = $Player/Body/Hand
onready var camera = $Camera

var ray_origin = Vector3()
var ray_target = Vector3()

func _physics_process(delta):
	if is_instance_valid(player):
		var mouse_position = get_viewport().get_mouse_position()

		ray_origin = camera.project_ray_origin(mouse_position)
		ray_target = ray_origin + camera.project_ray_normal(mouse_position) * 1000

		var space_state = get_world().direct_space_state
		var intersection = space_state.intersect_ray(ray_origin, ray_target, [], 8)

		if not intersection.empty():
			var pos = intersection.position
			var look_at_me = Vector3(pos.x, player.translation.y, pos.z)
			player.look_at(look_at_me, Vector3.UP)
			var distance_to_pointer = (hand.global_transform.origin - look_at_me).length()
			if distance_to_pointer > 3:
				hand.look_at(look_at_me, Vector3.UP)
