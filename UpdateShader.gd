extends Node3D

@onready var _mask = %Mask
@onready var _masked = %Masked

func _process(_delta: float) -> void:
	var mat = _masked.get_surface_override_material(0)
	if mat:
		var t: Transform3D = _mask.global_transform
		var s: Vector2 = _mask.mesh.size
		print("pos: ", t)
		print("size: ", s)
		mat.set_shader_parameter("mask_transform", t)
		mat.set_shader_parameter("mask_size", s)
