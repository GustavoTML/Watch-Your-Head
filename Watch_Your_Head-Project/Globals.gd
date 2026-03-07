extends Node

@export var score:float = 0
var dificulty:int = 0

var mobile_controls = true
var mobile_dir

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Engine.time_scale < 1:
		Engine.time_scale += 2 * delta
	if Input.is_action_just_pressed("FULLSCREEN"):
		fullscreen()


func score_up(quant:float):
	score += quant


func fullscreen():
	JavaScriptBridge.eval("""
		var canvas = document.getElementsByTagName('canvas')[0];
		if (document.fullscreenElement) {
			document.exitFullscreen();
		} else {
			if (canvas.requestFullscreen) {
				canvas.requestFullscreen();
			}
		}
	""")
