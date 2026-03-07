extends Control

var world : PackedScene
@onready var animator: AnimationPlayer = %Animator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.play("entry")
	world = load("res://world/world.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	animator.play("exit")
	await animator.animation_finished
	get_tree().call_deferred("change_scene_to_packed", world)


func _on_exit_pressed() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.location.href = 'exit.html';")
	else:
		get_tree().quit()
