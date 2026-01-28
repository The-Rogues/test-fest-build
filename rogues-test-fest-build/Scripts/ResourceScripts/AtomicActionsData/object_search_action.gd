extends AtomicAction
class_name ObjectSearchAction

@export var object_name:String

func execute(battle_info:BattleActionInfo):
	var steps:int = battle_info.battle_field.get_player_distance_to_object(object_name)
	if steps != 9:
		battle_info.battle_field.move_player(steps)
		await battle_info.battle_field.moved_position
	else:
		print("Object not found: ", object_name)
