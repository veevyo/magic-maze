extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var event = load("res://global.gd").new()
# Called when the node enters the scene tree for the first time.
#set text
func _ready():
	event.lives = self.event.lives
	self.set_text(str(event.lives))
