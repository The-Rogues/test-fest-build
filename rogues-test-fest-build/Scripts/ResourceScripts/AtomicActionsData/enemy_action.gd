extends ActionGroup
class_name EnemyAction

enum Type {ATTACK, SUPPORT}
@export_multiline var description_text:String
@export var icon:Texture2D
@export var action_type:Type
