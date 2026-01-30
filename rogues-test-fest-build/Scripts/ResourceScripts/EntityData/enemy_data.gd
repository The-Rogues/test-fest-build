extends BattleEntityData
class_name EnemyData

signal new_action_chosen(enemy_action:EnemyAction)

@export var reward_amount:int
@export var move_set:Array[ActionGroup]
var next_action:ActionGroup

func choose_next_action():
	next_action = move_set.pick_random()
	
	if next_action is EnemyAction:
		new_action_chosen.emit(next_action)
