extends AtomicAction
class_name DebuffAction
enum Weaken_Stat {ATTACK, DEFENSE}
enum Multiplier {XHalf, XQuarter}
@export var weaken_stat:Weaken_Stat
@export var multiplier:Multiplier

func execute(battle_info:BattleActionInfo):
	var multiplier_value:float
	match  multiplier:
		Multiplier.XHalf:
			multiplier_value = -0.5
			pass
		Multiplier.XQuarter:
			multiplier_value = -0.25
			pass
	
	for target in battle_info.targets:
		if weaken_stat == Weaken_Stat.ATTACK:
			target.debuff_attack(multiplier_value)
		elif weaken_stat == Weaken_Stat.DEFENSE:
			target.debuff_defense(multiplier_value)
