class_name Stats
extends Resource

signal stats_changed

const MAX_BLOCK = 999

@export var max_health: int = 1
@export var art: Texture

var health: int : set = set_health
var block: int : set = set_block

func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	stats_changed.emit()
	
func set_block(value: int) -> void:
	block = clampi(value, 0, MAX_BLOCK)
	stats_changed.emit()

func take_damage(damage: int) -> void:
	if damage <= 0: return

	var unblocked_damage: int = clampi(damage - block, 0, damage)
	
	self.block = clampi(block - damage, 0, block)
	self.health -= unblocked_damage

func heal(amount: int) -> void:
	self.health += amount

func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.block = 0

	return instance
