extends Node3D

@onready var _parent = %MeshParent
@onready var _child = %MeshChild

func _process(_delta: float) -> void:
	var mat = _child.get_surface_override_material(0)
	if mat:
		var pos: Vector3 = _parent.global_transform.origin
		var size: Vector2 = _parent.mesh.size
		print("pos: ", pos)
		print("size: ", size)
		mat.set_shader_parameter("mask_position", pos)
		mat.set_shader_parameter("mask_size", size)
