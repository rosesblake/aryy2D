extends Node

var total_score = 0
var level_score = 0
var current_level_path = ""

func add_point():
	total_score += 1
	level_score += 1

func reset_level_score():
	level_score = 0
