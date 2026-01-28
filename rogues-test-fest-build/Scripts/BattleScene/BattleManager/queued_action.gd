extends RefCounted
class_name QueuedAction
# Used as temporary wrapper for executing an atomic action
# Is effectively a poppable dictionary entry

var action: AtomicAction
var battle_info: BattleActionInfo

func _init(new_action: AtomicAction, new_battle_info: BattleActionInfo):
	action = new_action
	battle_info = new_battle_info

func execute() -> void:
	await action.execute(battle_info)
