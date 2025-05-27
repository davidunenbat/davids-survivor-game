extends CharacterBody2D


@export var movement_speed: float = 20.0
@export var hp: int = 10
@onready var player: Node2D = get_tree().get_first_node_in_group("player")

#enemy targeting movement
func _physics_process(_delta: float) -> void:
	var to_player: Vector2 = player.global_position - global_position
	if to_player.length() > 0:
		velocity = to_player.normalized() * movement_speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	

#tutorial
func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	if hp <= 0:
		queue_free()

func deal_damage_to_player(player):
	if player.has_method("take_damage"):
		player.take_damage(1)
