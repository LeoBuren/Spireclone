class_name Player
extends Node2D

@export var stats: CharacterStats: set = set_character_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stats_ui: StatsUI = $StatsUI

func set_character_stats(value: CharacterStats) -> void:
	stats = value.create_instance()

	if OS.is_debug_build():
		if not stats.stats_changed.is_connected(update_stats):
			stats.stats_changed.connect(update_stats)

	update_player()

func update_player() -> void:
	if not stats is CharacterStats: return

	if not is_inside_tree():
		await ready

	sprite_2d.texture = stats.art
	update_stats()

func update_stats() -> void:
	stats_ui.update_stats(stats)

func take_damage(value: int) -> void:
	stats.take_damage(value)

	if stats.health <= 0:
		queue_free()
