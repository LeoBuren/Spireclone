extends Node2D

const ARC_POINTS: int = 12

@onready var area_2d: Area2D = $Area2D
@onready var card_arc: Line2D = $CanvasLayer/CardArc

var current_card: CardUI
var is_targeting: bool = false

func _ready() -> void:
	Events.card_aim_started.connect(_on_card_aim_started)
	Events.card_aim_finished.connect(_on_card_aim_finished)

func _process(_delta: float) -> void:
	if not is_targeting: return
	
	area_2d.position = get_local_mouse_position()
	card_arc.points = _get_points()

func _get_points() -> Array[Vector2]:
	var points: Array[Vector2] = []
	var start: Vector2 = current_card.global_position
	start.x += (current_card.size.x / 2)
	var target: Vector2 = get_local_mouse_position()
	var distance: Vector2 = target - start
	
	for i: int in range(ARC_POINTS):
		var t: float = (1.0 / ARC_POINTS) * i
		var x: float = start.x + (distance.x / ARC_POINTS) * i
		var y: float = start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x, y))

	points.append(target)

	return points

func ease_out_cubic(num: float) -> float:
	return 1.0 - pow(1.0 - num, 3.0)

func _on_card_aim_started(card: CardUI) -> void:
	if not card.card.is_single_targeted(): return

	is_targeting = true
	area_2d.monitoring = true
	area_2d.monitorable = true
	current_card = card

func _on_card_aim_finished(_card: CardUI) -> void:
	is_targeting = false
	card_arc.clear_points()
	area_2d.position = Vector2.ZERO
	area_2d.monitoring = false
	area_2d.monitorable = false
	current_card = null

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not current_card or not is_targeting: return

	if not current_card.targets.has(area):
		current_card.targets.append(area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if not current_card or not is_targeting: return

	current_card.targets.erase(area)
