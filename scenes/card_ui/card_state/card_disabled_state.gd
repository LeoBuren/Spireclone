extends CardState

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready

	card_ui.cost.add_theme_color_override("font_color", Color.RED)
	card_ui.icon.modulate = Color(1,1,1,0.5)

func on_playable_changed(is_playable: bool) -> void:
	if not is_playable: return
	
	card_ui.cost.remove_theme_color_override("font_color")
	card_ui.icon.modulate = Color(1,1,1,1)
	
	transition_requested.emit(self, CardState.State.BASE)
