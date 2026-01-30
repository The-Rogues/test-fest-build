@abstract
extends Resource
class_name BattleEntityBehavior

var battle_entity_instance:Node2D

func initialize(new_battle_entity:Node2D):
	battle_entity_instance = new_battle_entity
