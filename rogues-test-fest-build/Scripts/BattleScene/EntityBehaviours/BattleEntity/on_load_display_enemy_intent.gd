extends BattleEntityBehavior
class_name OnLoadEnemyAction

var enemy_entity:BattleEntity

func initialize(new_battle_entity:Node2D):
	if new_battle_entity.entity_data is EnemyData:
		enemy_entity = new_battle_entity
		new_battle_entity.entity_data.new_action_chosen.connect(_on_new_action_chosen)

func _on_new_action_chosen(enemy_action:EnemyAction):
	enemy_entity.context_panel.set_context(enemy_action.description_text)
	enemy_entity.update_icon(enemy_action.icon)
	enemy_entity.display_icon()
