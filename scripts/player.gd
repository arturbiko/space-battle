extends CharacterBody2D

var health: int = 3

var SPEED: float = 200
var LEFT_BOUNDARY: int = 30
var RIGHT_BOUNDARY: int = 770

var cooldown_timer: Timer
var COOLDOWN: float = .3

signal player_laser_fired()
signal player_died()

@onready var player_full: CompressedTexture2D = preload("res://assets/player/player_full.png")
@onready var player_medium: CompressedTexture2D = preload("res://assets/player/player_medium.png")
@onready var player_low: CompressedTexture2D = preload("res://assets/player/player_low.png")

func _ready() -> void:
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = COOLDOWN
	add_child(cooldown_timer)

func _process(delta: float) -> void:
	var direction = Vector2.ZERO 

	if Input.is_action_pressed("move_left") and position.x > LEFT_BOUNDARY:
		direction.x = -1

	if Input.is_action_pressed("move_right") and position.x < RIGHT_BOUNDARY:
		direction.x = 1
		
	if direction == Vector2.ZERO:
		velocity.x = 0
	else:
		velocity.x = direction.x * SPEED
		
	if Input.is_action_pressed("fire") and cooldown_timer.is_stopped():
		emit_signal("player_laser_fired")
		
		cooldown_timer.start()

	move_and_slide()
	
func _on_laser_hit(area: Area2D) -> void:
	if !area.is_in_group("enemy"):
		return
	
	area.queue_free()
	
	self.health -= 1
	self.update_ship()
	
func update_ship() -> void:
	match self.health:
		0:
			emit_signal("player_died")
			self.queue_free()
		1:
			$Ship.texture = player_low
		2:
			$Ship.texture = player_medium
