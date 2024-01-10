extends CharacterBody2D

@onready var sprite:= $Sprite2D

const GRAVITY = 200.0
const MAX_KICK_SPEED := 200.0
const BASE_SPEED := 120.0
const MAX_JUMP_SPEED := 140.0
const DJUMP_SPEED := Vector2(100,-150.0)
const JUMP_SPEED := MAX_JUMP_SPEED *2
const KICK_SPEED := MAX_KICK_SPEED *2
const GROUND_FRICTION := .03
const AIR_FRICTION := .2
const LERP_THRESHOLD := 1
const KICK_THRESHOLD = 0
const ROTATION_SPEED := 500.0

enum STATES {ON_GROUND,IN_AIR,KICKING}

var state 
var dir :Vector2 = Vector2.ZERO
var friction := 0.0
var accelerating:= false
var old_velocity := Vector2.ZERO
var rotation_offset := 0.0
var kick_power:=0.0
var jump_power := 0.0
var can_djump = false

func _ready() -> void:
	friction = GROUND_FRICTION
	state = STATES.ON_GROUND
	old_velocity = velocity


func _physics_process(delta: float) -> void:
	print(rotation_offset)
	match state:
		STATES.ON_GROUND:
			_state_on_ground(delta)
		STATES.IN_AIR:
			_state_in_air(delta)

func change_state(new_state:STATES):
	match state:
		STATES.ON_GROUND:
			pass
		STATES.IN_AIR:
			pass
	state = new_state


func kick(delta) -> void:
	if Input.is_action_pressed('right'):
		kick_power = min(kick_power + (KICK_SPEED * delta),MAX_KICK_SPEED)	

	if Input.is_action_just_released("right"):
		velocity.x += kick_power

func _state_on_ground(delta) -> void:
	move(delta)
	jump(delta)
	if not is_on_floor():
		change_state(STATES.IN_AIR)


func _state_in_air(delta) -> void:
	move(delta)
	double_jump()
	spin(delta)
	if is_on_floor():
		change_state(STATES.ON_GROUND)


func move(delta) -> void:
	velocity.x = lerp(velocity.x,BASE_SPEED,friction)
	velocity.y += delta * GRAVITY
	move_and_slide()

func jump(delta)->void:
	if Input.is_action_pressed('up') and is_on_floor():
		jump_power = min(jump_power + (JUMP_SPEED * delta),MAX_JUMP_SPEED)

	if Input.is_action_just_released('up') and is_on_floor():
		velocity.y += -jump_power

	if Input.is_action_pressed('up') == false:
		jump_power = 0

func double_jump() -> void:
	if rotation_offset >= 345:
		can_djump = true
	if Input.is_action_just_pressed('up') and can_djump:
		can_djump = false
		velocity += DJUMP_SPEED



func spin(delta) -> void:
	if is_on_floor():
		rotation_offset = 0
		sprite.rotation_degrees = 0
		can_djump = false
	if Input.is_action_pressed("right"):
		rotation_offset += ROTATION_SPEED * delta 
		sprite.rotation_degrees = rotation_offset

	if Input.is_action_pressed("left"):
		rotation_offset -= ROTATION_SPEED * delta 
		sprite.rotation_degrees = rotation_offset