xtends CanvasLayer

# Ссылки на UI элементы
@onready var final_score_label: Label = $FinalScoreLabel
@onready var high_score_label: Label = $HighScoreLabel
@onready var new_record_label: Label = $NewRecordLabel
@onready var restart_button: Button = $RestartButton

# Данные счета
var final_score: int = 0
var high_score: int = 0

func _ready():
	# Загружаем данные счета
	load_score_data()
	
	# Обновляем отображение
	update_display()
	
	# Подключаем кнопку
	restart_button.pressed.connect(_on_restart_pressed)
	
	# Показываем/скрываем надпись о новом рекорде
	if final_score > high_score:
		new_record_label.visible = true
	else:
		new_record_label.visible = false

# Загрузка данных счета
func load_score_data():
	# Способ 1: Через ProjectSettings
	var score_data = ProjectSettings.get_setting("final_score_data", {})
	if score_data is Dictionary and score_data.has("score"):
		final_score = score_data.get("score", 0)
		high_score = score_data.get("high_score", 0)
	else:
		# Способ 2: Через авто-загружаемый скрипт
		if Engine.has_singleton("global_1"):
			var global = Engine.get_singleton("global_1")
			final_score = global.get_final_score()
			high_score = global.get_high_score()
		else:
			# Способ 3: Загружаем из сохранения
			final_score = load_final_score()
			high_score = load_high_score()

# Обновление отображения
func update_display():
	if final_score_label:
		final_score_label.text = "Your Score: " + str(final_score)
	
	if high_score_label:
		high_score_label.text = "Best Score: " + str(high_score)

# Загрузка финального счета из файла
func load_final_score() -> int:
	var config = ConfigFile.new()
	if config.load("user://final_score.cfg") == OK:
		return config.get_value("game", "final_score", 0)
	return 0

# Загрузка рекорда из файла
func load_high_score() -> int:
	var config = ConfigFile.new()
	if config.load("user://high_score.cfg") == OK:
		return config.get_value("game", "high_score", 0)
	return 0

# Обработка нажатия кнопки рестарта
func _on_restart_pressed():
	get_tree().change_scene_to_file("res://main.tscn")  # Ваша главная сцена
