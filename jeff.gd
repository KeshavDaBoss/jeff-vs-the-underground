extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -850.0

@onready var idle: Sprite2D = $Idle
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle Jump: Check if "ui_accept" (space) is pressed
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle Movement (Allows jumping while moving)
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var dir := Input.get_axis("ui_left", "ui_right")
	if dir:
		velocity.x = dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animations(direction)
	update_display()
	

	if dir == 1.00:
		idle.flip_h = false
	elif dir == -1.00:
		idle.flip_h = true

var is_dead = false

func die():
	if is_dead: return # Don't die twice!
	is_dead = true
	
	print("Jeff is dying!") # Check your 'Output' at the bottom to see this
	$AnimatedSprite2D.play("jeff_die")
	
	# Stop Jeff from moving
	velocity = Vector2.ZERO
	set_physics_process(false)
	
	# Wait 2 seconds and restart
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()


func update_animations(_direction):
	if velocity.x != 0:
		animation_player.play("jeff_run")
	else:
		animation_player.play("jeff_idle")

func update_display():
	var display = get_parent().get_node("CanvasLayer/Panel/Label")
	display.text = "Collected8 Gold: " + str(GlobalManager.col_gold)
