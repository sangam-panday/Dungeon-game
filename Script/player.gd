extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -550.0
const ATTACK_DAMAGE = 10  # Damage value to apply to enemies
var is_attacking = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea  # Reference to the AttackArea node
@onready var timer: Timer = $Timer

func _physics_process(delta: float) -> void:
	# If the attack button is pressed and not already attacking, trigger the attack animation.
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		animated_sprite.play("Attack")  # Play the attack animation
		attack_area.monitoring = true
		timer.start()  # Enable collision detection for the attack hitbox
	
	if Input.is_action_just_pressed("attack") and not is_attacking and Input.is_action_just_pressed("ui_accept"):
		is_attacking = true
		animated_sprite.play("JumpAttack")  # Play the attack animation
		attack_area.monitoring = true
		timer.start() 
	
	# Add gravity if the player is not on the floor.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jumping.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get horizontal movement direction.
	var direction := Input.get_axis("move_left", "move_right")

	# Flip sprite based on movement direction.
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Handle animations based on movement and jump states.
	if is_attacking:
		# Attack animation is playing, don't switch to other animations.
		return
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")  # Play idle animation if no movement.
		else:
			animated_sprite.play("walk")  # Play walk animation if moving.
	else:
		animated_sprite.play("Jump")  # Play jump animation if in the air.
	
	# Handle horizontal movement.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_timer_timeout() -> void:
	is_attacking = false
	attack_area.monitoring = false# Replace with function body.
