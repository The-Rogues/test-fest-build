extends Resource
class_name CharacterData

# Used to store information on the player's in game character
@export var offensive_trait:TraitData
@export var defensive_trait:TraitData
@export var strategic_trait:TraitData
@export var backstory:String
# Used to track the character's psychological progress to feed to LLM
# Not excessive
@export var experiences:Array[String] = []

# Constructor
func _init(
			new_backstory:String,
			new_offensive_trait:TraitData,
			new_defensive_trait:TraitData,
			new_strategic_trait:TraitData) -> void:
		backstory = new_backstory
		offensive_trait = new_offensive_trait
		defensive_trait = new_defensive_trait
		strategic_trait = new_strategic_trait
