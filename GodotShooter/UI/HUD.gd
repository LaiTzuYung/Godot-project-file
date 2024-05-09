extends CanvasLayer

signal start_game
signal win_game

var time = 0

func _ready():
	var startbutton = get_node("StartButton")
	var time = get_node("Timer")
	startbutton.pressed.connect(_on_start_button_pressed)
	time.timeout.connect(_on_timer_timeout)
	$Message.text = "SURVIVE"
	
func _on_start_button_pressed():
	$Hero.stop()
	$Start.play()
	$Music.play()
	time = 0
	$TimeLabel.text = str(90-time)
	$Timer.start()
	$StartButton.hide()
	$Message.hide()
	start_game.emit()
	
func _on_timer_timeout():
	time += 1
	update_score(time)

func show_game_win():
	$Timer.stop()
	$Message.text = "You Survived"
	$Message.show()
	await get_tree().create_timer(3.0).timeout
	$Message.text = "SURVIVE"
	$Message.show()
	$StartButton.show()

func show_game_over():
	$Hero.stop()
	$Timer.stop()
	$Message.text = "Game Over"
	$Message.show()
	await get_tree().create_timer(3.0).timeout
	$Message.text = "SURVIVE"
	$Message.show()
	$StartButton.show()
	
func update_score(time):
	$TimeLabel.text = str(90-time)
	if((90 - time) == 0):
		win_game.emit()
	if((time) == 60):
		$Music.stop()
		$Hero.play()
		
