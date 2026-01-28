extends Node2D
class_name BattleScene

signal new_turn_started

var battle_animation_manager: AnimationBus
var battle_manager: BattleManager
var action_queue: ActionQueue

@export var player_entity: BattleEntity
@export var play_area: CardPlayArea
@export var battle_field: BattleField
@export var energy_counter: EnergyCounter

const BATTLE_ENTITY = preload("res://Nodes/BattleScene/battle_entity_template.tscn")
const ENEMY_SPACING = 0.10
const ENEMY_Y_POSITION = 0.2

func _ready() -> void:
	if GlobalSessionManager.pending_battle_configuration:
		print("found global pending configuration")
		initialize(GlobalSessionManager.pending_battle_configuration)

func initialize(battle_configuration:BattleSceneConfiguration):
	action_queue = ActionQueue.new()
	battle_animation_manager = AnimationBus.new()
	battle_manager = BattleManager.new()
	# Load player
	player_entity.initialize(battle_configuration.player_data)
	# Load enemies
	var enemies:Array[BattleEntity]
	for enemy_data in battle_configuration.enemy_group.enemies:
		var new_enemy:BattleEntity = BATTLE_ENTITY.instantiate()
		var animator = new_enemy.get_node("EntityAnimator")
		add_child(new_enemy)
		enemies.append(new_enemy)
		new_enemy.initialize(enemy_data)
		battle_animation_manager.register(new_enemy, animator)
	
	_position_enemies(enemies)
	
	# Setup Battle Manager
	battle_manager.initialize(player_entity, enemies)
	
	# Load Battle Objects & Battle Positions
	battle_field.initialize(battle_configuration.battle_field_schema)
	battle_field.initialize_player(player_entity)
	
	# Connect signals
	new_turn_started.connect(battle_field.on_new_turn_started)
	play_area.playing_card.connect(_on_try_play_card)
	new_turn_started.emit()

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
		return
	
	var card_data:CardData = card_ui.card_data
	energy_counter.spend_energy(card_data.energy_cost)
	card_ui.queue_free()
	
	battle_manager.execute_card(card_data, 
			action_queue, 
			battle_animation_manager,
			battle_field)

func _on_end_turn_button_button_up() -> void:
	energy_counter.reset_energy()
	new_turn_started.emit()
	pass # Replace with function body.


func _on_button_button_up() -> void:
	var action = DamageAction.new()
	action.damage = 6
	var battle_info:BattleActionInfo = BattleActionInfo.new(
			null,
			[player_entity],
			action_queue,
			battle_animation_manager,
			battle_field
			)
	
	action_queue.enqueue(action, battle_info)
	pass # Replace with function body.
