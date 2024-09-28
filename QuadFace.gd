class_name QuadFace extends QuadInput

@export var look_at_target: NodePath
@export var rotation_speed: float = 5.0

var target_node: Node = null

func _ready() -> void:
	super._ready()
	if look_at_target:
		target_node = get_node(look_at_target)

func _process(_delta: float) -> void:
	if target_node:
		var direction = (target_node.global_transform.origin - global_transform.origin).normalized()
		rotation_degrees = rotation_degrees.lerp(Vector3(rad_to_deg(asin(-direction.y)), rad_to_deg(atan2(direction.x, direction.z)), 0), rotation_speed * _delta)
