extends Control

onready var vars = get_node("/root/Global")

func _ready():
	#play title screen music
	if get_node("/root/MusicTitle").playing == false:
		get_node("/root/MusicTitle").play()
	#set these values back to default when the player is on the title screen
	vars.score = 0
	vars.lives = 3
	vars.moves = 3
#esc = quit game
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()
#button press functions
func _on_Leaderboard_pressed():
	get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")
func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Other/SinglevsMulti.tscn")
func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
func _on_Quit_pressed():
	get_tree().quit()
func _on_Instructions_pressed():
	get_tree().change_scene("res://Scenes/Other/Instructions.tscn")
func _on_Credits_pressed():
	get_tree().change_scene("res://Scenes/Other/Credits.tscn")
