extends CharacterBody2D

@onready var sprite:= $Sprite2D

const GRAVITY = 200.0
const MAX_KICK_SPEED := 200.0
const BASE_SPEED := 120.0
const MAX_JUMP_SPEED := 140.0
const JUMP_SPEED := MAX_JUMP_SPEED *2
const KICK_SPEED := MAX_KICK_SPEED *2
const GROUND_FRICTION := .03
const AIR_FRICTION := .2
const LERP_THRESHOLD := 1
const KICK_THRESHOLD = 0
const ROTATION_SPEED := 500.0

var dir :Vector2 = Vector2.ZERO
var friction := 0.0
var accelerating:= false
var old_velocity := Vector2.ZERO
var in_air := true
var rotation_offset := 0.0
var kick_power:=0.0
var jump_power := 0.0

func _ready() -> void:
	friction = GROUND_FRICTION
	old_velocity = velocity


func _physics_process(delta: float) -> void:
	accelerating = abs(old_velocity.x) < abs(velocity.x)
	old_velocity = velocity
	print(rotation_offset,jump_power)
	velocity.y += delta * GRAVITY
	in_air = not is_on_floor()
	if not in_air:
		rotation_offset = 0
	if Input.is_action_pressed("right") and in_air:
		rotation_offset += ROTATION_SPEED * delta 
		sprite.rotation_degrees = rotation_offset
		pass

	if Input.is_action_pressed("left") and in_air:
		rotation_offset -= ROTATION_SPEED * delta 
		sprite.rotation_degrees = rotation_offset
		pass


	if Input.is_action_pressed('right') and not in_air:
		kick_power = min(kick_power + (KICK_SPEED * delta),MAX_KICK_SPEED)	

	if Input.is_action_just_released("right") and not in_air:
		kick(kick_power)

	if Input.is_action_pressed('up') and not in_air:
		jump_power = min(jump_power + (JUMP_SPEED * delta),MAX_JUMP_SPEED)

	if Input.is_action_just_released('up') and not in_air:
		jump()

	if Input.is_action_pressed('up') == false:
		jump_power = 0

	velocity.x = lerp(velocity.x,BASE_SPEED,friction)
	#if abs(velocity.x) < BASE_SPEED: 
		#velocity.x = BASE_SPEED

	move_and_slide()

func kick(kick_speed) -> void:
	velocity.x += kick_speed

func jump() -> void:
	velocity.y += -jump_power