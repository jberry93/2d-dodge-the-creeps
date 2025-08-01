extends RigidBody2D
signal screen_exited

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types: Array = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Free/delete the node at the end of the frame
