extends CharacterBody2D

@export var speed: float = 60.0
@export var gravity: float = 900.0

var direction: int = 1

@onready var sprite = $AnimatedSprite2D
@onready var ledge_check = $LedgeCheck

func _physics_process(delta: float):
	# 1. Apply Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Ledge/Wall Detection
	# If we hit a wall OR the RayCast isn't hitting floor, turn around
	if is_on_wall() or not ledge_check.is_colliding():
		direction *= -1
		ledge_check.position.x *= -1 # Move the sensor to the new "front"
		sprite.flip_h = (direction == -1)

	# 3. Apply Velocity
	velocity.x = direction * speed
	move_and_slide()
	sprite.play("walk")

# Connect the Area2D (Hitbox) "body_entered" signal to this:


func skeleton_die(player):
	player.velocity.y = -300 # Bounce Jeff up
	queue_free()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	# We check if the thing that touched the skeleton is named Jeff
	if body.name == "Jeff":
		# We call the 'die' function inside Jeff's script
		if body.has_method("die"):
			body.die()
