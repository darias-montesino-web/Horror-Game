extends CharacterBody2D

@export var speed: float = 100.0
var player: CharacterBody2D = null
var chasing: bool = false

var health = 100
var player_inrange = false

@onready var animated_sprite = $AnimatedSprite2D

var can_take_dmg = true
var isAttacking = false
var is_Walking = false
var isIdle = true

func _physics_process(_delta):
	deal_with_damage()
		
	if chasing and player and is_Walking:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		$AnimatedSprite2D.play("Walk")
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = false
		elif direction.x < 0:
			$AnimatedSprite2D.flip_h = true
	if is_Walking == false and isAttacking == false and isIdle == true:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("Idle")
	if isAttacking == true:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("Attack")
	move_and_slide()
	
	
	
func _on_detect_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): # Assuming player is in a "player" group
		player = body
		isIdle = false
		if isAttacking == false:
			chasing = true
			is_Walking = true
			print("Player detected, chasing!")

func _on_detect_radius_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		chasing = false
		is_Walking = false
		isIdle = true
		velocity = Vector2.ZERO
		print("Player left detection range, stopped chasing.")
	
func enemy():
	pass
	
func deal_with_damage():
	if player_inrange and Global.player_current_attack == true and can_take_dmg == true:
		isAttacking = false
		is_Walking = false
		isIdle = false
		health = health - 34
		animated_sprite.play("Hurt")
		velocity = Vector2.ZERO
		$HurtCooldown.start()
		can_take_dmg = false
		chasing = false
		print("Zombie Health: ", health)
		if health <= 0:
			animated_sprite.play("Dead")
			velocity = Vector2.ZERO

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		is_Walking = false
		isAttacking = true
		
		

func _on_hit_box_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		isAttacking = false
		is_Walking = true


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.has_method("player"):
		player_inrange = true


func _on_hit_box_area_exited(area: Area2D) -> void:
	if area.has_method("player"):
		player_inrange = false


func _on_hurt_cooldown_timeout() -> void:
	can_take_dmg = true
	chasing = true
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Dead":
		self.queue_free()
	if $AnimatedSprite2D.animation == "Hurt":
		is_Walking = true
