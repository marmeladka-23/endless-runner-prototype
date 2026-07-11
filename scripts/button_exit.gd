extends Button

func _ready():
	# Подключаем сигнал нажатия
	pressed.connect(_on_pressed)

func _on_pressed():
	# Выход из игры
	get_tree().quit()
