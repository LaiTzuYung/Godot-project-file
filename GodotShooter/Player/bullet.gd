extends CharacterBody2D

@onready var Sprite = $Sprite2D

func _physics_process(delta):
	position += velocity

func _on_hurt_box_area_entered(area):
	queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
