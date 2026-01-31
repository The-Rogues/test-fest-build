extends Node2D
class_name BattleScene

var battle_manager: BattleManager

@export var player_entity: BattleEntity
@onready var player_hand: CardHand = $CardLayer/PlayerHand
@export var play_area: CardPlayArea
@export var battle_field: BattleField
@export var energy_counter: EnergyCounter
@export var end_turn_button: Button
@export var battle_results_display: BattleResultLayer

const BATTLE_ENTITY = preload("res://Nodes/BattleScene/battle_entity_template.tscn")
const ENEMY_SPACING = 0.10
const ENEMY_Y_POSITION = 0.2

func _ready() -> void:
	if GlobalSceneLoader.pending_battle_configuration:
		initialize(GlobalSceneLoader.pending_battle_configuration)
		GlobalSceneLoader.pending_battle_configuration = null

func initialize(battle_configuration:BattleSceneConfiguration):
	battle_manager = BattleManager.new()
	# Load player
	player_entity.initialize(battle_configuration.player_data)
	# Load enemies
	var enemies:Array[BattleEntity]
	for enemy_data in battle_configuration.enemy_group.enemies:
		var new_enemy:BattleEntity = BATTLE_ENTITY.instantiate()

		add_child(new_enemy)
		enemies.append(new_enemy)
		new_enemy.initialize(enemy_data)
	
	_position_enemies(enemies)
	
	# Setup Battle Manager
	battle_manager.initialize(player_entity, enemies, battle_field)
	
	# Load Battle Objects & Battle Positions
	battle_field.initialize(battle_configuration.battle_field_schema)
	battle_field.initialize_player(player_entity)
	
	# Connect signals
	play_area.playing_card.connect(_on_try_play_card)
	battle_manager.started_new_turn.connect(_started_player_turn)
	battle_manager.battle_ended.connect(_on_battle_ended)
	battle_results_display.visible = true
	await battle_results_display.fade_out()
	_started_player_turn()

func _position_enemies(enemies:Array[BattleEntity]):
	if enemies.is_empty():
		return
		
	var viewport_size = get_viewport_rect().size
	var center_x = viewport_size.x / 2.0
	var y = viewport_size.y * ENEMY_Y_POSITION
	
	var spacing = viewport_size.x * ENEMY_SPACING
	var count = enemies.size()
	var total_width = (count - 1) * spacing
	var start_x = center_x - total_width / 2.0
	
	if enemies.size() == 1:
		enemies[0].global_position = Vector2(center_x, y)
		return
	
	for i in range(0, enemies.size()):
		enemies[i].global_position = Vector2(start_x + i * spacing, y)

func _on_try_play_card(card_ui:CardUI):
	if !energy_counter.can_play_card(card_ui.card_data):
		card_ui.return_card_to_hand()
		player_hand.update_drawn_cards_position()
		return
	
	var card_data:CardData = card_ui.card_data
	energy_counter.spend_energy(card_data.energy_cost)
	card_ui.queue_free()
	
	battle_manager.execute_card(card_data)

func _on_end_turn_button_button_up() -> void:
	end_turn_button.disabled = true
	battle_manager.end_player_turn()
	player_hand.clear_hand()
	pass # Replace with function body.

func _started_player_turn():
	battle_field.on_new_turn_started()
	energy_counter.reset_energy()
	end_turn_button.disabled = false
	for i in range(0, 5):
		_on_add_card_button_up()

func _on_battle_ended(player_won:bool):
	player_hand.visible = false
	end_turn_button.visible = false
	if player_won:
		await get_tree().create_timer(3).timeout
		battle_results_display.set_result(player_won, 
				player_entity, 
				battle_manager.enemies)
	else:
		await player_entity.entity_animator.animation_finished
		battle_results_display.set_result(player_won, 
				player_entity, 
				battle_manager.enemies)

func _on_button_button_up() -> void:
	var action = DamageAction.new()
	action.damage = 20
	var action_info = battle_manager.create_action_info(null, [player_entity])
	battle_manager.action_queue.enqueue(action, action_info)
	pass # Replace with function body.


func _on_test_enemy_damage_button_up() -> void:
	var action = DamageAction.new()
	action.damage = 20
	var entity = battle_manager.living_enemies.pick_random()
	if !entity:
		return
	
	if entity.is_defeated:
		return
	var action_info = battle_manager.create_action_info(null, [entity])
	battle_manager.action_queue.enqueue(action, action_info)
	pass # Replace with function body.


func _on_add_card_button_up() -> void:
	var deck:CardDeck = load("res://Resources/DefaultResources/default_card_deck.tres")
	var card_data = deck.deck.pick_random()
	player_hand.draw_card(card_data)
	pass # Replace with function body.


func _on_win_button_up() -> void:
	for enemy in battle_manager.enemies:
		enemy.kill()
	pass # Replace with function body.
