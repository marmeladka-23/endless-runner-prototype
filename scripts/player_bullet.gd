extends Area2D

@export var speed: float = 400.0

func _ready():
	add_to_group("bullet")
	area_entered.connect(_on_area_entered) # Подключить сигнал столкновения

func _physics_process(delta):
	position.x += speed * delta
	
	# Уничтожение если вышла за экран
	if position.x > get_viewport_rect().size.x + 50:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("enemy"):  # Если столкнулись с врагом
		print("Пуля уничтожила врага и самоуничтожилась!")
		# Уничтожаем врага
		if area.has_method("die"):
			area.die()
		# Уничтожаем пулю
		queue_free()
