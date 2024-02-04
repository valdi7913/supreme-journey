extends RigidBody2D

@export var speed : float = 400 # How fast the player will move (pixels/sec).
@export var jump_force : float = 3000000
var EPSILON : float = 40
var jump_angle : float = 180
var angle_diff : float = 30
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
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.flip_h = false
	
	if Input.is_action_just_pressed("jump") and !is_airborne:
		var jump_direction = Vector2(0,-1).normalized() * jump_force
		if Input.is_action_pressed("move_left"):
			jump_direction = jump_direction.rotated(deg_to_rad(-angle_diff))
		if Input.is_action_pressed("move_right"):
			jump_direction = jump_direction.rotated(deg_to_rad(angle_diff))	
		print(jump_direction)
		apply_force(jump_direction,center_of_mass)
		is_airborne = true


func _handle_animation():
	if linear_velocity.x < -EPSILON:
		$AnimatedSprite2D.flip_h = true
	elif linear_velocity.x > EPSILON:
		$AnimatedSprite2D.flip_h = false
