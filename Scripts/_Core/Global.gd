extends Node2D

var locale :String = String()
var reset_scene_delay := 1.0
var death_count := 0
var score := 0

enum DeathType { FALL, HIT }
