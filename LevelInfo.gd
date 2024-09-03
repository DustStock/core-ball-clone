extends Node

# used to call
# setup_level(ball_goals: int, bad_balls: Array, level_number: int)
# when setting up level 
# Called when the node enters the scene tree for the first time.

# Level data with increasing difficulty
var ball_goals: Array = [
	2,  # Level 1 - Easy
	3,  # Level 2 - Moderate
	4,  # Level 3 - Harder
	5,  # Level 4 - Hard
	6   # Level 5 - Very Hard
]

# Each entry in bad_balls contains an array of rotation degrees for the enemy balls
var bad_balls: Array = [
	[45, 135],               # Level 1 - 2 enemy balls, large spaces
	[30, 150, 270],          # Level 2 - 3 enemy balls, moderate spaces
	[20, 100, 180, 260],     # Level 3 - 4 enemy balls, smaller spaces
	[10, 80, 150, 220, 290], # Level 4 - 5 enemy balls, small spaces
	[0, 60, 120, 180, 240, 300] # Level 5 - 6 enemy balls, very small spaces
]

var level_number: int = 1

func incrementLevel():
	level_number += 1

func get_ball_goals():
	return ball_goals[level_number - 1]

func get_bad_balls():
	return bad_balls[level_number - 1]

func num_levels():
	var num: int  = ball_goals.size()
	if num > bad_balls.size():
		num = bad_balls.size()
	return num
