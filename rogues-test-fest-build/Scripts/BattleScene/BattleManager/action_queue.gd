extends RefCounted
class_name ActionQueue
# Stores and executes actions non-concurrently
var queue: Array[QueuedAction] = []
var processing_action:bool = false

# Adds action and associated info to the queue and tries to execute it
func enqueue(action: AtomicAction, battle_info: BattleActionInfo):
	# Creates new action to be executed soon
	queue.append(QueuedAction.new(action, battle_info))
	_check_action_queue()

func _check_action_queue():
	if processing_action or queue.is_empty():
		return
	_execute_queued_action()

func _execute_queued_action():
	processing_action = true
	var queued_action = queue.pop_front()
	# Waits until function finishes executing
	await queued_action.execute()
	processing_action = false
	_check_action_queue()
