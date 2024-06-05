extends CharacterBody2D

const EPSILON : float = 2;
var jump_charge_start = 0;
var facing = 1;

@export var MAX_JUMP_CHARGE_TIME : float;
@export var speed: float = 200;

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = (-2.0 * jump_height / jump_time_to_peak);
@onready var jump_gravity : float = (2.0 * jump_height / jump_time_to_peak / jump_time_to_peak);
@onready var fall_gravity : float = (2.0 * jump_height / jump_time_to_descent / jump_time_to_descent);

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	floor_stop_on_slope = false

func _on_Wall_body_entered(body):
	if not is_on_floor():
		# Flip the x velocity
		velocity.x = -velocity.x

func _physics_process(delta):
	if is_on_floor():
		velocity.x = 0
	if Input.is_action_pressed("shift"):
		print('shift is being pressed')
	if Input.is_action_just_pressed("jump") and is_on_floor():
		print("Charging")
		jump_charge_start = Time.get_ticks_msec()
	if Input.is_action_just_released("jump") and is_on_floor():
		var charge_time = (Time.get_ticks_msec() - jump_charge_start)/1000.0
		var charge_percentage = clamp(charge_time/MAX_JUMP_CHARGE_TIME, 0, 1);
		if Input.is_action_pressed("shift"):
			velocity.y = 0.75 * charge_percentage * jump_velocity;
			velocity.x = 10 * charge_percentage * speed * facing;
		else:
			velocity.y = charge_percentage * jump_velocity;
			velocity.x = 2 * charge_percentage * speed * facing;
		jump_charge_start = 0;
		print(charge_percentage)
		print(velocity)
	
	var direction = 0;
	if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
		direction = 0;
	elif Input.is_action_pressed("move_right"):
		facing = 1;
		direction = 1;
	elif Input.is_action_pressed("move_left"):
		facing = -1;
		direction = -1;
	
	if not is_on_floor():
		velocity.y += get_gravity() * delta
	
	if is_on_wall_only():
		velocity.x *= -1
	
	var is_charging = jump_charge_start != 0 and is_on_floor()
	if is_charging:
		velocity.x = 0
	elif is_on_floor() and direction:
		velocity.x = speed * direction
	move_and_slide()
	
func _process(delta):
	var is_charging = jump_charge_start != 0
	if is_charging:
		$AnimatedSprite2D.play("default")
		$JumpChargeBar.visible=true
		var elapsed_time_in_seconds = (Time.get_ticks_msec() - jump_charge_start)/1000.0
		var ratio_of_max_charge_time = (elapsed_time_in_seconds/MAX_JUMP_CHARGE_TIME)
		$JumpChargeBar.set_charge_progress(ratio_of_max_charge_time)
		return
		
	$JumpChargeBar.set_charge_progress(0)
	$JumpChargeBar.visible = false
	
	if not is_on_floor():
		$AnimatedSprite2D.play("default")
	
	if (velocity.x < -EPSILON):
		$AnimatedSprite2D.play("walking")
		$AnimatedSprite2D.flip_h = true
	elif (velocity.x > EPSILON):
		$AnimatedSprite2D.play("walking")
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("default")
