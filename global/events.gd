extends Node

# Card-related events
signal card_drag_started(card_ui: CardUI)
signal card_drag_finished(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_finished(card_ui: CardUI)
signal card_played(card: Card)
