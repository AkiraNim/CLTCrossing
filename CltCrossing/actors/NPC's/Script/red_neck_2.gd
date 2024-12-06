extends CharacterBody3D

signal dialog

@export var emotion: int

var rng = RandomNumberGenerator.new()
var emotion_verify: int

const RUN = 5.0
const WALK = 2.0
const JUMP_VELOCITY = 4.5
@onready var animation_player: AnimationPlayer = $RedNeck2/AnimationPlayer
@onready var player: CharacterBody3D = $"../../../Player"
@onready var path_follow_3d: PathFollow3D = $".."

#emotion = 0: cryingIdle
#emotion = 1: sitIdle
#emotion = 2: idleSad
#emotion = 3: idle
#emotion = 4: walkingIdle
#emotion = 5: runningIdle
func _ready() -> void:
	emotion_verify = emotion;

func _physics_process(delta: float) -> void:

	match emotion:
		0:
			animation_player.play("CryingIdle")
		1:
			animation_player.play("SitIdle")
		2:
			animation_player.play("IdleSad")
		3:
			animation_player.play("Idle")
		4:
			animation_player.play("Walk")
			path_follow_3d.progress += WALK * delta
		5:
			animation_player.play("Run")
			path_follow_3d.progress += RUN * delta
	
func player_interact() -> void:
	dialog.emit(self)
	emotion = rng.randf_range(1, 6)
	
