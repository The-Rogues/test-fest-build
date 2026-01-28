class_name CardHand
extends Node2D

var CARD_WIDTH:float = 100
var screen_center_x:float
@export var drawn_cards:Array[CardUI] = []
@export var y_position:float
var grabbed_card:CardUI = null
var screen_size:Vector2

func _ready() -> void:
	screen_size = get_viewport().size
	initialize_drawn_cards()
	get_viewport().size_changed.connect(on_screen_size_changed)

func on_screen_size_changed():
	update_drawn_cards_position()

func _process(delta: float) -> void:
	if grabbed_card:
		var mouse_pos = get_global_mouse_position()
		grabbed_card.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),clamp(mouse_pos.y, 0, screen_size.y))

func initialize_drawn_cards():
	screen_center_x = get_viewport().size.x / 2
	
	for card in drawn_cards:
		card.hovered.connect(on_card_hovered)
		card.clicked.connect(on_card_grabbed)
		card.released.connect(on_card_released)
		card.set_card_owner(self)
	
	update_drawn_cards_position()
# Called when the node enters the scene tree for the first time.

func update_drawn_cards_position():
	for i in range(0, drawn_cards.size()):
		var card_pos = Vector2(calculate_card_position(i), y_position)
		var card = drawn_cards[i]
		tween_card_to_position(card, card_pos)

func calculate_card_position(index):
	var total_width = (drawn_cards.size() - 1) * CARD_WIDTH
	var x_offset = screen_center_x + index * CARD_WIDTH - total_width / 2
	return x_offset

func tween_card_to_position(card, new_positon):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_positon, 0.2)

func add_card(card:CardUI):
	if !drawn_cards.has(card):
		drawn_cards.append(card)

func remove_card(card:CardUI):
	if drawn_cards.has(card):
		drawn_cards.erase(card)

func on_card_grabbed(card_ui:CardUI):
	if !grabbed_card:
		grabbed_card = card_ui
		remove_card(grabbed_card)
		update_drawn_cards_position()
	pass

func on_card_released(card_ui:CardUI):
	if grabbed_card:
		if grabbed_card.in_play_area:
			grabbed_card = null
			return
		
		add_card(grabbed_card)
		grabbed_card = null
		update_drawn_cards_position()
	pass

func on_card_hovered(card_ui:CardUI, hovered:bool):
	if hovered:
		if !grabbed_card:
			card_ui.blow_up(true)
	else:
		card_ui.blow_up(false)
