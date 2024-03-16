extends RigidBody2D

@export var MAX_JUMP_FORCE : float = 20000
@export var MAX_JUMP_CHARGE_TIME : float = 2
var EPSILON : float = 40
var jump_angle : float = 180
@export var angle_diff : float = 30
var is_airborne : bool = true 
var speed: float = 10

var mouse_position = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")

func _process(delta):
	_handle_input(delta)
	_handle_animation()

func _on_body_entered(body):
	is_airborne = false
	
func deg_to_rad(deg : float):
	return PI/180 * deg 

func _handle_input(delta):
	if Input.is_action_just_pressed("reset"):
		position = Vector2(400,400)
		rotation = 0
	if Input.is_action_just_pressed("jump") and !is_airborne:
		$JumpChargeBar/AnimatedSprite2D.play()
		$JumpTimer.stop()
		$JumpTimer.start(MAX_JUMP_CHARGE_TIME)
	if Input.is_action_just_released("jump") and !is_airborne:
		jump()
	if Input.is_action_pressed("move_left"):
		apply_impulse(Vector2(-speed,0))
	if Input.is_action_pressed("move_right"):
		apply_impulse(Vector2(speed,0))
		
func _handle_animation():	
	if (linear_velocity.x < -EPSILON) or Input.is_action_pressed("move_left") :
		$AnimatedSprite2D.play("default_left")
	elif linear_velocity.x > EPSILON or Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.play("default_right")

func jump():
	mouse_position = get_global_mouse_position()
	$JumpChargeBar/AnimatedSprite2D.stop()
	var jump_power = clamp((MAX_JUMP_CHARGE_TIME - $JumpTimer.time_left)/ MAX_JUMP_CHARGE_TIME,0 ,1)
	var jump_direction = (mouse_position - position).normalized() * jump_power * MAX_JUMP_FORCE
	set_axis_velocity(jump_direction)
	#is_airborne = true
