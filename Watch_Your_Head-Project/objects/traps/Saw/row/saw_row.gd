extends Node2D

var speed = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func delete_saw(saw_num:int):
	for saw in range(8):
		get_child(saw).speed = speed
		if saw_num - 1 == saw:
			get_child(saw).queue_free()
		
