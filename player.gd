extends Area2D
signal hit # Use to detect enemy collision

@export var speed: int = 400 # How fast the player will move (pixels/second)
var screen_size: Vector2 # Size of the game window

# Called when the node enters the scene tree
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

# Called every frame
func _process(delta: float) -> void:
	# 1) Check for input.
	# 2) Move in the given direction.
	# 3) Play the appropriate animation.

	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	# Keep the player's position within bounds
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	# Show animation frame based on direction
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(_body) -> void:
	hide() # Player disappears after hit
	hit.emit()
	# Must be deferred as we cannot change physics properties on a physics callback
	$CollisionShape2D.set_deferred("disabled", true)

# When starting a new game, reset the player's position
func start(pos) -> void:
	position = pos
	show()
	$CollisionShape2D.disabled = false
