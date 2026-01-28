extends Label

@export var battle_entity:BattleEntity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if battle_entity:
		battle_entity.data_changed.connect(_on_entity_data_changed)
	pass # Replace with function body.

func _on_entity_data_changed():
	print("data changed")
	text = battle_entity.entity_data.name
