extends Node2D

@onready var rich_text_label = $RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_text(text: String):
	text = "[font_size=36][color=black]" + text + "[/color][/font_size]"
	rich_text_label.clear()
	rich_text_label.append_text(text)
