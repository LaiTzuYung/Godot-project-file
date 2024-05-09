extends CharacterBody2D

func _physics_process(delta):
	position += velocity

func _ready():
	var cloud_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(cloud_types[randi() % cloud_types.size()])
