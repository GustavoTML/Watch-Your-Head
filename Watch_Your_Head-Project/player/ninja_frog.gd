extends CharacterBody2D

@onready var camera = get_node("/root/World/Camera")
@onready var anim: AnimatedSprite2D = %Anim
@onready var jump_sfx: AudioStreamPlayer2D = %Jump
@onready var hit_anim: AnimationPlayer = %Hit_Anim
@onready var hit_sound: AudioStreamPlayer2D = %Hit
@onready var knockback_cd: Timer = %knockback_CD
@onready var invulnerability_cd: Timer = %Invulnerability_CD
@onready var hit_particles: CPUParticles2D = %Hit_Particles

var speed:float = 300.0
var jump_force:float= -450.0
var life:int = 3

var can_move:bool = true
var invulnerable:bool = false

func _ready() -> void:
	hit_anim.play("RESET")


func _physics_process(delta: float) -> void:
	# BLOQUEIA O CAN_MOVE SE MORREU
	if life <= 0:
		can_move = false
	
	# GRAVIDADE
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2
	
	# JUMP
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		jump_sfx.play()
		jump()
	
	# ANIMAÇAO DE JUMP/FALL
	if velocity.y < 0 and life > 0:
		anim.play("jump")
	elif velocity.y > 0 and life > 0:
		anim.play("fall")
	
	# MOVEs
	# WALK / IDLE ANIMATIONS
	var direction = Input.get_axis("LEFT", "RIGHT")
	if Globals.mobile_controls:
		direction = Globals.mobile_dir
	if direction and can_move:
		if is_on_floor():
			anim.play("run")
		if direction > 0:
			anim.scale.x = 1
		elif direction < 0:
			anim.scale.x = -1
		velocity.x = direction * speed
	elif can_move:
		if is_on_floor():
			anim.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed - 250)
	
	move_and_slide()


# TOMA DANO
# ATIVA A TELA DE GAMEOVER / ANIMAÇÂO DE MORTE
func take_damage(dam:int = 1):
	set_collision_layer_value(2, false)
	invulnerability_cd.start(1)
	life -= dam
	if Globals.dificulty < 5:
		Engine.time_scale = 0.2
	hit_sound.play()
	hit_anim.play("hit")
	camerashake(30)
	# ATIVA A TELA DE GAMEOVER / ANIMAÇÂO DE MORTE
	if life <= 0:
		print(int(Globals.score))
		anim.play("hurt")
		$Collision.queue_free()
		get_parent().die()


# PULO
func jump(force:float = -450):
	velocity.y = force


# KNOCKBACK
func knockback(source_position:Vector2, force:float):
	
	can_move = false
	knockback_cd.start(0.1)
	if source_position.x > global_position.x:
		velocity.x = -1 * force / 2
		anim.scale.x = 1
		hit_particles.direction.x = -1
	else:
		velocity.x = 1 * force
		anim.scale.x = -1
		hit_particles.direction.x = 1
	jump(-350)
	hit_particles.emitting = true
func _on_knockback_cd_timeout() -> void:
	if life > 0:
		can_move = true


# TREME A CAMERA
func camerashake(intensity = 10):
	camera.camerashake(intensity)


func _on_invulnerability_cd_timeout() -> void:
	set_collision_layer_value(2, true)
