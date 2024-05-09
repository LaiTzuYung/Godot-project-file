extends CharacterBody2D

@export var max_speed = 60

@onready var animatedSprite = $AnimatedSprite
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtBox = $HurtBox

const DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
	
func _physics_process(delta):
	animatedSprite.play("Fly")
	var player = playerDetectionZone.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * max_speed

	position += velocity * delta

func _on_hurt_box_area_entered(area):
	queue_free()
	var deathEffect = DeathEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(deathEffect)
	deathEffect.global_position = global_position + Vector2(0, 15)
	
