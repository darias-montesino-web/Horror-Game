extends CharacterBody2D


@export var walk_speed = 250.0
@export var run_speed = 400
const JUMP_VELOCITY = -400.0

@export_range(0,1) var deceleration = 0.1
@export_range(0,1) var acceleration = 0.1

var speed
var run_type
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	# Handle jump -- not working idk why
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animated_sprite.play("Jump")
		
	if Input.is_action_pressed("run"):
		speed = run_speed
		
	else:
		speed = walk_speed
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	# Handle running
	if direction and not Input.is_action_pressed("jump") and Input.is_action_pressed("run") == true:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
		animated_sprite.play("Run")
		animated_sprite.flip_h = direction < 0
	
	# Handle walking
	else:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
		animated_sprite.play("Walk")
		animated_sprite.flip_h = direction < 0
	
	# Handle standing
	if !direction:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
		animated_sprite.flip_h = direction > 0
		animated_sprite.play("Idle")
		
		
	if Input.is_action_pressed("attack") and velocity.x == 0:
		animated_sprite.play("Slash")
		
	move_and_slide()
