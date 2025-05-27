extends Node2D

@onready var countdown_timer = $CountdownTimer
@onready var countdown_label = $CanvasLayer/CountDownLabel
@onready var victory_timer = $VictoryTimer
@onready var victory_screen = $CanvasLayer/VictoryScreen

var time_left := 45

func _ready():
	update_timer_label()
	$CanvasLayer/CountDownLabel.text = "TESTING"
	print("HELLEKHKLSFHKLSDHF")
	if countdown_label:
		countdown_label.text = "Time Left: %s" % time_left
	else:
		print("NOT FOUND")
	#victory_timer.start()
	#countdown_timer.start()
	
func _process(_delta):
	update_timer_label()

func update_timer_label():
	countdown_label.text = "Time Left: %s" % time_left

func _on_countdown_timer_timeout():
	time_left -= 1
	countdown_label.text = "Time Left: %s" % time_left
	
	if time_left <= 0:
		victory_screen.visible = true



func _on_victory_timer_timeout():
	victory_screen.visible = true
