extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # The monster's animated sprite
@onready var raycast_left: RayCast2D = $RayCastLeft  # RayCast for detecting the player on the left
@onready var raycast_right: RayCast2D = $RayCastRight  # RayCast for detecting the player on the right
@onready var speed: float = 100.0  # Speed at which the monster walks

var player: Node2D = null  # Reference to the player

func _ready() -> void:
	# Ensure the RayCasts are enabled to detect collisions
	raycast_left.enabled = true
	raycast_right.enabled = true
	sprite.play("Idle")  # Set default animation to Idle when the monster is not moving

func _process(delta: float) -> void:
	# Debugging RayCast status
	print("RayCast Left Colliding: ", raycast_left.is_colliding())
	print("RayCast Right Colliding: ", raycast_right.is_colliding())

	# Check if the RayCast on the left is detecting the player
	if raycast_left.is_colliding():
		var collider = raycast_left.get_collider()
		if collider is CharacterBody2D:  # If the player is detected on the left
			print("Player detected on the left!")
			player = collider
			move_towards_player(delta)  # Move towards the player

	# Check if the RayCast on the right is detecting the player
	elif raycast_right.is_colliding():
		var collider = raycast_right.get_collider()
		if collider is CharacterBody2D:  # If the player is detected on the right
			print("Player detected on the right!")
			player = collider
			move_towards_player(delta)  # Move towards the player

	# If neither RayCast detects the player, play Idle animation
	else:
		sprite.play("Idle")

func move_towards_player(delta: float) -> void:
	if player:
		# Get direction to the player, only modify the X-axis (left/right)
		var direction_vector = (player.position - position).normalized()  # Get direction to player
		print("Direction to player: ", direction_vector)  # Debugging direction
		position.x += direction_vector.x * speed * delta  # Move the monster horizontally towards the player

		# Play the Walk animation when moving towards the player
		sprite.play("Walk")

		# Flip the sprite based on direction (use sign of direction.x to determine flip)
		sprite.flip_h = direction_vector.x < 0  # Flip sprite if the player is to the left
