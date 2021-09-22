extends Spatial

export(PackedScene) var Zombie
onready var timer = $Timer

var to_spawn: int
var killed: int

var waves: Array # list of all Wave nodes: [ Wave1, Wave2, Wave3, ... ]
var current_wave: Wave
var current_wave_number: int = -1

func _ready():
	waves = $Waves.get_children()
	start_next_wave()

func start_next_wave():
	killed = 0
	current_wave_number += 1
	if current_wave_number < waves.size():
		current_wave = waves[current_wave_number]
		to_spawn = current_wave.num_enemies
		timer.wait_time = current_wave.spawn_delay
		timer.start()

func connect_to_zombie_signals(zombie: Zombie):
	var stats: Stats = zombie.get_node("Stats")
	stats.connect("destroy_self", self, "_on_Zombie_Stats_destroy_self")

func _on_Zombie_Stats_destroy_self():
	killed += 1

func spawn_enemy():
	if to_spawn > 0:
		var zombie = Zombie.instance()
		connect_to_zombie_signals(zombie)
		var scene_root = get_parent()
		scene_root.add_child(zombie)
		to_spawn -= 1
	else:
		if killed >= current_wave.num_enemies:
			start_next_wave()

func _on_Timer_timeout():
	spawn_enemy()
