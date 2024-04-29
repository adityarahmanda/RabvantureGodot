class_name PlayerEntity
extends Entity

@onready var audio_manager : AudioManager = %Services/AudioManager
@onready var sprite_2d : Sprite2D = $Sprite2D

@export var min_jump_velocity := 150.0
@export var max_jump_velocity := 300.0
@export var charge_jump_time := 1.0
@export var jump_forgiveness := 0.2
@export var spawn_transform : Node2D

var spawn_position : Vector2
var direction := 0.0
var is_prepare_jump := false
var is_jumping := false
var elapsed_charge_jump_time := 0.0
var elapsed_jump_time := jump_forgiveness
var jump_velocity := 0.0
var ungrounded_time := 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal on_dead

const DIE_PARTICLE = preload("res://Particles/DieParticle.tscn")

func _ready() -> void:
	cache_spawn_position()
	respawn()

func cache_spawn_position() -> void:
	if (spawn_transform != null):
		spawn_position = spawn_transform.global_position
	else:
		spawn_position = global_position

func respawn() -> void:
	global_position = spawn_position
	visible = true
	is_dead = false
	
func on_physics_process(delta) -> void:
	handle_movement(delta)
	handle_facing()
	handle_collision()
	handle_fall_into_pit()

func handle_movement(delta) -> void:
	if Input.is_action_just_pressed("ui_select"):
		elapsed_charge_jump_time = 0
		jump_velocity = min_jump_velocity
		is_prepare_jump = true
	if Input.is_action_just_released("ui_select"):
		is_prepare_jump = false
	
	if is_prepare_jump:
		jump_velocity = lerp(jump_velocity, max_jump_velocity, elapsed_charge_jump_time / charge_jump_time)
		jump_velocity = clamp(jump_velocity, min_jump_velocity, max_jump_velocity)
		elapsed_charge_jump_time += delta
		elapsed_jump_time = 0
	else:
		elapsed_jump_time += delta
	
	if is_on_floor():
		ungrounded_time = 0
		is_jumping = false
	else:
		ungrounded_time += delta
		velocity.y += gravity * delta
		
	if ungrounded_time > jump_forgiveness:
		jump_velocity = min_jump_velocity
	
	if ungrounded_time <= jump_forgiveness and elapsed_jump_time <= jump_forgiveness and !is_jumping and !is_prepare_jump:
		velocity.y = -jump_velocity
		is_jumping = true
		audio_manager.play_sfx("jump")
		
	# Handle Movement
	direction = clamp(Input.get_axis("ui_left", "ui_right"), -1, 1)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func handle_facing() -> void:
	if direction > 0:
		sprite_2d.scale.x = 1
	elif direction < 0:
		sprite_2d.scale.x = -1

func handle_collision() -> void:
	var collision_count = get_slide_collision_count()
	for index in collision_count:
		var collision = get_slide_collision(index)
		if (collision.get_collider().is_in_group("Obstacle")):
			die(Global.DeathType.HIT)

func handle_fall_into_pit() -> void:
	if position.y > game_manager.level_setup.pit_y_level:
		die(Global.DeathType.FALL)

func die(death_type : Global.DeathType) -> void:
	if (is_dead): return
	
	if (death_type == Global.DeathType.FALL):
		audio_manager.play_sfx("fall")
	if (death_type == Global.DeathType.HIT):
		var die_particle = DIE_PARTICLE.instantiate()
		get_tree().current_scene.add_child(die_particle)
		die_particle.position = position
		die_particle.emitting = true
		audio_manager.play_sfx("hit")
	
	visible = false
	is_dead = true
	emit_signal("on_dead")
