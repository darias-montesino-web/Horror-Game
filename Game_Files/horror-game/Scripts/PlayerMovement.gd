extends CharacterBody2D

@export var walk_speed = 250.0
@export var run_speed = 400
const JUMP_VELOCITY = -400.0

@export_range(0,1) var deceleration = 0.1
@export_range(0,1) var acceleration = 0.1

var speed
var run_type
@onready var animated_sprite = $AnimatedSprite2D
@onready var col_shape = $CollisionShape2D

var isAttacking = false;
var enemy_inRange = false;
var enemy_coolDown = true;
var health = 100;
var player_alive = true


func _physics_process(delta: float) -> void:
	
	enemy_attack()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("Player has died")
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	# Handle jump -- not working idk why
	if Input.is_action_pressed("jump") and is_on_floor() and !isAttacking:
		velocity.y = JUMP_VELOCITY
		animated_sprite.play("Jump")
		
	if Input.is_action_pressed("run") and !isAttacking:
		speed = run_speed
		
	else:
		speed = walk_speed
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	# Handle running
	if direction and not Input.is_action_pressed("jump") and Input.is_action_pressed("run") == true and !isAttacking:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
		animated_sprite.play("Run")
		animated_sprite.flip_h = direction < 0
	
	# Handle walking
	else:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
		if !isAttacking:
			animated_sprite.play("Walk")
			animated_sprite.flip_h = direction < 0
			
	
	# Handle standing
	if !direction and !isAttacking:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
		animated_sprite.flip_h = direction > 0
		animated_sprite.play("Idle")
		
	# ATTACK animation
	if Input.is_action_just_pressed("attack"):
		animated_sprite.play("Slash")
		Global.player_current_attack = true
		isAttacking = true;
		$AttackArea/CollisionShape2D.disabled = false;
		
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Slash":
		$AttackArea/CollisionShape2D.disabled = true;
		isAttacking = false
		Global.player_current_attack = false


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inRange = true

func _on_hit_box_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inRange = false
		
func enemy_attack():
	if enemy_inRange and enemy_coolDown == true:
		print("Player took damage")
		enemy_coolDown = false	
		$Cooldown.start()
		
func player():
	pass

func _on_cooldown_timeout() -> void:
	enemy_coolDown = true

#func _on_attack_area_body_entered(body: Node2D) -> void:
	#if body.has_method("enemy"):
		#enemy_inRange = true
#
#func _on_attack_area_body_exited(body: Node2D) -> void:
	#if body.has_method("enemy"):
		#enemy_inRange = false
