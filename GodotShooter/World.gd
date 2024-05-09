extends Node

@export var spike_scene: PackedScene
@export var track_scene: PackedScene
@export var turret_scene: PackedScene
@export var circle_scene: PackedScene
@export var cloud_scene: PackedScene

var rand_x
var rand_y

func _ready():
	var spiketimer = get_node("SpikeTimer") 
	var cloudtimer = get_node("CloudTimer") 
	var tracktimer = get_node("TrackTimer")
	var turrettimer = get_node("TurretTimer")
	spiketimer.timeout.connect(_on_spike_timer_timeout)
	cloudtimer.timeout.connect(_on_cloud_timer_timeout)
	tracktimer.timeout.connect(_on_track_timer_timeout)
	turrettimer.timeout.connect(_on_turret_timer_timeout)
	$CloudTimer.start()

func game_over():
	$SpikeTimer.stop()
	$TrackTimer.stop()
	$TurretTimer.stop()
	$HUD.show_game_over()
	
func clear():
	get_tree().call_group("tracks", "queue_free")
	get_tree().call_group("spikes", "queue_free")
	get_tree().call_group("turrets", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	
func game_win():
	$SpikeTimer.stop()
	$TrackTimer.stop()
	$TurretTimer.stop()
	clear()
	$HUD.show_game_win()

func new_game():
	clear()
	$SpikeTimer.start()
	$TrackTimer.start()
	$TurretTimer.start()
	$ysort/Player.start($StartPosition.position)

func _on_turret_timer_timeout():
	var turret = turret_scene.instantiate()
	var circle = circle_scene.instantiate()
	rand_x = randf_range(20, 520)
	rand_y = randf_range(20, 520)
	turret.global_position = Vector2(rand_x, rand_y)
	circle.global_position = Vector2(rand_x-3, rand_y)
	add_child(circle)
	await get_tree().create_timer(1.7).timeout
	add_child(turret)

func _on_track_timer_timeout():
	var track = track_scene.instantiate()
	var track_spawn_location = $SpikePath/SpikeSpawn
	track_spawn_location.progress_ratio = randf()
	track.position = track_spawn_location.position
	add_child(track)

func _on_spike_timer_timeout():
	spawn_spike()
	spawn_spike()
	spawn_spike()
	
func _on_cloud_timer_timeout():
	spawn_cloud()
	spawn_cloud()
	spawn_cloud()

func spawn_spike():
	var spike = spike_scene.instantiate()
	var spike_spawn_location = $SpikePath/SpikeSpawn
	spike_spawn_location.progress_ratio = randf()
	var dir = spike_spawn_location.rotation + PI / 2
	spike.position = spike_spawn_location.position
	dir += randf_range(-PI / 4, PI / 4)
	spike.rotation = dir
	var velocity = Vector2(1, 0.0)
	spike.velocity = velocity.rotated(dir)
	add_child(spike)
	
func spawn_cloud():
	await get_tree().create_timer(randf_range(0, 5)).timeout
	var cloud = cloud_scene.instantiate()
	var rand = randf_range(0, 540)
	cloud.global_position = Vector2(-50, rand)
	cloud.velocity = Vector2(randf_range(1, 5), 0)
	add_child(cloud)
	
