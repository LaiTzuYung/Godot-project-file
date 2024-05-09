extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite
@onready var hurtBox = $HurtBox

const DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

func _physics_process(delta):
	animatedSprite.play("Fly")
	position += velocity
	
func _on_hurt_box_area_entered(area):
	queue_free()
	var deathEffect = DeathEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(deathEffect)
	deathEffect.global_position = global_position + Vector2(0, 15)
	

