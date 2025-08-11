class_name CardUI
extends Control

signal reparent_request(which_card_ui: CardUI)

const BASE_STYLEBOX: Resource = preload("res://card_base_stylebox.tres")
const DRAGGING_STYLEBOX: Resource = preload("res://card_dragging_stylebox.tres")
const HOVER_STYLEBOX: Resource = preload("res://card_hover_stylebox.tres")

@export var card: Card: set = _set_card
@export var char_stats: CharacterStats: set = _set_char_stats

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine
@onready var targets: Array[Node] = []
@onready var original_index: int = self.get_index()

var parent: Control
var tween: Tween
var is_playable: bool = true: set = _set_playable
var is_disabled: bool = false

func _ready() -> void:
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_aim_finished.connect(_on_card_drag_or_aiming_finished)
	Events.card_drag_finished.connect(_on_card_drag_or_aiming_finished)
	card_state_machine.init(self)

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func play() -> void:
	if not card: return

	card.play(targets, char_stats)
	queue_free()

func animate_to_position(new_pos: Vector2, dur: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_pos, dur)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready

	card = value
	cost.text = str(value.cost)
	icon.texture = card.icon

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)

func _set_playable(value: bool) -> void:
	is_playable = value
	if is_playable:
		cost.remove_theme_color_override("font_color")
		icon.modulate = Color(1,1,1,1)
		return

	cost.add_theme_color_override("font_color", Color.RED)
	icon.modulate = Color(1,1,1,0.5)

func _on_card_drag_or_aiming_started(used_card: CardUI) -> void:
	if used_card == self: return
	is_disabled = true

func _on_card_drag_or_aiming_finished(_card: CardUI) -> void:
	is_disabled = false
	self.is_playable = char_stats.can_play_card(card)

func _on_char_stats_changed() -> void:
	self.is_playable = char_stats.can_play_card(card)
