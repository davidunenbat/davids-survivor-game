extends Area2D
#tutorial code
@export var damage = 1
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableHitBoxTimer

func tempdisable():
	collision.call_deferred("set", "disabled", true)
	disableTimer.start()

func _on_disable_hit_box_timer_timeout() -> void:
	collision.call_deferred("set","disabled", false)
