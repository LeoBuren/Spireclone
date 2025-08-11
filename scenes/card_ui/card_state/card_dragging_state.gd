extends CardState

const DRAG_MINIMUM_THRESHOLD: float = 0.05
var minimum_drag_time_elapsed: bool = false

func enter() -> void:
	var ui_layer: Node = get_tree().get_first_node_in_group("ui_layer")
	var layer_exists: bool = ui_layer != null
	
	if layer_exists:
		card_ui.reparent(ui_layer)

	card_ui.panel.set("theme_override_styles/panel", card_ui.DRAGGING_STYLEBOX)
	Events.card_drag_started.emit(card_ui)

	var threshold_timer: SceneTreeTimer = get_tree().create_timer(DRAG_MINIMUM_THRESHOLD, false)
	threshold_timer.timeout.connect(func() -> void: minimum_drag_time_elapsed = true)

func exit() -> void:
	Events.card_drag_finished.emit(card_ui)

func on_input(event: InputEvent) -> void:
	var is_single_targeted: bool = card_ui.card.is_single_targeted()
	var is_mouse_motion: bool = event is InputEventMouseMotion
	var is_cancel: bool = event.is_action_pressed("right_mouse")
	var is_confirm: bool = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")

	if is_single_targeted and is_mouse_motion and card_ui.targets.size() > 0:
		transition_requested.emit(self, CardState.State.AIMING)
		return

	if is_mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset

	if is_cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif minimum_drag_time_elapsed and is_confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
