extends CanvasLayer

@export var full_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D

@onready var hearts = [
	$HBoxContainer/Heart1,
	$HBoxContainer/Heart2, 
	$HBoxContainer/Heart3
]

func _ready():
	add_to_group("health_ui")
	update_health(3)  # Начальное значение

func update_health(current_health: int):
	for i in range(hearts.size()):
		if i < current_health:
			hearts[i].texture = full_heart_texture
		else:
			hearts[i].texture = empty_heart_texture
	
	print("Здоровье обновлено: ", current_health)
