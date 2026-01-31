# Author: Fabian

# Used to store additional data for ObjectEntity class

extends EntityData
class_name BattleObjectData

# Used by MoveSearch Action to find objects in battlefield that provide a 
# TYPE of benefit
enum Type {NONE, COVER, TREASURE, WEAPON}
@export var object_type:Type

@export var is_invincible:bool
# When player plays an attack card, this object can block it and 
# take damage instead
@export var block_player_attacks:bool
# When an enemy attacks the player character, this is checked to determine if
# is protected
@export var block_enemy_attacks:bool
@export var damaged_by_launch_body:bool 
# Used in DamageAction to calculate damage
@export_range(0.5, 2) var attack_amplifier:float = 1
