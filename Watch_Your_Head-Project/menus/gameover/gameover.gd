extends Control

@onready var animator: AnimationPlayer = %Animator
@onready var score: Label = %Score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score.text = "PONTUAÇÂO: " + str(int(Globals.score))


func gameover():
	animator.play("entry")
	get_tree().paused = true
	visible = true


func _on_restart_pressed() -> void:
	animator.play("reload")
	await animator.animation_finished
	get_tree().paused = false
	visible = false
	get_tree().call_deferred("reload_current_scene")


func _on_exit_pressed() -> void:
	animator.play("Exit")
	await animator.animation_finished
	get_tree().paused = false
	visible = false
	get_tree().call_deferred("change_scene_to_file", "res://menus/main_menu/main_menu.tscn")
