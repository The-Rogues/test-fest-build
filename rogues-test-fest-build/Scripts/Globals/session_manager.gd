extends Node2D
class_name SessionManager

#const DEFAULT_CHARACTER_DATA = preload("res://Resources/DefaultResources/default_character_data.tres")
#const DEFAULT_RUN_PROGRESS = preload("res://Resources/DefaultResources/default_run_progress.tres")
const DEFAULT_RUN_PROGRESS := preload(
	"res://Resources/DefaultResources/default_run_progress.tres"
)

var run_progress: RunProgress

var pending_battle_configuration:BattleSceneConfiguration

const FLOOR_1_ENEMY_POOL = preload("res://Resources/FloorEnemyPools/floor_pool_1.tres")
const FLOOR_1_SCHEMA = preload("res://Resources/DefaultResources/default_floor_object_schemas.tres")

func initialize_run():
	var template := DEFAULT_RUN_PROGRESS
	run_progress = template.duplicate(true)

	run_progress.character_data = template.character_data
	run_progress.character_entity_data = template.character_entity_data
	print(run_progress)
	print(run_progress.character_data)
	print(run_progress.character_entity_data)

func create_battle_scene_configuration():
	var enemy_group:EnemyGroup 
	#objects
	if run_progress.floor == 1:
		enemy_group = FLOOR_1_ENEMY_POOL.get_enemy_group(run_progress.floor_progress)
	# TODO: Add additional if statements for future floors 2, 3, 4
	
	var battle_config = BattleSceneConfiguration.new(
			run_progress.character_entity_data,
			enemy_group,
			FLOOR_1_SCHEMA.floor_layout_group.pick_random()
	)
	pending_battle_configuration = battle_config
	return battle_config

func get_character_sprite():
	return run_progress.character_entity_data.display_texture
