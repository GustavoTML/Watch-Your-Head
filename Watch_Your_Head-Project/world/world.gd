extends Node2D


const SAW = preload("res://objects/traps/Saw/saw.tscn")
const SAW_ROW = preload("res://objects/traps/Saw/row/saw_row.tscn")
const SAW_STAIR = preload("res://objects/traps/Saw/stair/saw_stair.tscn")


@onready var mobile_controls: Control = $HUD/Mobile_Controls

@onready var final_music: AudioStreamPlayer2D = $Audios/Final_Music

# ANIMATIONS NODES
@onready var world_anim: AnimationPlayer = %World_Anim
@onready var gameover: Control = %Gameover


# CONTROL NODES
@onready var score_txt: Label = %Score

# TIMER NODES
@onready var saw_spawn: Timer = %Saw_Spawn
@onready var gameover_wait: Timer = %Gameover_Wait
@onready var saw_row_spawn: Timer = %Saw_Row_Spawn

# CORES DO BACKGROUND
@onready var green: TileMapLayer = %BG_Green
@onready var pink: TileMapLayer = %BG_Pink
@onready var gray: TileMapLayer = %BG_Gray
@onready var brown: TileMapLayer = %BG_Brown
@onready var blue: TileMapLayer = %BG_Blue
@onready var yellow: TileMapLayer = %BG_Yellow
@onready var purple: TileMapLayer = %BG_Purple

var final_is_playing:bool = false

# FALSE PARA NÂO INICIAR AS SAWS
@export var play:bool = true

# DIFICULDADEs (0 para testes)
var dificulty:int = 1

# spawn CD
var spawn_cd:float = 1

# DEFININDO ALEATORIAMENTE A COR DO BACKGROUND
var bg_color = randi_range(1, 6)
var color:String

func _ready() -> void:
	
	var platform = OS.get_name()
	if platform == "Android" or platform == "iOS":
		print("🎮 Dispositivo mobile detectado!")
		Globals.mobile_controls = true
	else:
		Globals.mobile_controls = false
	
	Globals.score = 0
	world_anim.play("entry")
	# INICIANDO O TIMER DE SPAWNS DE SAWS
	# saw_row_spawn.start(2)
	if play:
		saw_spawn.start(2)
	# COLOCANDO A COR DO BG
	match bg_color:
		1:
			green.visible = true
		2:
			pink.visible = true
		3:
			gray.visible = true
		4:
			brown.visible = true
		5:
			blue.visible = true
		6:
			yellow.visible = true
		7:
			purple.visible = true


func _process(delta: float) -> void:
	
	
	
	Globals.score_up(10 * delta)
	upd_score()
	
	# A MUSICA ACABA EM 5000!!!
	# GERENCIANDO DIFICULDADES
	if Globals.score < 300:
		dificulty = 1
	elif Globals.score < 750:
		dificulty = 2
	elif Globals.score < 1100:
		dificulty = 3
	elif Globals.score < 5000:
		dificulty = 4
	elif Globals.score < 7000:
		Globals.dificulty = 5
		dificulty = 5
		if !final_is_playing:
			final_is_playing = true
			$Audios/Music_Default.playing = false
			final_music.playing = true
	elif Globals.score < 9000:
		dificulty = 6
	elif Globals.score < 9150:
		dificulty = 0
		saw_tipe = 0
	elif Globals.score < 11300:
		dificulty = 7
	elif Globals.score < 11600:
		dificulty = 8
	elif Globals.score < 12000:
		dificulty = 9
	elif Globals.score < 12150:
		dificulty = 0
		saw_tipe = 0
	elif Globals.score < 14000:
		dificulty = 10
	elif Globals.score < 16000:
		dificulty = 11


func die():
	gameover_wait.start(1.5)
func _on_gameover_wait_timeout() -> void:
	gameover.gameover()


# SPAWN DE SAWS POR DIFICULDADE
func _on_saw_spawn_timeout() -> void:
	# NÌVEIS DE DIFICULDADE
	match dificulty:
		1:
			create_saw()
			saw_spawn.start(randf_range(1, 1.5))
		2:
			create_saw()
			create_saw()
			saw_spawn.start(randf_range(1, 1.5))
		3:
			create_saw()
			create_saw()
			saw_spawn.start(randf_range(0.5, 1))
		4:
			create_saw()
			create_saw()
			create_saw()
			saw_spawn.start(randf_range(0.5, 1))
		5:
			saw_row_spawn.start(2)
# CRIA A SAW
func create_saw():
	var new_saw = SAW.instantiate()
	add_child(new_saw)
	new_saw.global_position = Vector2(randf_range(320, 960), -64)
	new_saw.set_scala = randf_range(1.5, 3.5)
	new_saw.speed = randf_range(250, 375)


var num:int = 0
var saw_tipe:int = 0

func _on_saw_row_spawn_timeout() -> void:
	
	if play:
		match dificulty:
			5:
				saw_tipe = 1
			6:
				saw_tipe = 2
			7:
				saw_tipe = 3
			8:
				saw_tipe = 4
			9:
				saw_tipe = 5
			10:
				saw_tipe = 6
			11:
				saw_tipe = 7
	match saw_tipe:
		1:
			spawn_cd = 0.5
			var sort = randi_range(1, 7)
			create_reverse_row([sort, sort + 1])
		2:
			num += 1
			spawn_cd = 0.6
			if num % 2 == 0:
				var sort = randi_range(1, 6)
				create_reverse_row([sort, sort + 1, sort + 2])
			else:
				var sort = randi_range(1, 7)
				create_reverse_row([sort, sort + 1])
		3:
			spawn_cd = 1.3
			var sort = randi_range(2, 6)
			create_saw_row([sort, sort + 1])
		4:
			spawn_cd = 0.85
			create_half_row()
		5:
			spawn_cd = 5.35
			create_saw_stair()
		6:
			spawn_cd = 0.8
			var sort = randi_range(2, 6)
			create_saw_row([sort, sort + 1])
		7:
			spawn_cd = 0.9
			var sort = randi_range(2, 6)
			create_saw_row([sort])
	saw_row_spawn.start(spawn_cd) 


# CRIA A SAW ROW / 1 PASSAGEM (quais saw vão ser DELETADOS)
# timer bom 1.5s (2 saws) / 1s (3 saws)
# configuração 2 saws randi_range(2, 6) timer 0.85s
# configuração 3 saws randi_range(2, 5) timer 0.5s
func create_saw_row(delete_saws:Array[int]):
	var new_saw = SAW_ROW.instantiate()
	add_child(new_saw)
	new_saw.global_position = Vector2(0, -84)
	if saw_tipe < 6:
		new_saw.speed = 500
	for row in delete_saws:
		new_saw.delete_saw(row)


# CRIA A SAW ROW / (quais saw vão FICAR)
# timer bom 0.8s (3 saws) / 0.5s (2 saws)
func create_reverse_row(add_saws:Array[int]):
	var new_saw = SAW_ROW.instantiate()
	add_child(new_saw)
	new_saw.global_position = Vector2(0, -84)
	for saw in range(9):
		if !add_saws.has(saw):
			new_saw.delete_saw(saw)


# CRIA A SAW ROW / 1 LADO FECHADO
func create_half_row(lado:int = 0):
	num += 1
	lado = num % 2
	var new_saw = SAW_ROW.instantiate()
	add_child(new_saw)
	new_saw.global_position = Vector2(0, -84)
	new_saw.speed = 650
	match lado:
		0:
			for row in range(4):
				new_saw.delete_saw(row + 1)
		1:
			for row in range(4):
				new_saw.delete_saw(row + 5)


func create_saw_stair():
	var new_saw = SAW_STAIR.instantiate()
	add_child(new_saw)
	new_saw.global_position = Vector2(0, -96)
	new_saw.speed = 300
	new_saw.update()


func set_saw_cd(tempo:float):
	spawn_cd = tempo


func upd_score():
	score_txt.text = "Pontuação: " + str(int(Globals.score))
