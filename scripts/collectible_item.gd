extends Area2D

# Типы предметов и их стоимость в очках
enum ItemType {COIN = 1, GEM = 1, STAR = 1}
@export var item_type: ItemType = ItemType.COIN

# Скорость движения
@export var speed: float = 170.0

func _ready():
	# Случайный тип предмета
	item_type = ItemType.values()[randi() % ItemType.size()]
	
	# ДОБАВЛЯЕМ В ГРУППУ
	add_to_group("collectible")
	
	# ПОДКЛЮЧАЕМ СИГНАЛ
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	# Двигаем предмет справа налево
	position.x -= speed * delta
	
	# Удаляем если вышел за экран
	if position.x < -100:
		queue_free()

# Получить количество очков за предмет
func get_points() -> int:
	return item_type

# Обработка столкновения с игроком
func _on_body_entered(body):
	if body.is_in_group("player"):
		collect(body)

func collect(player):
	print("Предмет собран! Тип: ", item_type, " Очки: ", get_points())
	
	# Передаем очки игроку
	if player.has_method("add_score"):
		player.add_score(get_points())
	
	# Удаляем предмет
	queue_free()
