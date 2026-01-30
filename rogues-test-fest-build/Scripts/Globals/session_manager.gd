# Intended to be used as a global object for managing
# the storage & loading of persistent data using a RunProgress resource
# Used to store player character info and game progress

# Author: Fabian
# Editors: Fletcher

extends Node2D
class_name SessionManager

const DEFAULT_RUN_PROGRESS := preload(
	"res://Resources/DefaultResources/default_run_progress.tres"
)
# Stores reloadable information on game progress and the player's character
var run_progress: RunProgress

# run_map moved to run_progress
# Fletcher - Add data member to hold the game session's map manager.
# var run_map: MapManager

func initialize_run():
	var template := DEFAULT_RUN_PROGRESS
	run_progress = template.duplicate(true)

	run_progress.character_data = template.character_data
	run_progress.character_entity_data = template.character_entity_data

func reset_progress():
	initialize_run()

func update_character_health(new_value:int):
	run_progress.character_entity_data.health.value = new_value

func get_character_entity():
	return run_progress.character_entity_data

func get_floor_progress():
	return run_progress.floor_progress

func get_current_floor():
	return run_progress.floor

func add_gold(amount:int):
	run_progress.gold += amount

func get_character_sprite():
	return run_progress.character_entity_data.display_texture
