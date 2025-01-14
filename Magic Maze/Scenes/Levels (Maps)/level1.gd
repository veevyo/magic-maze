extends Node2D
const pickup = preload("res://Scenes/Other/Pickup.tscn")
onready var vars = get_node("/root/Global")
var loaded = load("res://global.gd")
var instanced = loaded.new()
onready var MusTitle = get_node("/root/MusicTitle")
#function for player losing moves
func check_mus_title():
	if get_node("/root/MusicTitle").playing:
		get_node("/root/MusicTitle").stop()
		get_node("/root/MusicTitle").seek(-1)
func _ready():
	check_mus_title()
	vars.moves = 1
	#set text in GUI
	$CanvasLayer/Control/Counter/Label.text = str(vars.moves)
	$CanvasLayer/Control/Counter/Label2.text = str(vars.lives)
	$CanvasLayer/Control/Counter/Label3.text = str(vars.score)
func kill():
	vars.moves = 0
	$CanvasLayer/Control/Counter/Label.text = str(vars.moves)
	#show popup
	get_node("CanvasLayer/Control/Counter/Popup").popup_centered()
#function for game over
func game_over():
	#show popup
	vars.moves = 0
	$CanvasLayer/Control/Counter/Label.text = str(vars.moves)
	get_node("CanvasLayer/Control/Counter/HighScore").popup_centered()
onready var tile = get_node("TileMap")
#function for getting title player clicked
func get_tile(mouse_pos):
	var cell_pos = tile.world_to_map(mouse_pos) 
	return cell_pos
#input function
func _input(event):
	#player click
	if event is InputEventMouseButton and event.is_pressed():
		var clicked = get_tile(event.position)
		#detect if tile is there
		if tile.get_cell(clicked.x, clicked.y) == 0:
			#delete tile
			$BreakSound.play()
			tile.set_cell(clicked.x, clicked.y, -1)
			#remove a move if tile is clicked
			vars.moves -= 1
			$CanvasLayer/Control/Counter/Label.text = str(vars.moves)
		#use kill() and game_over() functions
		if vars.moves < 0 and vars.lives != 0:
			kill()
			vars.lives -= 1
			if vars.lives <= 0:
				game_over()
			$CanvasLayer/Control/Counter/Label2.text = str(vars.lives)
	#game exit 
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()
	#tile highlighting
	else:
		var hover = get_tile(event.position)
		if tile.get_cell(hover.x, hover.y) == 0:
			$Follow.show()
		else:
			$Follow.hide()
#enter high score on game over
func _on_Button2_pressed():
	var name = $"CanvasLayer/Control/Counter/HighScore/NameEntry".text
	SilentWolf.Scores.persist_score(name, vars.score)
	SilentWolf.Scores.get_high_scores()
	$"CanvasLayer/Control/Counter/HighScore".hide()
	$"CanvasLayer/Control/Counter/Popup".hide()
	$"CanvasLayer/Control/Counter/Popup2".popup_centered()
#pause button
func _on_PauseButton_pressed():
	get_node("CanvasLayer/Control/Pause").popup_centered()
#decide what to do when things touch player
func _on_Area2D2_body_entered(body):
	if "Enemy" in body.name:
		vars.lives -= 1
		kill()
		$CanvasLayer/Control/Counter/Label2.text = str(vars.lives)
		if vars.lives <= 0:
			game_over()
		$CanvasLayer/Control/Counter/Label2.text = str(vars.lives)
	if "Pickup" in body.name:
		vars.score += 1
		vars.moves += 1
		$PickupSound.play()
		$CanvasLayer/Control/Counter/Label.text = str(vars.moves)
		$CanvasLayer/Control/Counter/Label3.text = str(vars.score)
		body.queue_free()
	if "Goal" in body.name:
		$BackgroundMusic.stop()
		$GoalSound.play()
		vars.score += vars.moves
		$CanvasLayer/Control/Counter/Label3.text = str(vars.score)
		$CanvasLayer/Control/GoalPopup.popup_centered()
#for level 5 only: save high score on last level
func _on_Button_pressed():
	var name = $"CanvasLayer/Control/GoalPopup/NameEntry".text
	SilentWolf.Scores.persist_score(name, vars.score)
	SilentWolf.Scores.get_high_scores()
	get_tree().change_scene("res://Scenes/Other/TitleScreen.tscn")
