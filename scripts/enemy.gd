extends Area2D

signal enemy_died()
signal enemy_laser_fired()

enum State { FULL, MEDIUM, LOW, DEAD }

var ship_full: CompressedTexture2D = preload("res://assets/enemy/pixel_ship3_green.png")
var ship_medium: CompressedTexture2D = preload("res://assets/enemy/pixel_ship3_yellow.png")
var ship_low: CompressedTexture2D = preload("res://assets/enemy/pixel_ship3_red.png")

var movement_speed: float = 25
var health: int = 3
var healt_state: State = State.FULL

var cooldown_timer: Timer
var cooldown: float = randi_range(2, 5)

func _ready() -> void:
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = false
	cooldown_timer.wait_time = cooldown
	add_child(cooldown_timer)
	
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	cooldown_timer.start()

func _on_cooldown_timeout() -> void:
	emit_signal("enemy_laser_fired")

func _process(delta: float) -> void:
	position.y += movement_speed * delta
	
func _on_laser_hit(area: Area2D) -> void:
	if !area.is_in_group("player"):
		return
	
	area.queue_free()
	
	self.health -= 1
	self.update_ship()
	
func update_ship() -> void:
	match self.health:
		0:
			emit_signal("enemy_died")
			self.queue_free()
		1:
			self.healt_state = State.LOW
			$Ship.texture = ship_low
		2:
			self.healt_state = State.MEDIUM
			$Ship.texture = ship_medium
		3:
			self.healt_state = State.FULL
