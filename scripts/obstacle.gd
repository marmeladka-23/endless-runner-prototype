extends Area2D

@export var speed: float = 200.0

func _ready():
	# Добавляем в группу препятствий
	add_to_group("obstacle")

func _physics_process(delta):
	# Двигаем препятствие справа налево
	position.x -= speed * delta
	
	# Удаляем, если вышло за экран
	if position.x < -200:
		queue_free()
