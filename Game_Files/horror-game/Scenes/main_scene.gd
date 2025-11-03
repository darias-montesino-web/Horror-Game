extends Node2D

@export var enemy: PackedScene

@onready var spawner1 = $Marker2D

func _on_timer_timeout() -> void:
	var ene = enemy.instantiate()
	ene.global_position = spawner1.global_position
	add_child(ene)
	$Timer.start()
	
