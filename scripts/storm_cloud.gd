extends Area2D

@export var speed: float = 150.0
@export var attack_interval: float = 2.0
@export var bullet_scene: PackedScene

var player: Node2D
var can_attack: bool = true

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
	# Настраиваем таймер атаки
	$AttackTimer.wait_time = attack_interval
	$AttackTimer.start()
	$AttackTimer.timeout.connect(_on_attack_timer_timeout)
	
	# Подключаем сигналы столкновений
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	position.x -= speed * delta
	
	# Удаляем если ушло за экран
	if position.x < -100:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("bullet"):
		die()

func attack():
	if not can_attack or not player or not bullet_scene:
		return
	
	# Создаем молнию
	var bullet = bullet_scene.instantiate()
	
	# Направление к коту
	bullet.direction = (player.global_position - global_position).normalized() # Направление к игроку
	bullet.global_position = global_position # Позиция пули = позиция облака
	
	get_parent().add_child(bullet)
	
	can_attack = false
	$AttackTimer.start()
	
	print("Облако атакует!")

func _on_attack_timer_timeout():
	can_attack = true
	# 80% шанс атаковать когда таймер сработает
	if player and randf() > 0.2:
		attack()

func die():
	var player_node = get_tree().get_first_node_in_group("player")
	if player_node and player_node.has_method("add_score"):
		player_node.add_score(10)
	
	queue_free()
