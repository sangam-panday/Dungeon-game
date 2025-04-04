extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var timer: Timer = $Timer

func _ready() -> void:
	animated_sprite.play("initial")


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D: 
		animated_sprite.play("open")
		timer.start()

func _on_timer_timeout() -> void:
	queue_free()
