extends Node2D

var last_bgm_time := 0.0
var reset_scene_delay := 1.0
var death_count := 0
var score := 0

enum DeathType { FALL, HIT }
