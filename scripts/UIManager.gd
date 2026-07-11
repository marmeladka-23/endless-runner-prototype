extends CanvasGroup

# Ссылки на UI элементы
@onready var score_label: Label = $ScoreLabel
@onready var high_score_label: Label = $HighScoreLabel

# Переменные счета
var current_score: int = 0
var high_score: int = 0

func _ready():
	# Загружаем рекорд
	load_high_score()
	update_score_display()
	add_to_group("ui")

# Обновление счета
func update_score(new_score: int):
	current_score = new_score
	update_score_display()
	
	if current_score > high_score:
		high_score = current_score
		save_high_score()
		update_high_score_display()

# Обновление отображения счета
func update_score_display():
	if score_label:
		score_label.text = "Score: " + str(current_score)

# Обновление отображения рекорда
func update_high_score_display():
	if high_score_label:
		high_score_label.text = "Best: " + str(high_score)

# Сохранение рекорда
func save_high_score():
	var config = ConfigFile.new()
	config.set_value("game", "high_score", high_score)
	config.save("user://high_score.cfg")

# Загрузка рекорда
func load_high_score():
	var config = ConfigFile.new()
	if config.load("user://high_score.cfg") == OK:
		high_score = config.get_value("game", "high_score", 0)
	update_high_score_display()

# Получить текущий счет
func get_current_score() -> int:
	return current_score

# Получить рекорд
func get_high_score() -> int:
	return high_score

# Сброс счета
func reset_score():
	current_score = 0
	update_score_display()
