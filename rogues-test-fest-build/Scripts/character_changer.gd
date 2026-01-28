extends Control
class_name CharacterChanger
# Used to provide user a preview of the character they will play with

@onready var name_label: Label = $Background/MarginContainer/CharacterInfo/VBox/Hbox/VBox/Name
@onready var backstory_label: Label = $Background/MarginContainer/CharacterInfo/VBox/Hbox/VBox/Backstory
@onready var character_sprite: TextureRect = $Background/MarginContainer/CharacterInfo/VBox/Hbox/CharacterSprite

@onready var offensive_option: OptionButton = $Background/MarginContainer/CharacterInfo/VBox2/OffensiveTrait/Option
@onready var offensive_weight: SpinBox = $Background/MarginContainer/CharacterInfo/VBox2/OffensiveTrait/Weight
@onready var defensive_option: OptionButton = $Background/MarginContainer/CharacterInfo/VBox2/DefensiveTrait/Option
@onready var defensive_weight: SpinBox = $Background/MarginContainer/CharacterInfo/VBox2/DefensiveTrait/Weight
@onready var strategic_option: OptionButton = $Background/MarginContainer/CharacterInfo/VBox2/StrategicTrait/Option
@onready var strategic_weight: SpinBox = $Background/MarginContainer/CharacterInfo/VBox2/StrategicTrait/Weight

@onready var start_battle: Button = $StartButtonMargin/StartBattle

const TRAIT_PATH = "res://Resources/PersonalityTraits/"

# Character sprite varients
const player_varients = [
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_0.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_1.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_2.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_3.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_4.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_5.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_6.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_7.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_8.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_9.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_10.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_11.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_12.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_13.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_14.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_15.tres"),
	preload("res://Graphics/EntitySprites/RogueSprites/rogue_varient_16.tres"),
]

# Arbitrary varients
# PS: AI should not generate character names to avoid edge cases
const names = [
	"Harper",
	"Kai",
	"London",
	"Edan",
	"Zoa",
	"Enick",
	"Basil",
	"Sage",
	"Wisper",
	"Robin",
	"Ram",
	"Nado",
	"Juse",
	"Kindrid",
	"Muse",
	"Weeply",
	"Lars",
	"Krita",
	"Ash",
	"Sam",
	"Sash",
	"Eris",
	"Finch",
	"Hananiah",
	"Judas",
	"Cyrpus",
	"Shiphra",
	"Salome",
	"Erdrick",
	"Xavier",
	"Smith",
	"Brook",
	"Bridget",
]

const backstories := {
	"Brute": "Entered the tower seeking foes worthy of their strength, believing every shattered door and fallen monster proves their dominance.",
	"Valorous": "Honor bound, entered the tower after hearing that citizens from their village entered despite the warnings.",
	"Merciful": "They descend into the dungeon hoping to befriend the monsters and redeem travelers",
	"Careful": "Enticed by the tower, but weary of its dangers, they seek to satisfy their curiosity.",
	"Adaptable": "Knowing the dungeon will change them, confident that whatever happens, they will learn and adjust to survive.",
	"Masochist": "Excited when hearing about powerful monsters in the tower, they quickly arrived expecting to experience agony.",
	"Lazy": "Crossing the threshold with a single goal in mind, ascending their spirit by going through a spiritual trial.",
	"Greedy": "Entered for the promise of treasure, certain that any risk is worth the wealth buried in the dark.",
	"Clever": "They step into the dungeon with no plan at all, trusting things will turn out alright in the end."
}

func _ready() -> void:
	_on_randomize_button_up()

func _on_randomize_button_up() -> void:
	name_label.text = names.pick_random()
	
	# Randomize trait
	offensive_option.selected = randi_range(0, offensive_option.item_count - 1)
	defensive_option.selected = randi_range(0, defensive_option.item_count - 1)
	strategic_option.selected = randi_range(0, strategic_option.item_count - 1)
	# Randomize trait weight
	offensive_weight.value = randi_range(1, 10)
	defensive_weight.value = randi_range(1, 10)
	strategic_weight.value = randi_range(1, 10)
	
	# Pick backstory based on one selected trait
	var selected_traits: Array[String] = [
		offensive_option.get_item_text(offensive_option.selected),
		defensive_option.get_item_text(defensive_option.selected),
		strategic_option.get_item_text(strategic_option.selected)
	]
	
	var chosen_trait: String = selected_traits.pick_random()
	var backstory:String = backstories.get(chosen_trait)
	if backstories != null:
		backstory_label.text = backstory
	else:
		backstory_label.text = "They enter the dungeon with an uncertain past."
	# Pick random sprite varient
	character_sprite.texture = player_varients.pick_random()
	pass # Replace with function body.


func _on_start_battle_button_up() -> void:
	var offensive_trait_name = offensive_option.get_item_text(offensive_option.selected).to_lower()
	var defensive_trait_name = defensive_option.get_item_text(defensive_option.selected).to_lower()
	var strategic_trait_name = strategic_option.get_item_text(strategic_option.selected).to_lower()
	
	var offensive_trait:TraitData = load(TRAIT_PATH + offensive_trait_name + ".tres")
	var defensive_trait:TraitData = load(TRAIT_PATH + defensive_trait_name + ".tres")
	var strategic_trait:TraitData = load(TRAIT_PATH + strategic_trait_name + ".tres")
	
	offensive_trait = offensive_trait.duplicate(true)
	defensive_trait = defensive_trait.duplicate(true)
	strategic_trait = strategic_trait.duplicate(true)
	
	offensive_trait.weight = offensive_weight.value
	defensive_trait.weight = defensive_weight.value
	strategic_trait.weight = strategic_weight.value
	
	var battle_entity_data:BattleEntityData = load("res://Resources/DefaultResources/default_battle_entity_data.tres")
	battle_entity_data.name = name_label.text
	battle_entity_data.display_texture = character_sprite.texture
	
	print("Saving character data")
	print("Hello ", battle_entity_data.name)
	
	var character_data = CharacterData.new(
		backstory_label.text,
		offensive_trait,
		defensive_trait,
		strategic_trait
	)
	
	GlobalSessionManager.run_progress.character_data = character_data
	GlobalSessionManager.run_progress.character_entity_data = battle_entity_data
	start_battle.disabled = true
	GlobalSceneLoader.load_battle_scene()
	pass # Replace with function body.
