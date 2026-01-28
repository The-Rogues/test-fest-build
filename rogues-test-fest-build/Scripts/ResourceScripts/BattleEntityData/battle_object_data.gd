extends Resource
class_name BattleObjectData

@export var display_texture:Texture2D
@export var name:String = "New Object"
@export var health:Stat
@export var is_invincible:bool
@export var block_player_attacks:bool
@export var block_enemy_attacks:bool
@export_range(0.5, 2) var attack_amplifier:float = 1
@export var interact_action:ActionGroup = null
# TODO: Add override animations
#@export var interaction_behaviour
