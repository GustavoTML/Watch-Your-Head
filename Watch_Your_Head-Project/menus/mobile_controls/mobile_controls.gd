extends Control

@onready var animator: AnimationPlayer = $Animator
@onready var left: Button = $Left
@onready var right: Button = $Right

func _ready() -> void:
	animator.play("entry")


func _process(delta: float) -> void:
	pass



func _on_left_button_down() -> void:
	Globals.mobile_dir = -1
	print("Left")


func _on_left_button_up() -> void:
	if Globals.mobile_dir == -1:
		Globals.mobile_dir = 0
		print("Left 0")


func _on_right_button_down() -> void:
	Globals.mobile_dir = 1
	print("Right")


func _on_right_button_up() -> void:
	if Globals.mobile_dir == 1:
		Globals.mobile_dir = 0
		print("Right 0")
