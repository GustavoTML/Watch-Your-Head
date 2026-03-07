extends Node2D

@export var can_fall:bool = true
@export var set_scala:float = 1.5
@export var speed:float = 300


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	scale.x = set_scala
	scale.y = set_scala
	if can_fall:
		global_position.y += speed * delta
	if global_position.y > 832:
		Globals.score_up(10)
		queue_free()


func _on_damage_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
	if body.has_method("knockback"):
		body.knockback(global_position, 800)
