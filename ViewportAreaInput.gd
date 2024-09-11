extends MeshInstance3D

@onready var _viewport = $SubViewport
@onready var _area = $Area3D

var _is_mouse_inside := false
var _last_event_pos2D := Vector2()
var _last_event_time := -1.0

func _ready() -> void:
	_area.input_event.connect(_on_input_event)
	_area.mouse_entered.connect(func(): _is_mouse_inside = true)
	_area.mouse_exited.connect(func(): _is_mouse_inside = false)

func _unhandled_input(event: InputEvent) -> void:
	if event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		return
	_viewport.push_input(event)

func _on_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var quad_mesh_size: Vector2 = mesh.size

	# Event position in Area3D in world coordinate space.
	var event_pos3D := event_position
	print("event_pos3D: " + str(event_pos3D))

	# Current time in seconds since engine start.
	var now := Time.get_ticks_msec() / 1000.0

	# Convert position to a coordinate space relative to the Area3D node.
	# NOTE: `affine_inverse()` accounts for the Area3D node's scale, rotation, and position in the scene!
	event_pos3D = global_transform.affine_inverse() * event_pos3D
	print("event_pos3D: " + str(event_pos3D))

	# TODO: Adapt to bilboard mode or avoid completely.

	var event_pos2D := Vector2()

	if _is_mouse_inside:
		print("is_mouse_inside")
		# Convert the relative event position from 3D to 2D.
		event_pos2D = Vector2(event_pos3D.x, -event_pos3D.y)

		# Right now the event position's range is the following: (-quad_size/2) -> (quad_size/2)
		# We need to convert it into the following range: -0.5 -> 0.5
		event_pos2D.x = event_pos2D.x / quad_mesh_size.x
		event_pos2D.y = event_pos2D.y / quad_mesh_size.y
		# Then we need to convert it into the following range: 0 -> 1
		event_pos2D.x += 0.5
		event_pos2D.y += 0.5

		# Finally, we convert the position to the following range: 0 -> viewport.size
		event_pos2D.x *= _viewport.size.x
		event_pos2D.y *= _viewport.size.y
		# We need to do these conversions so the event's position is in the viewport's coordinate system.

	elif _last_event_pos2D != null:
		# Fall back to the last known event position.
		event_pos2D = _last_event_pos2D

	# Set the event's position and global position.
	event.position = event_pos2D
	if event is InputEventMouse:
		event.global_position = event_pos2D

	# Calculate the relative event distance.
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		# If there is not a stored previous position, then we'll assume there is no relative motion.
		if _last_event_pos2D == null:
			event.relative = Vector2(0, 0)
		# If there is a stored previous position, then we'll calculate the relative position by subtracting
		# the previous position from the new position. This will give us the distance the event traveled from prev_pos.
		else:
			event.relative = event_pos2D - _last_event_pos2D
			event.velocity = event.relative / (now - _last_event_time)

	# Update last_event_pos2D with the position we just calculated.
	_last_event_pos2D = event_pos2D

	# Update last_event_time to current time.
	_last_event_time = now

	# Finally, send the processed input event to the viewport.
	_viewport.push_input(event)
