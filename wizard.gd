extends CharacterBody2D

var max_health := 100
var current_health := max_health
@onready var health_bar = $HealthBar
@export var movement_speed = 100
var hp = 100



#player movement
func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * movement_speed	
	move_and_slide()

func take_damage(amount: int = 10):
	current_health = max(current_health - amount, 0)
	health_bar.value = current_health
	if current_health <= 0:
		die()

func die():
	print("Player died")
	get_tree().reload_current_scene()
	
	
func _ready():
	attack()
	health_bar.max_value = max_health
	health_bar.value = current_health
	
func _on_victory_timer_timeout() -> void:
	$CanvasLayer/VictoryScreen.visible = true
#tutorial code
#Attacks
var ice = preload("res://attack.tscn")

#AttackNodes
@onready var iceTimer = get_node("%IceTimer") #reload
@onready var iceAttackTimer = get_node("%IceAttackTimer")

var ice_ammo = 0
var ice_baseammo = 1
var ice_attackspeed = 1.5
var enemy_close = []
#attack logic
func attack():
	iceTimer.wait_time = ice_attackspeed
	if iceTimer.is_stopped():
		iceTimer.start()
#reduces hp
func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	print(hp)
	take_damage(10)

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
