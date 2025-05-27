extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0

@export var hp = 10
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage)
#gets hit
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		if area.get("damage") != null:
			match HurtBoxType:
				0: #Cooldown
					collision.call_deferred("set","disabled", true)
					disableTimer.start()
				1: #HitOnce
					pass
				2: #DisableHitBox
					if area.has_method("tempdisable"):
						area.tempdisable()
			#check
			var damage = area.damage
			emit_signal("hurt", damage)
			#enemy
			if area.has_method("enemy_hit"):
				area.enemy_hit(10)

func _on_disable_timer_timeout() -> void:
	collision.call_deferred("set", "disabled",false)

func _on_body_entered(body):
	if body.name == "Wizard":
		body.take_damage(10)
