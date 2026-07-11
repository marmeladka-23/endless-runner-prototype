extends Area2D

# Скорость движения
@export var speed: float = 200.0

func _ready():
	# Добавляем себя в группу "obstacle" для идентификации
	add_to_group("obstacle")
	
	# Подключаем сигнал столкновения
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position.x -= speed * delta
	
	# Удаляем, если вышло за экран
	if position.x < -100:
		queue_free()

# Обработка столкновения с игроком
func _on_area_entered(area):
	if area.is_in_group("player"):
		print("Столкновение с игроком (area)")
		# area.die() - если игрок тоже Area2D

# Обработка столкновения с игроком 
func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Столкновение с игроком (body)")
		if body.has_method("die"):
			body.die()
# Метод для изменения скорости извне
func set_speed(new_speed: float):
	speed = new_speed
