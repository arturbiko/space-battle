extends Node2D

@onready var LaserScene: PackedScene = preload("res://laser.tscn")
@onready var EnemyScene: PackedScene = preload("res://enemy.tscn")

signal game_over()

var LEFT_BOUNDARY: int = 30
var RIGHT_BOUNDARY: int = 770

var spawn_timer: Timer
var spawn_rate: float = 5
var last_spawn_point: Vector2 = Vector2.ZERO

func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.one_shot = false
	spawn_timer.wait_time = spawn_rate
	add_child(spawn_timer)
	
	spawn_timer.connect("timeout", _on_spawn_timer_timeout)
	spawn_timer.start()
	
	$Player.player_laser_fired.connect(_on_play_laser_fired)
	$Player.player_died.connect(_on_player_died)

func _on_spawn_timer_timeout() -> void:
	var enemy: Node2D = EnemyScene.instantiate()
	var spawn_point = Vector2(
		randi() % RIGHT_BOUNDARY,
		-10
	)
	
	var try = 0
	
	while spawn_point == last_spawn_point and try < 3:
		spawn_point = Vector2(
			randi() % RIGHT_BOUNDARY,
			-10
		)
		
		++try
	
	enemy.position = spawn_point
	enemy.enemy_died.connect(_on_enemy_died)
	enemy.enemy_laser_fired.connect(_on_enemy_laser_fired.bind(enemy))

	add_child(enemy)
	
	last_spawn_point = spawn_point
	
func is_spawned_too_close(point_one: Vector2, point_two: Vector2) -> bool:
	if point_one == point_two:
		return true
		
	if point_one.distance_to(point_two) <= 25:
		return true
	
	return false

func _on_enemy_died() -> void:
	$HighScore.increase()

func _on_player_died() -> void:
	emit_signal("game_over")

func _on_enemy_laser_fired(enemy) -> void:
	var laser: Area2D = LaserScene.instantiate()
	laser.laserRoot = laser.LaserRoot.Enemy
	laser.position = enemy.position
	add_child(laser)
	
func _on_play_laser_fired() -> void:
	var laser: Area2D = LaserScene.instantiate()
	laser.laserRoot = laser.LaserRoot.Player
	laser.position = $Player.position
	add_child(laser)
