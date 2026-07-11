extends Button

# Путь к целевой сцене
@export_file("*.tscn") var target_scene: String

func _ready():
	# Подключаем сигнал нажатия
	pressed.connect(_on_pressed)

func _on_pressed():
	if target_scene:
		# Переход на другую сцену
		get_tree().change_scene_to_file(target_scene)
	else:
		print("Ошибка: target_scene не указан!")
