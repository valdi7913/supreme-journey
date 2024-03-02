extends Camera2D

var player_node: RigidBody2D

var translateWaitTimer: float = 0
var waitTime: float = 0.1

func _ready():
	make_current()
	player_node = get_parent().get_node("Player")
	
func _process(delta):
	if(translateWaitTimer >= 0): translateWaitTimer -= delta
	var player_position: Vector2 = player_node.global_transform.origin
	var screen_center: Vector2 = get_screen_center_position()
	var viewport_rect: Vector2 = get_viewport_rect().size / zoom
	var right_boundary: Vector2 = (screen_center + viewport_rect / 2)
	var left_boundary: Vector2 = (screen_center - viewport_rect / 2)
	
	var distance_to_left: float = player_position.x - left_boundary.x
	var distance_to_right: float = right_boundary.x - player_position.x 
	var distance_to_top: float = player_position.y - left_boundary.y
	var distance_to_bottom: float = right_boundary.y - player_position.y 
	
	if(distance_to_left < 0 and translateWaitTimer < 0): 
		translate(Vector2(-viewport_rect.x,0))
		translateWaitTimer += waitTime
		
	if(distance_to_right < 0  and translateWaitTimer < 0): 
		translate(Vector2(viewport_rect.x,0))
		translateWaitTimer += waitTime
		
	if(distance_to_top < 0 and translateWaitTimer < 0): 
		translate(Vector2(0,-viewport_rect.y))
		translateWaitTimer += waitTime
		
	if(distance_to_bottom < 0  and translateWaitTimer < 0): 
		translate(Vector2(0,viewport_rect.y))
		translateWaitTimer += waitTime
