extends Button

@onready var scale_up: AnimationPlayer = $Scale_up

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	scale_up.play("scale_up")


func _on_mouse_exited() -> void:
	scale_up.play_backwards("scale_up")
