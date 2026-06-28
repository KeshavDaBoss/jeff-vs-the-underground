extends Node2D
@onready var fade: ColorRect = $HUD/Fade

var level: int = 1
var current_level_root: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade.modulate.a = 1.0
	current_level_root = get_node("LevelRoot")
	await _load_level(level)



# ----------------
# LEVEL MANAGEMENT
# ----------------

func _load_level(level_number: int) -> void:
	await _fade(1.0)
	if current_level_root:
		current_level_root.queue_free()
		
	# Change Level
	var level_path = "res://scenes/level_%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)
	
	await _fade(0.0)

func _setup_level(level_root: Node) -> void:
	#Connect Exit
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
	

func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Jeff":
		level += 1
		print(level)
		await _load_level(level)
		

func _fade(to_alpha: float) -> void:
	var tween:= create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished
