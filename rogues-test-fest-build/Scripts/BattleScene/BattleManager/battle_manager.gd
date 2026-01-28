extends RefCounted
class_name BattleManager

var player_entity:BattleEntity
var enemies:Array[BattleEntity]

func initialize(new_player_entity:BattleEntity, new_enemies:Array[BattleEntity]):
	player_entity = new_player_entity
	enemies = new_enemies

func execute_card(card_data:CardData, 
			action_queue:ActionQueue, 
			animation_bus:AnimationBus,
			battle_field:BattleField):
	for card_action in card_data.card_actions:
		if card_action == null:
			return
		
		var target:Array[BattleEntity] = get_action_target(card_action)
		# Only player can be the user in this case because its a card
		var battle_info:BattleActionInfo = BattleActionInfo.new(
			player_entity,
			target,
			action_queue,
			animation_bus,
			battle_field
			)
		# Queues each action to be executed sequentiallt
		for action in card_action.actions:
			action_queue.enqueue(action, battle_info)

# Resolver for targeting
func get_action_target(action_group:ActionGroup):
	var combat_entities:Array[BattleEntity]
	match action_group.targeting:
		TargetingEnum.TARGETING.PLAYER:
			combat_entities.append(player_entity)
		TargetingEnum.TARGETING.ENEMY:
			combat_entities.append(enemies.pick_random())
		TargetingEnum.TARGETING.ENEMIES:
			for enemy in enemies:
				combat_entities.append(enemy)
		TargetingEnum.TARGETING.NONE:
			pass
	
	return combat_entities
