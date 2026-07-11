extends Sprite2D

func _ready():
	# Загружаем состояние из глобальной переменной
	visible = Global.sprite_visible

func _input(event):
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) or \
	   (event is InputEventScreenTouch and event.pressed):
		
		# Скрываем и сохраняем в глобальной переменной
		visible = false
		Global.hide_sprite_globally()
		
		# Отключаем дальнейшую обработку input для этого спрайта
		set_process_input(false)
