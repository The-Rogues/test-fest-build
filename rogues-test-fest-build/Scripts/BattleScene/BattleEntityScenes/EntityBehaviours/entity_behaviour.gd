@abstract
extends Resource
class_name BattleEntityBehavior

var battle_entity_instance:BattleEntity

func initialize(new_battle_entity:BattleEntity):
	battle_entity_instance = new_battle_entity
@abstract
func on_event(battle_context: BattleActionInfo) -> void
