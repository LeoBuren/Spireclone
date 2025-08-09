extends Node3D

const CARD := preload("res://scenes/card_ui/Card.tscn")

func _ready() -> void:
	add_5_cards()
	for card in hand.get_children():
		var hand_ratio: float = .5
		
		if get_child_count() > 1:
			hand_ratio = float(card.get_index() / float(hand.get_child_count() - 1))

func add_5_cards() -> void:
	for _x in 5:
		var card: Node = CARD.instantiate()
		add_child(card)
