extends RigidBody3D

# := also stores data type (in this case, float)
var mouse_sensitivity := 0.001  # Speed camera should rotate
var twist_input := 0.0          # Stores vert mouse movement
var pitch_input := 0.0          # Stores hori mouse movement

# Onready = run before _ready and then use in _ready
# $ = Access a Node and rotate it (In refference to func _unhandled_input)
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

# Runs once when the Node first loads
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Makes mouse invis


# Runs every frame
func _process(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left","move_right")               # Move on x axis ( 1.0 , -1.0 )
	input.z = Input.get_axis("move_forward","move_backward")         # Move on z axis ( 1.0 , -1.0 )
	apply_central_force(twist_pivot.basis * input * 1200.0 * delta)  # Move relative to camera
	# Note: Damp was set to 3 to make movement less floaty

	if Input.is_action_just_pressed("ui_cancel"):       # When opening menu with 'esc'
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Mouse now visible
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	# Limit how far the pivot can rotate
	pitch_pivot.rotation.x = clamp(  # clamp(input, min, max)
		pitch_pivot.rotation.x, deg_to_rad(-30), deg_to_rad(30) 
	)
	twist_input = 0.0
	pitch_input = 0.0

# Detects input not already used by other func/script
func _unhandled_input(event: InputEvent):  # (event: InputEvent) func checks inputs only
	if event is InputEventMouseMotion:     # If mouse movement...
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:   # Doesnt count if mouse in menu
			twist_input = - event.relative.x * mouse_sensitivity  # event.relative = shows how far mouse moved relative to init pos
			pitch_input = - event.relative.y * mouse_sensitivity

