extends Area2D

@export var max_health: int = 100
var current_health: int = max_health

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_left: RayCast2D = $RayCastLeft
@onready var raycast_right: RayCast2D = $RayCastRight
@onready var speed: float = 100.0
@onready var timer: Timer = $Timer

var player: Node2D = null
var last_direction_x := 1.0
var attack_range := 103.0

func _ready() -> void:
	raycast_left.enabled = true
	raycast_right.enabled = true
	sprite.play("Idle")

func _process(delta: float) -> void:
	var detected := false

	if raycast_left.is_colliding():
		var collider = raycast_left.get_collider()
		if collider is CharacterBody2D:
			player = collider
			move_towards_player(delta)
			detected = true

	if raycast_right.is_colliding():
		var collider = raycast_right.get_collider()
		if collider is CharacterBody2D:
			player = collider
			move_towards_player(delta)
			detected = true

	if not detected:
		sprite.play("Idle")
		sprite.flip_h = last_direction_x < 0

func move_towards_player(delta: float) -> void:
	if player:
		var direction_vector = (player.global_position - global_position)
		var distance_to_player = direction_vector.length()
		
		if distance_to_player <= attack_range:
			# Player is within attack range
			sprite.play("Attack")
			sprite.flip_h = direction_vector.x < 0
			return  # Stop here, don't move

		# Normalize direction and walk if not attacking
		direction_vector = direction_vector.normalized()
		
		if abs(direction_vector.x) > 0.01:
			last_direction_x = direction_vector.x
			global_position.x += direction_vector.x * speed * delta

			sprite.play("Walk")
			sprite.flip_h = direction_vector.x < 0

func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		die()

func die() -> void:
	sprite.play("Death")
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()
