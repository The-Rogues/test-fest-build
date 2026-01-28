extends Control
class_name EntityUI

@onready var entity_name_label: Label = $VBoxContainer/EntityNameLabel
@onready var _health_bar: HealthBarUI = $VBoxContainer/HealthBar

func set_entity_data(combat_entity:CombatEntity):
	entity_name_label.text = combat_entity.entity_name
	_health_bar.set_defaults(combat_entity.health)
	combat_entity.health_changed.connect(_health_bar.update_ui)
