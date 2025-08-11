class_name Hand
extends HBoxContainer

var cards_played_this_turn: int = 0

func _ready() -> void:
	for child: CardUI in get_children():
		child.parent = self
		child.reparent_request.connect(_on_card_ui_reparent_requested)

func _on_card_played(_card: Card) -> void:
	cards_played_this_turn += 1

func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.reparent(self)
	var new_index: int = clampi(child.original_index - cards_played_this_turn, 0, get_child_count())
	move_child.call_deferred(child, new_index)
