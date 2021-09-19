extends Spatial

export var speed: float = 50.0
export var damage: int = 1
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

func _on_Area_body_entered(body: Node):
	queue_free()

	if body.has_node("Stats"):
		var stats_node: Stats = body.find_node("Stats")
		stats_node.take_hit(damage)
