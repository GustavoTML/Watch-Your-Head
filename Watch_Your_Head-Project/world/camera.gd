extends Camera2D

var shakenoise: FastNoiseLite


func _ready() -> void:
	shakenoise = FastNoiseLite.new()


func _process(delta: float) -> void:
	pass


func camerashake(intensity):
	var camera_tween = create_tween()
	camera_tween.tween_method(shake, intensity, 1, 0.5)


func shake(intensity):
	var cameraoffset = shakenoise.get_noise_1d(Time.get_ticks_msec()) * intensity
	offset.x = cameraoffset
	offset.y = cameraoffset
