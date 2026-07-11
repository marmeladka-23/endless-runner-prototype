extends CharacterBody2D

# Настройки физики
@export var gravity: float = 980.0 # Гравитация
@export var jump_force: float = -400.0 # Сила прыжка

# Ссылки на ноды
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D # Анимированный спрайт
@onready var collision_shape: CollisionShape2D = $CollisionShape2D # Коллайдер
@onready var detection_area: Area2D = $DetectionArea # Область обнаружения

# Добавляем в экспортируемые переменные
@export var bullet_scene: PackedScene
@export var shoot_cooldown: float = 0.5
@export var max_health: int = 3

# Счет игрока
var score: int = 0
var is_alive: bool = true
var can_shoot: bool = true
var shoot_timer: Timer
var is_invulnerable: bool = false # Неуязвимость
var invulnerability_timer: Timer
var health: int = max_health
var spawn_protection: bool = true

func _ready():
	if animated_sprite:
		animated_sprite.play("fly")

	add_to_group("player")

	detection_area.area_entered.connect(_on_detection_area_entered)
	detection_area.body_entered.connect(_on_detection_body_entered)

	# Таймер стрельбы
	shoot_timer = Timer.new()
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.one_shot = true
	add_child(shoot_timer)
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

	# Таймер неуязвимости
	invulnerability_timer = Timer.new()
	invulnerability_timer.wait_time = 1.5
	invulnerability_timer.one_shot = true
	add_child(invulnerability_timer)
	invulnerability_timer.timeout.connect(_on_invulnerability_timeout)

	health = max_health
	update_health_ui()

	# Защита после появления
	spawn_protection = true
	await get_tree().create_timer(1.0).timeout
	spawn_protection = false
   
func take_damage(damage: int = 1):
	# Не получаем урон во время защиты после спавна
	if spawn_protection:
		return

	if not is_alive or is_invulnerable:
		return
	
	health -= damage
	print("Кот получил урон! Здоровье: ", health)
	
	# Обновляем UI здоровья
	update_health_ui()

func update_health_ui():
	var health_ui = get_tree().get_first_node_in_group("health_ui")
	if health_ui and health_ui.has_method("update_health"):
		health_ui.update_health(health)
	
	# Визуальный эффект
	if animated_sprite:
		animated_sprite.modulate = Color.RED
		await get_tree().create_timer(0.2).timeout
		animated_sprite.modulate = Color.WHITE
	
	# Включаем неуязвимость
	is_invulnerable = true
	invulnerability_timer.start()
	start_invulnerability_effect()
	
	if health <= 0:
		die()
		

func _on_invulnerability_timeout():
	is_invulnerable = false
	if animated_sprite:
		animated_sprite.modulate = Color.WHITE

func start_invulnerability_effect():
	var tween = create_tween()
	tween.tween_method(_set_sprite_alpha, 1.0, 0.3, 0.2)
	tween.tween_method(_set_sprite_alpha, 0.3, 1.0, 0.2)
	tween.set_loops(3)  

func _set_sprite_alpha(alpha: float):
	if animated_sprite:
		animated_sprite.modulate.a = alpha

func _physics_process(delta):
	if not is_alive:
		return
	
	velocity.y += gravity * delta
	check_screen_bounds()
	move_and_slide()
	
	# Проверяем столкновения с предметами через overlapping areas
	check_item_collisions()
	
	if is_alive and velocity.y > 0 and animated_sprite.animation != "fly":
		animated_sprite.play("fly")


func _on_detection_body_entered(body):
	if body.is_in_group("collectible") and is_alive:
		print("Обнаружен предмет через body_entered!")
		body.collect(self)

# Проверка столкновений с предметами
func check_item_collisions():
	if not is_alive:
		return
		
	# Получаем все области, с которыми пересекается detection_area
	var overlapping_areas = detection_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.is_in_group("collectible"):
			print("Обнаружен предмет через overlapping_areas!")
			area.collect(self)
			break

# Добавление очков
func add_score(points: int):
	score += points
	print("=== ОЧКИ ДОБАВЛЕНЫ! ===")
	print("Получено очков: ", points)
	print("Текущий счет: ", score)
	print("=======================")
	
	# Обновляем UI если есть
	update_ui_score()

func update_ui_score():
	# Если есть UI, обновляем его
	var ui = get_tree().get_first_node_in_group("ui")
	if ui and ui.has_method("update_score"):
		ui.update_score(score)

func get_score() -> int:
	return score


func _input(event):
	if not is_alive:
		return
	
	# Прыжок: ЛКМ, тачскрин, пробел
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) or \
	   (event is InputEventScreenTouch and event.pressed) or \
	   Input.is_action_just_pressed("ui_accept"):
		jump()
	
	# Стрельба: ПКМ
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		print("ПКМ нажата! Пытаемся стрелять...")
		print("can_shoot: ", can_shoot)
		print("bullet_scene: ", bullet_scene != null)
		shoot()

func shoot():
	if not is_alive:
		print("Не могу стрелять: игрок мертв")
		return
	
	if not can_shoot:
		print("Не могу стрелять: перезарядка")
		return
		
	if not bullet_scene:
		print("Не могу стрелять: bullet_scene не назначен")
		return
	
	# Создаем пулю
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	get_parent().add_child(bullet)
	
	can_shoot = false
	shoot_timer.start()
	
	print("Выстрел произведен!")

func _on_shoot_timer_timeout():
	can_shoot = true

func jump():
	velocity.y = jump_force
	if animated_sprite:
		animated_sprite.play("jump")

func check_screen_bounds():
	var viewport_rect = get_viewport_rect()
	var global_pos = global_position
	
	if global_pos.y < -50 or global_pos.y > viewport_rect.size.y + 50:
		die()

func _on_detection_area_entered(area):
	if area.is_in_group("obstacle") and is_alive:
		die()

func die():
	if not is_alive:
		return
	
	is_alive = false
	velocity = Vector2.ZERO
	
	if animated_sprite:
		animated_sprite.play("die")
	
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
	
	# Сохраняем финальный счет перед переходом
	save_final_score()
	
	print("Финальный счет: ", score)
	
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

# Сохранение финального счета для передачи на Game Over экран
func save_final_score():
	# Сохраняем в глобальной переменной если есть авто-загружаемый скрипт
	if Engine.has_singleton("Global"):
		var global = Engine.get_singleton("Global")
		global.set_final_score(score)
		
		# Получаем рекорд из UI
		var ui = get_tree().get_first_node_in_group("ui")
		if ui and ui.has_method("get_high_score"):
			global.set_high_score(ui.get_high_score())
	else:
		# Альтернативный способ через ProjectSettings
		var final_score_data = {
			"final_score": score,
			"high_score": get_ui_high_score()
		}
		ProjectSettings.set_setting("game_final_score", final_score_data)
		ProjectSettings.save()

# Получение рекорда из UI
func get_ui_high_score() -> int:
	var ui = get_tree().get_first_node_in_group("ui")
	if ui and ui.has_method("get_high_score"):
		return ui.get_high_score()
	return 0

func reset():
	is_alive = true
	health = max_health  # Восстанавливаем здоровье
	score = 0
	velocity = Vector2.ZERO
	global_position = Vector2(100, 300)
	is_invulnerable = false
	
	# Обновляем UI здоровья
	update_health_ui()
	
	if collision_shape:
		collision_shape.disabled = false
		
	if animated_sprite:
		animated_sprite.play("fly")
		animated_sprite.modulate = Color.WHITE
		
