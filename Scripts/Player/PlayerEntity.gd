class_name PlayerEntity
extends Entity

@onready var sprite_2d : Sprite2D = $Sprite2D

@export var min_jump_velocity : float = 150.0
@export var max_jump_velocity : float = 300.0
@export var charge_jump_time : float = 1.0
@export var jump_forgiveness : float = 0.2

var direction : float = 0.0
var jump_buffer_count : int = 1
var is_prepare_jump : bool = false
var is_jumping : bool = false
var elapsed_charge_jump_time : float = 0.0
var elapsed_jump_time : float = jump_forgiveness
var jump_velocity : float = 0.0
var ungrounded_time : float = 0.0
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

signal on_dead

const DIE_PARTICLE = preload("res://Particles/DieParticle.tscn")

func _ready() -> void:
	set_alive()

func set_alive() -> void:
	set_collision_layer_value(2, true)
	is_dead = false
	visible = true

func set_die() -> void:
	set_collision_layer_value(2, false)
	is_dead = true
	visible = false
	
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
		jump_buffer_count += 1
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
	
	var can_jump = ungrounded_time <= jump_forgiveness and elapsed_jump_time <= jump_forgiveness and !is_prepare_jump
	if can_jump and jump_buffer_count > 0:
		if !is_jumping:
			velocity.y = -jump_velocity
			if (jump_velocity > max_jump_velocity * .8):
				AudioManager.play_sfx_with_custom_pitch("jump", 1)
			else:
				AudioManager.play_sfx_with_custom_pitch("jump", .95)
			jump_buffer_count -= 1
			is_jumping = true
		else:
			jump_buffer_count -= 1
		
	# Handle Movement
	direction = clamp(Input.get_axis("ui_left", "ui_right"), -1, 1)
	velocity.x = direction * speed
	move_and_slide()

func handle_facing() -> void:
	if direction > 0:
		set_facing_right(true)
	elif direction < 0:
		set_facing_right(false)

func set_facing_right(is_facing_right : bool) -> void:
	sprite_2d.scale.x = 1 if is_facing_right else -1

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
		AudioManager.play_sfx("fall")
	if (death_type == Global.DeathType.HIT):
		var die_particle = DIE_PARTICLE.instantiate()
		get_tree().current_scene.add_child(die_particle)
		die_particle.position = position
		die_particle.emitting = true
		AudioManager.play_sfx("hit")
	
	set_die()
	emit_signal("on_dead")
