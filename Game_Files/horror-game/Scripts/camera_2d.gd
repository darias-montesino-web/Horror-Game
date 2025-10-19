extends Camera2D

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		global_position += Vector2(-10,0)
	if Input.is_action_pressed("right"):
		global_position += Vector2(10,0)
