extends Node

@export var grass_tilemap : TileMap
@export var grass_material : ShaderMaterial

@onready var game_manager = $"/root/Game"

const GRASS_RESOURCE = preload("res://Components/Grass/GrassSprite2D.tscn")

func _ready() -> void:
	populate_grass_sprites()

func _process(_delta) -> void:
	grass_material.set_shader_parameter("player_pos", game_manager.player.global_position)

func populate_grass_sprites():
	for cell in grass_tilemap.get_used_cells(0):
		var grass_instance = GRASS_RESOURCE.instantiate()
		var world_pos = grass_tilemap.to_global(grass_tilemap.map_to_local(cell))
		grass_instance.position = world_pos
		add_child(grass_instance)
		var grass_sprite = grass_instance as Sprite2D
		grass_sprite.frame = randi_range(0, grass_sprite.hframes - 1)
	grass_tilemap.queue_free()
