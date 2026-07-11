# Global.gd
extends Node

var sprite_visible: bool = true

func _ready():
	# Можно загрузить из сохранения если нужно
	pass

func hide_sprite_globally():
	sprite_visible = false

func show_sprite_globally():
	sprite_visible = true

func is_sprite_visible() -> bool:
	return sprite_visible
