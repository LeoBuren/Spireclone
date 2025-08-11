extends CardState

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready

	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()

	card_ui.reparent_request.emit(card_ui)
	card_ui.pivot_offset = Vector2.ZERO
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)

func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)

func on_mouse_entered() -> void:
	card_ui.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLEBOX)
	
func on_mouse_exited() -> void:
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)

func on_playable_changed(is_playable: bool) -> void:
	if is_playable: return
	transition_requested.emit(self, CardState.State.DISABLED)
