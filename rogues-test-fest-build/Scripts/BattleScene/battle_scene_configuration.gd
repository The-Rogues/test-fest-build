extends RefCounted
class_name BattleSceneConfiguration

# Should only be created by Battle Loader

var enemy_group:EnemyGroup
var player_data:BattleEntityData
var battle_field_schema:BattleFieldSchema

func _init(new_player_data:BattleEntityData, 
			new_enemy_group:EnemyGroup,
			new_battle_field_data:BattleFieldSchema):
	
	player_data = new_player_data
	enemy_group = new_enemy_group
	battle_field_schema = new_battle_field_data
