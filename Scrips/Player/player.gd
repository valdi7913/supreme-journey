extends RigidBody2D

@export var MAX_JUMP_FORCE : float = 20000
@export var MAX_JUMP_CHARGE_TIME : float = 2
var EPSILON : float = 40
var is_airborne : bool = true 
var speed: float = 10
var jump_charge_start = 0;
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
		print("Charging")
		jump_charge_start = Time.get_ticks_msec()
	if Input.is_action_just_released("jump") and !is_airborne:
		var elapsed_time_in_seconds = (Time.get_ticks_msec() - jump_charge_start)/1000.0
		jump_charge_start = 0;
		print("Released! Charged for a total of ", elapsed_time_in_seconds, " sec")
		jump(elapsed_time_in_seconds)
	if Input.is_action_pressed("move_left"):
		apply_impulse(Vector2(-speed,0))
	if Input.is_action_pressed("move_right"):
		apply_impulse(Vector2(speed,0))
		
func _handle_animation():	
	if (linear_velocity.x < -EPSILON) or Input.is_action_pressed("move_left") :
		$AnimatedSprite2D.play("default_left")
	elif linear_velocity.x > EPSILON or Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.play("default_right")
	
	if jump_charge_start != 0:
		var elapsed_time_in_seconds = (Time.get_ticks_msec() - jump_charge_start)/1000.0
		var ratio_of_max_charge_time = (elapsed_time_in_seconds/MAX_JUMP_CHARGE_TIME)
		$JumpChargeBar.set_charge_progress(ratio_of_max_charge_time)
	else:
		$JumpChargeBar.set_charge_progress(0)
	#Jump charge bar

func jump(charge_time):
	mouse_position = get_global_mouse_position()
	var ratio_of_max_charge_time = charge_time/MAX_JUMP_CHARGE_TIME
	print("Ratio of max charge time ", ratio_of_max_charge_time)
	var jump_power = clamp(ratio_of_max_charge_time, 0, 1)
	print("Clamped ratio of max charge time ", jump_power)
	var jump_direction = (mouse_position - position).normalized() * jump_power * MAX_JUMP_FORCE
	set_axis_velocity(jump_direction)
	#is_airborne = true
