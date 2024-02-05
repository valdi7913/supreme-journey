extends RigidBody2D

@export var MAX_JUMP_FORCE : float = 10000
@export var MAX_JUMP_CHARGE_TIME : float = 2
var EPSILON : float = 40
var jump_angle : float = 180
@export var angle_diff : float = 30
var is_airborne : bool = true 

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	pass

func _process(delta):
	_handle_input()
	_handle_animation()

func _on_body_entered(body):
	is_airborne = false
	
func deg_to_rad(deg : float):
	return PI/180 * deg 

func _handle_input():
	if Input.is_action_just_pressed("reset"):
		position = Vector2(400,400)
		rotation = 0
	if Input.is_action_just_pressed("jump") and !is_airborne:
		$JumpChargeBar/AnimatedSprite2D.play()
		$JumpTimer.stop()
		$JumpTimer.start(MAX_JUMP_CHARGE_TIME)
		print("Time to max jump ", MAX_JUMP_CHARGE_TIME)	
	if Input.is_action_just_released("jump") and !is_airborne:
		jump()


func _handle_animation():	
	if (linear_velocity.x < -EPSILON) or Input.is_action_pressed("move_left") :
		$AnimatedSprite2D.play("default_left")
	elif linear_velocity.x > EPSILON or Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.play("default_right")

func jump():
	print("Time left", $JumpTimer.time_left)
	$JumpChargeBar/AnimatedSprite2D.stop()
	var jump_power = (MAX_JUMP_CHARGE_TIME - $JumpTimer.time_left)/ MAX_JUMP_CHARGE_TIME
	jump_power = clamp(jump_power, 0, 1)
	print("jump power ", jump_power * 100, " %")
	var jump_direction = Vector2(0,-1).normalized() * jump_power * 100000
	if Input.is_action_pressed("move_left"):
		jump_direction = jump_direction.rotated(deg_to_rad(-angle_diff))
	if Input.is_action_pressed("move_right"):
		jump_direction = jump_direction.rotated(deg_to_rad(angle_diff))	
	print(jump_direction)
	apply_force(jump_direction,center_of_mass)
	#is_airborne = true
