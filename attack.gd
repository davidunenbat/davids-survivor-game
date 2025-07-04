extends Area2D
#tutorial code
var hp = 1
var speed = 100
var damage = 5
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	hp = 1
	speed = 100
	damage = 5
	attack_size = 1.0

func _physics_process(delta):
	position += angle * speed * delta
	
#removes enemy
func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()
#despawns attack
func _on_timer_timeout() -> void:
	queue_free()
