extends Spatial

export var speed: float = 50.0
const TIME_ALIVE: float = 2.0

var forward_direction: Vector3
var timer: float

func _ready():
	forward_direction = global_transform.basis.z.normalized()

func _physics_process(delta):
	global_translate(forward_direction * speed * delta)

	timer += delta
	if timer >= TIME_ALIVE:
		queue_free()

func _on_Area_body_entered(body):
	queue_free()
