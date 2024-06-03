extends Node2D

var NUM_FRAMES;
# Called when the node enters the scene tree for the first time.
func _ready():
	var sprite_frames = $AnimatedSprite2D.sprite_frames;
	var current_animation = $AnimatedSprite2D.animation;
	NUM_FRAMES = sprite_frames.get_frame_count(current_animation)

func set_charge_progress(progress: float):
	var index = int(progress * NUM_FRAMES) 
	index = min(NUM_FRAMES - 1, index)
	$AnimatedSprite2D.set_frame(index)
