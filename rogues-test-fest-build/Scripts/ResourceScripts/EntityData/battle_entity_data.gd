extends Resource
class_name BattleEntityData

@export var display_texture:Texture2D
@export var name:String
@export var health:Stat
var defense_amplifier:Stat = preload("res://Resources/DefaultResources/default_amplifier_stat.tres")
var attack_amplifier:Stat = preload("res://Resources/DefaultResources/default_amplifier_stat.tres")
@export var behaviours:Array[BattleEntityBehavior]
