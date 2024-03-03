extends CharacterBody3D

# Remember to set Path Height Offset to -0.5m (Some height off the ground) for it to work
@onready var navAgent: NavigationAgent3D = $NavigationAgent3D

const SPEED := 1
var player

# Runs once when the Node first loads
func _ready():
	player = get_node("../Player") # Get player

# Runs every frame
func _physics_process(delta):
	navAgent.set_target_position(player.global_transform.origin)
	velocity = (navAgent.get_next_path_position() - transform.origin) * SPEED * delta
	move_and_collide(velocity)
