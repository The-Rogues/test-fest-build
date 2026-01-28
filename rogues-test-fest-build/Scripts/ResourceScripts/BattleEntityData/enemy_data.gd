extends BattleEntityData
class_name EnemyData

@export var reward_amount:int
@export var move_set:Array[ActionGroup]
var next_action:ActionGroup

func choose_next_action():
	next_action = move_set.pick_random()
