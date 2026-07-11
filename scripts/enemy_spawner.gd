extends Node2D

@export var enemy_scene: PackedScene
@export var min_spawn_time: float = 5.0
@export var max_spawn_time: float = 10.0

func _ready():
	$SpawnTimer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	$SpawnTimer.start()
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout():
	spawn_enemy()
	# Случайный интервал для следующего спавна
	$SpawnTimer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	$SpawnTimer.start()

func spawn_enemy():
	if not enemy_scene:
		return
	
	var enemy = enemy_scene.instantiate()
	
	# Спавним справа за экраном
	var viewport_size = get_viewport_rect().size
	enemy.position = Vector2(viewport_size.x + 50, randf_range(50, viewport_size.y - 50))
	
	get_parent().add_child(enemy)
