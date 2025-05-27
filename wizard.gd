extends CharacterBody2D

@export var max_health := 100
var current_health := max_health
@onready var health_bar = get_node("/root/World/CanvasLayer/HealthUI/HealthBar")
@export var movement_speed = 100
var hp = 100
#Attacks
var ice = preload("res://attack.tscn")

#AttackNodes
@onready var iceTimer = get_node("%IceTimer") #reload
@onready var iceAttackTimer = get_node("%IceAttackTimer")

var ice_ammo = 0
var ice_baseammo = 1
var ice_attackspeed = 1.5
var enemy_close = []


#player movement
func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * movement_speed	
	move_and_slide()

func initialize():
	print("Initializing health bar")
	health_bar.max_value = max_health
	health_bar.value = current_health
	
func take_damage(amount: int = 1):
	current_health = max(current_health - amount, 0)
	health_bar.value = current_health
	update_health_ui()

func update_health_ui():
	var health_bar = get_tree().get_root().get_node("/root/World/CanvasLayer/HealthUI/HealthBar")
	health_bar.update_health(current_health, max_health)
func die():
	queue_free()
	print("Player died")
	
	
func _ready():
	attack()
	print("Wizard ready")
	initialize()
#attack logic
func attack():
	iceTimer.wait_time = ice_attackspeed
	if iceTimer.is_stopped():
		iceTimer.start()
#reduces hp
func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	print(hp)

#when attack fires
func _on_ice_attack_timer_timeout() -> void:
	if ice_ammo > 0:
		var target = get_random_target()
		if target:
			var ice_attack = ice.instantiate()
			ice_attack.position = position
			ice_attack.target = get_random_target()
			add_child(ice_attack)
			
			ice_ammo -= 1
			
			if ice_ammo > 0:
				iceAttackTimer.start()
			else:
				iceAttackTimer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return null

#reload logic
func _on_ice_timer_timeout() -> void:
	ice_ammo += ice_baseammo
	iceAttackTimer.start()

func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if body not in enemy_close:
		enemy_close.append(body)

func _on_enemy_detection_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	enemy_close.erase(body)
