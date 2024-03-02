extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if $AnimatedSprite2D.is_playing() and $AnimatedSprite2D.get_frame_progress() > 0.9:
		$AnimatedSprite2D.stop()
	else:
		$AnimatedSprite2D.play()
