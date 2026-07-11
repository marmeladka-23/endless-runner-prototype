# Global.gd
extends Node

var final_score: int = 0
var high_score: int = 0

func set_final_score(score: int):
	final_score = score

func get_final_score() -> int:
	return final_score

func set_high_score(score: int):
	high_score = score

func get_high_score() -> int:
	return high_score
