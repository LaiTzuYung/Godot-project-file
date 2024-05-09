extends CharacterBody2D

@onready var Sprite = $Sprite2D

const DeathEffect = preload("res://Effects/BulletDeathEffect.tscn")
	
func _physics_process(delta):
	position += velocity
	
func _on_hurt_box_area_entered(area):
	queue_free()
	var deathEffect = DeathEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(deathEffect)
	deathEffect.global_position = global_position
