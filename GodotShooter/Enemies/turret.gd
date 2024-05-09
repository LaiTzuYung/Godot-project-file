extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtBox = $HurtBox

var direction

const DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const Bullet = preload("res://Enemies/enemybullet.tscn")

func _physics_process(delta):
	animatedSprite.play("Blink")
		
func _ready():
	var timer = get_node("Timer")
	timer.timeout.connect(_on_timer_timeout)
	$Timer.start()

func _on_timer_timeout():
	var bullet = Bullet.instantiate()
	var world = get_tree().current_scene
	bullet.global_position = global_position
	
	var player = playerDetectionZone.player
	if player != null:
		direction = (player.global_position - global_position).normalized()
		bullet.velocity = direction * 0.5
	
	world.add_child(bullet)
	
func _on_hurt_box_area_entered(area):
	var deathEffect = DeathEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(deathEffect)
	deathEffect.global_position = global_position + Vector2(0, 15)
	$Timer.stop()
	queue_free()
