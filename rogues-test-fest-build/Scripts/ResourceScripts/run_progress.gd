# Stores game information that can be saved and reloaded
# Also accessed throughout the game to update player progess
extends Resource
class_name RunProgress

# TODO: Add items and deck fields
@export var character_entity_data:BattleEntityData
@export var character_data:CharacterData
@export var floor_progress:int = 1
@export var floor:int = 1
@export var experience_log:Array[String]
var run_map: MapManager
var gold:int = 0
