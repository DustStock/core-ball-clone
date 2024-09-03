extends Node2D

@onready var center_ball = $CenterBall
@onready var goal_text = $GoalText
@onready var celebration_timer = $CelebrationTimer

var is_reloading: bool = false

var current_goal: int = 0
var current_count: int = -1
var ball_scene = preload("res://TinyBalls.tscn")
var current_ball
var previous_ball

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	current_goal = LevelInfo.get_ball_goals()
	goal_text.text = "[font_size=36][color=white]Balls:" + str(current_goal - 1) + "[/color][/font_size]"
	
	center_ball.set_text(str(LevelInfo.level_number))
	
	current_ball = ball_scene.instantiate()
	current_ball.pulsing = true
	current_ball.lose.connect(game_over)
	
	var bad_balls = LevelInfo.get_bad_balls()
	
	for n in bad_balls.size():
		set_enemy_by_degrees(bad_balls[n])
	
	add_child(current_ball)
	
	current_count = 1
	previous_ball = current_ball
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_count >= current_goal and previous_ball.rotating == true:
		win()
	pass
	
func _input(event):
	if event.is_action_pressed("ui_accept") and not is_reloading:
		
		current_ball.drop()
		previous_ball = current_ball
		previous_ball.pulsing = false
		current_ball = ball_scene.instantiate()
		current_ball.pulsing = true
		current_ball.lose.connect(game_over)
		add_child(current_ball)
		current_count += 1
		goal_text.text = "[font_size=36][color=white]Balls:" + str(current_goal - current_count) + "[/color][/font_size]"
		print("count: ", current_count)
		print("goal: ", current_goal)

func setup_level(ball_goals: int, bad_balls: int, level_number: int):
	current_goal = ball_goals
	for n in bad_balls:
		random_enemy()
	center_ball.set_text(str(level_number))
	pass

func random_enemy():
	var enemy_ball
	enemy_ball = ball_scene.instantiate()
	enemy_ball.start_pos = enemy_ball.end_pos
	enemy_ball.rotation = randf_range(0., 2 * PI)
	enemy_ball.rotating = true
	add_child(enemy_ball)
	
func set_enemy_by_degrees(degrees: float):
	var enemy_ball
	enemy_ball = ball_scene.instantiate()
	enemy_ball.start_pos = enemy_ball.end_pos
	enemy_ball.rotation = degrees * PI / 180
	enemy_ball.rotating = true
	add_child(enemy_ball)
	#enemy_ball.sparkle_on()
	

func game_over():
	if not is_reloading: # prevent multple calls which can cause errors
		is_reloading = true
		call_deferred("reload_scene") # defer to prevent errors trying to unload during physics step

func reload_scene():
		get_tree().reload_current_scene()

	
func win():
	if not is_reloading: # prevent multiple calls which can cause errors
		is_reloading = true
		print("you win")
		get_tree().call_group("tiny_balls", "sparkle_on") # Trigger the sparkle effects
		
		# Timer calls advance_level when done via timeout signal
		celebration_timer.start()
		
func advance_level():
	LevelInfo.incrementLevel()
	if LevelInfo.level_number < LevelInfo.num_levels() + 1:
		call_deferred("reload_scene") 
	else:
		print("you beat the game")
		LevelInfo.level_number = 1
		call_deferred("reload_scene") 
