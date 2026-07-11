extends Node2D

@export var collectible_scene: PackedScene
@export var min_spawn_interval: float = 2.0
@export var max_spawn_interval: float = 5.0

var spawn_timer: float = 0.0

func _ready():
	reset_spawn_timer()

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_item()
		reset_spawn_timer()

func reset_spawn_timer():
	spawn_timer = randf_range(min_spawn_interval, max_spawn_interval)

func spawn_item():
	if not collectible_scene:
		return
	
	var item = collectible_scene.instantiate()
	var spawn_x = get_viewport_rect().size.x + 50
	var spawn_y = randf_range(150, 1900)  # Фиксированный диапазон высот
	item.position = Vector2(spawn_x, spawn_y)
	
	get_parent().add_child(item)
