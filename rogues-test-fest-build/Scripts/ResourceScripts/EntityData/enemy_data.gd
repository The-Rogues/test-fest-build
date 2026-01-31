# Author: Fabian

# Adds additional variables for BattleEntity that is intended to be an enemy
# Also used to identify if a BattleEntity is an enemy

extends BattleEntityData
class_name EnemyData

signal new_action_chosen(enemy_action:EnemyAction)
# Added to final reward amount at the end of a battle 
@export var reward_amount:int
# Stores all possible moves the enemy can choose from and additional
# information for display
@export var move_set:Array[EnemyAction]
var next_action:EnemyAction

func choose_next_action():
	next_action = move_set.pick_random()
	new_action_chosen.emit(next_action)
