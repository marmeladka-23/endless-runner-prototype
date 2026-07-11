extends Node2D

# Префабы препятствий
@export var obstacle_scenes: Array[PackedScene]

# Настройки спавна
@export var spawn_interval: float = 2.0  # Интервал между спавном
@export var min_y: float = 100.0         # Минимальная Y координата
@export var max_y: float = 1900.0         # Максимальная Y координата

# Таймер для спавна
var spawn_timer: float = 0.0

func _ready():
	# Начинаем спавнить сразу
	spawn_timer = spawn_interval

func _process(delta):
	spawn_timer -= delta # Уменьшить таймер спавна
	
	if spawn_timer <= 0: # Если таймер достиг нуля
		spawn_obstacle()
		spawn_timer = spawn_interval # Сбросить таймер

func spawn_obstacle():
	if obstacle_scenes.is_empty():
		push_error("Нет префабов препятствий!")
		return
	
	# Выбираем случайный префаб
	var random_index = randi() % obstacle_scenes.size()
	var obstacle_scene = obstacle_scenes[random_index]
	
	# Создаем экземпляр
	var obstacle = obstacle_scene.instantiate()
	
	# Устанавливаем позицию (справа за экраном, случайная высота)
	var spawn_x = get_viewport_rect().size.x + 100
	var spawn_y = randf_range(min_y, max_y)
	obstacle.position = Vector2(spawn_x, spawn_y)
	
	# Добавляем на сцену
	get_parent().add_child(obstacle)
