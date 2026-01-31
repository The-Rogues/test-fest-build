extends RefCounted
class_name BattleManager

signal battle_ended(player_won:bool)
signal started_new_turn

enum BattleState { PLAYER_TURN, ENEMY_TURN, ENDED }

var battle_state:BattleState = BattleState.PLAYER_TURN
var player_entity:BattleEntity
var enemies:Array[BattleEntity]
var living_enemies:Array[BattleEntity]
var action_queue:ActionQueue
var battle_field:BattleField

func initialize(new_player_entity:BattleEntity, 
			new_enemies:Array[BattleEntity],
			new_battle_field:BattleField):
	player_entity = new_player_entity
	
	enemies = new_enemies.duplicate(true)
	for enemy in enemies:
		living_enemies.append(enemy)
	battle_field = new_battle_field
	
	action_queue = ActionQueue.new()
	#animation_bus = AnimationBus.new()
	
	for enemy in enemies:
		var animator = enemy.get_node("EntityAnimator")
		enemy.defeated.connect(_on_entity_defeated)
		
		if enemy.entity_data is EnemyData:
			enemy.entity_data.choose_next_action()
	
	player_entity.defeated.connect(_on_entity_defeated)

func end_player_turn() -> void:
	if battle_state != BattleState.PLAYER_TURN:
		return
	
	battle_state = BattleState.ENEMY_TURN
	await _run_enemy_turn()

func _run_enemy_turn() -> void:
	for enemy in enemies:
		if enemy.entity_data is EnemyData:
			enemy.hide_icon()
			var target:Array[BattleEntity] = get_action_target(
					enemy.entity_data.next_action, enemy)
			var action_info:BattleActionInfo = create_action_info(enemy, target)
			var next_action:EnemyAction = enemy.entity_data.next_action
			for action in next_action.actions:
				if next_action.action_type == EnemyAction.Type.ATTACK:
					enemy.entity_animator.play("battle_entity/attack")
				elif next_action.action_type == EnemyAction.Type.SUPPORT:
					enemy.entity_animator.play("battle_entity/heal")
				await enemy.entity_animator.animation_finished
				action_queue.enqueue(action, action_info)
	
	battle_state = BattleState.PLAYER_TURN
	_start_player_turn()

func _start_player_turn():
	if battle_state != BattleState.PLAYER_TURN:
		return
	
	for enemy in enemies:
		if enemy.entity_data is EnemyData:
			enemy.entity_data.choose_next_action()
	
	started_new_turn.emit()

func execute_card(card_data:CardData):
	for card_action in card_data.card_actions:
		if card_action == null:
			return
		
		var target:Array[BattleEntity] = get_action_target(card_action)
		# Only player can be the user in this case because its a card
		var action_info:BattleActionInfo = create_action_info(player_entity, target)
		# Queues each action to be executed sequentiallt
		for action in card_action.actions:
			action_queue.enqueue(action, action_info)

func _on_entity_defeated(battle_entity:BattleEntity):	
	var enemies_defeated:bool = true
	if player_entity.is_defeated:
		battle_ended.emit(false)
		return
	
	if battle_entity in enemies:
		living_enemies.erase(battle_entity)
	
	if living_enemies.is_empty():
		battle_ended.emit(true)

# Resolver for targeting
func get_action_target(action_group:ActionGroup, user:BattleEntity = null):
	var combat_entities:Array[BattleEntity]
	match action_group.targeting:
		TargetingEnum.TARGETING.SELF:
			combat_entities.append(user)
		TargetingEnum.TARGETING.PLAYER:
			combat_entities.append(player_entity)
		TargetingEnum.TARGETING.ENEMY:
			combat_entities.append(living_enemies.pick_random())
		TargetingEnum.TARGETING.ENEMIES:
			for enemy in living_enemies:
				combat_entities.append(enemy)
		TargetingEnum.TARGETING.NONE:
			pass
	
	return combat_entities

func create_action_info(user:BattleEntity, target:Array[BattleEntity]):
	var battle_info:BattleActionInfo = BattleActionInfo.new(
		user,
		target,
		action_queue,
		#animation_bus,
		battle_field
	)
	return battle_info
