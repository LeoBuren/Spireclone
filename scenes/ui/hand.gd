class_name Hand
extends HBoxContainer

func _ready() -> void:
	for child: CardUI in get_children():
		child.parent = self
		child.reparent_request.connect(_on_card_ui_reparent_requested)

func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.reparent(self)
