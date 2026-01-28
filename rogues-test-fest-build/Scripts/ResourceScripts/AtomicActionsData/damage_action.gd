extends AtomicAction
class_name DamageAction

@export var damage:int = 0

func execute(battle_info:BattleActionInfo):
	var final_damage:int = damage
	var user = battle_info.user
	if user is BattleEntity:
		final_damage = int(damage * user.entity_data.attack_amplifier.value)
	
	for entity in battle_info.targets:
		var battle_object = battle_info.battle_field.get_object_infront_of_player()
		if battle_object:
			if user == battle_info.get_player():
				final_damage *= battle_object.object_data.attack_amplifier
				
				if battle_object.object_data.block_player_attacks:
					battle_object.take_damage(final_damage)
					return
			else:
				if battle_object.object_data.block_enemy_attacks:
					battle_object.take_damage(final_damage)
					return
		
		entity.take_damage(final_damage)
		# Play all damage animations at once
		if battle_info.targets.size() > 1:
			continue
		# Waits for animation to finish before returning
		# Function that calls execute is also waiting for this function to finish
		# before running other functions
		await battle_info.animation_bus.play_hit(entity)
