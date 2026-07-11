extends Area2D

@export var speed: float = 300.0
@export var damage: int = 1

var direction: Vector2

func _ready():
	add_to_group("enemy_bullet")
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
	# Автоудаление через 5 секунд
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _physics_process(delta):
	position += direction * speed * delta
	
	# Удаляем если ушло за экран
	if position.x < -100 or position.x > get_viewport_rect().size.x + 100:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("player"):
		print("Молния попала в кота!")
		if area.has_method("take_damage"):
			area.take_damage(damage)
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Молния попала в кота (body)!")
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
