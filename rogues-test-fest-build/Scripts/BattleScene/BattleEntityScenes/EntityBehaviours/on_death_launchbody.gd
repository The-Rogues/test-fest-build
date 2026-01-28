extends BattleEntityBehavior
class_name OnDeathLaunchBody

@export var direction:Vector2
@export var bounces:int = 3
var entity_sprite:Sprite2D
const LAUNCH_BODY = preload("res://Nodes/Effects/launched_entity.tscn")

func initialize(new_battle_entity:BattleEntity):
	super(new_battle_entity)
	entity_sprite = battle_entity_instance.entity_sprite
	battle_entity_instance.defeated.connect(_on_entity_defeated)

func _on_entity_defeated(entity:BattleEntity):
	entity.entity_sprite.visible = false
	var launch_body:LaunchBody = LAUNCH_BODY.instantiate()
	launch_body.bounce_count = bounces
	entity.add_child(launch_body)
	launch_body.spawn_and_launch(entity_sprite.texture, direction)

func on_event(battle_context: BattleActionInfo) -> void:
	pass
