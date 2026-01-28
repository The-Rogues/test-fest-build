extends Area2D
class_name CardPlayArea

signal playing_card(card_ui:CardUI)
@onready var label: Label = $Label

func on_entered_card_released(card_ui:CardUI):
	playing_card.emit(card_ui)
	pass

func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() is CardUI:
		var card:CardUI = area.get_parent()
		card.released.disconnect(on_entered_card_released)
	label.visible = false
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is CardUI:
		var card:CardUI = area.get_parent()
		card.released.connect(on_entered_card_released)
	
	label.visible = true
	pass # Replace with function body.
