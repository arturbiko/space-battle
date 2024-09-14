extends Area2D

enum LaserRoot { Player, Enemy }
var laserRoot: LaserRoot

var speed: int = 400

@onready var player_laser = preload("res://assets/attack/pixel_laser_blue.png")
@onready var enemy_laser = preload("res://assets/attack/pixel_laser_red.png")

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.area_entered.connect(_on_area_entered)
	
	$OutOfBounds.position = Vector2(0, 0)
	$OutOfBounds.screen_exited.connect(_on_screen_exited)
	
	if laserRoot == LaserRoot.Player:
		$OutOfBounds.position = Vector2(0, -5)
		$Sprite.texture = player_laser
		self.add_to_group("player")
	else:
		$OutOfBounds.position = Vector2(0, 3)
		$Sprite.texture = enemy_laser
		speed = 800
		self.add_to_group("enemy")
		

func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	if laserRoot == LaserRoot.Player:
		direction.y -= 1
	else:
		direction.y += 1
	
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	body._on_laser_hit(self)
	
func _on_area_entered(area: Node2D) -> void:
	area._on_laser_hit(self)

func _on_laser_hit(area: Node2D) -> void:
	pass

func _on_screen_exited() -> void:
	queue_free()
