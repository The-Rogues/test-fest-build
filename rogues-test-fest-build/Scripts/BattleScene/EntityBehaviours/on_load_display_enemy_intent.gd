# Author: Fabian

# Updates enemy icons to display enemy intent and context

extends EntityBehaviour
class_name OnLoadDisplayEnemyIntent

func initialize(new_entity:Entity):
	# Return if behaviour is not attached to a BattleEntity with EnemyData
	if !new_entity.entity_data is EnemyData:
		return
	
	super(new_entity)
	# Call function when entity data is initalized
	new_entity.entity_data.new_action_chosen.connect(_on_new_action_chosen)

# Updates entity's context panel and icon to display EnemyAction info
func _on_new_action_chosen(enemy_action:EnemyAction):
	entity_instance.context_panel.set_context(enemy_action.description_text)
	entity_instance.update_icon(enemy_action.icon)
	entity_instance.display_icon()
