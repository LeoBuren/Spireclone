class_name DamageEffect
extends Effect

var amount: int = 0

func execute(targets: Array[Node]) -> void:
	for target: Node in targets:
		if target == null:
			continue
		if target is Player or target is Enemy:
			target.take_damage(amount)
