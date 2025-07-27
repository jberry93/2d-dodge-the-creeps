extends Node

@export var mob_scene: PackedScene
var score

func game_over() -> void:
	$Music.stop()
	$DeathSound.play()

	$HUD.show_game_over()
	$ScoreTimer.stop()
	$MobTimer.stop()

func new_game() -> void:
	$Music.play()
	# Remove all queues in group "mobs" (get rid of all existing mobs)
	get_tree().call_group("mobs", "queue_free")

	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_mob_timer_timeout() -> void:
	var mob: RigidBody2D = mob_scene.instantiate()
	var mob_spawn_location: Variant = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
