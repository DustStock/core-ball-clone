extends Node2D

@onready var ball = $Ball
@onready var area_2d = $Ball/Area2D
@onready var sparkles = $Ball/Sparkles

@export var start_pos: Vector2 = Vector2(0, 250)
@export var end_pos: Vector2 = Vector2(0, 100)
@export var drop_speed: float = 2000
@export var rotation_speed: float = 4

@export var pulse_frequency: float = 4
@export var pulse_min: float = 0.5
@export var pulse_max: float = 2.0

@export var live_distance: float = 100

signal lose

var dropping: bool = false
var rotating: bool = false
var pulsing: bool = false
var pulseTime: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("tiny_balls")
	ball.position = start_pos
	area_2d.monitoring = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if dropping:
		var movement: Vector2
		var difference: Vector2
		
		difference = end_pos - ball.position
		movement = difference.normalized() * drop_speed * delta
		
		if movement.length() > difference.length():
			movement = difference
			dropping = false
			rotating = true
			
		ball.position += movement
		
		if (start_pos - ball.position).length() >= live_distance:
			print("I'm alive")
			start_monitoring()
		return
	
	if rotating:
		rotation += rotation_speed * delta
	
	if pulsing:
		pulseTime += delta
		var scale_factor = (cos(pulseTime * pulse_frequency) + 1) / 2  * (pulse_max - pulse_min) + pulse_min
		var scale2D = Vector2(scale_factor, scale_factor)
		ball.global_scale = (scale2D)
		
		
func drop():
	dropping = true
	pulsing = false
	
func lost(_area: Area2D):
	lose.emit()
	#print("you lose")

func start_monitoring():
	area_2d.monitoring = true
	
func sparkle_on():
	if sparkles:
		sparkles.emitting = true
	
func sparkle_off():
	if sparkles:
		sparkles.emitting = false
