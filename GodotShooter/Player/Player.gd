extends CharacterBody2D

signal dead
signal hit

const Bullet = preload("res://Player/bullet.tscn")
const Explode = preload("res://Player/explosion.tscn")
const HitEffect = preload("res://Effects/HitEffect.tscn")

@export var Health = 3
var hitt = 0

const max_speed = 110
const dash_speed = 170
var dash_vector = Vector2.RIGHT
var phase = 1
var screen_size
var direction = Vector2(1,0)
var alive = 0

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var bombHitBox = $HitBoxPivot/BombHitBox
@onready var animationState = $AnimationTree.get("parameters/playback")
@onready var hurtBox = $HurtBox


func _ready():
	screen_size = get_viewport_rect().size
	animationTree.active = true
	$CanvasLayer/H1.hide()
	$CanvasLayer/H2.hide()
	$CanvasLayer/H3.hide()
	$"CanvasLayer/H1-0".hide()
	$"CanvasLayer/H2-0".hide()
	$"CanvasLayer/H3-0".hide()
	hide()

func _physics_process(delta):
	if(alive == 1):
		if(phase == 1):
			var input_vector = Vector2.ZERO
			input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			input_vector = input_vector.normalized()
		
			if input_vector != Vector2.ZERO:
				dash_vector = input_vector
				animationTree.set("parameters/Idle/blend_position", input_vector)
				animationTree.set("parameters/Fly/blend_position", input_vector)
				animationTree.set("parameters/Bomb/blend_position", input_vector)
				animationTree.set("parameters/Dash/blend_position", input_vector)
				animationState.travel("Fly")
				velocity += input_vector * max_speed
				velocity = velocity.limit_length(max_speed)
				position += velocity * delta
				position = position.clamp(Vector2.ZERO, screen_size)
				direction = input_vector
			else:
				animationState.travel("Idle")
				
			if Input.is_action_just_pressed("shoot_action"):
				$Shoot.play()
				var bullet = Bullet.instantiate()
				var world = get_tree().current_scene
				world.add_child(bullet)
				bullet.global_position = global_position
				bullet.velocity = direction * 10
				
			if Input.is_action_just_pressed("dash_action"):
				$Dash.play()
				phase = 3
				
			if Input.is_action_just_pressed("bomb_action"):
				$Bomb.play()
				phase = 2
				
		elif(phase == 2):
			velocity = Vector2.ZERO
			animationState.travel("Bomb")
			
		elif(phase == 3):
			velocity = dash_vector * dash_speed
			animationState.travel("Dash")
			position += velocity * delta
			position = position.clamp(Vector2.ZERO, screen_size)
	
func dash_animation_finished():
	phase = 1
	
func attack_animation_finished():
	phase = 1

func _on_hit_box_area_entered(area):
	pass

func invisibility():
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.5).timeout
	$HurtBox/CollisionShape2D.disabled = false

func _on_hurt_box_area_entered(area):
	invisibility()
	Health -= 1
	$Hurt.play()
	hitt += 1
	if(hitt == 1):
		$CanvasLayer/H3.hide()
	elif(hitt == 2):
		$CanvasLayer/H1.hide()
	elif(hitt == 3):
		$CanvasLayer/H2.hide()
	hit.emit()
	$CanvasLayer/Health.text = str(3 - hitt)
	
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
	
	var explode = Explode.instantiate()
	var world = get_tree().current_scene
	world.add_child(explode)
	explode.global_position = global_position
	
	if(Health <= 0):
		hide()
		dead.emit()
		alive = 0
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		await get_tree().create_timer(0.6).timeout
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		
func start(pos):
	$CanvasLayer/H1.show()
	$CanvasLayer/H2.show()
	$CanvasLayer/H3.show()
	$"CanvasLayer/H1-0".show()
	$"CanvasLayer/H2-0".show()
	$"CanvasLayer/H3-0".show()
	hitt = 0
	$CanvasLayer/Health.text = str(3-hitt)
	position = pos
	show()
	$HurtBox/CollisionShape2D.disabled = false
	Health = 3
	alive = 1

