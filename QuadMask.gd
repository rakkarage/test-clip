extends Node3D

@onready var _mask: MeshInstance3D = %Mask
@onready var _maskBack: Button = %Mask/SubViewport/Interface/Back
@onready var _maskFore: Button = %Mask/SubViewport/Interface/Fore
@onready var _masked: MeshInstance3D = %Masked
@onready var _maskedTop: Button = %Masked/SubViewport/Interface/Top
@onready var _maskedBottom: Button = %Masked/SubViewport/Interface/Bottom

var _prev_mask_transform := Transform3D()
var _prev_mask_size := Vector2()

func _ready() -> void:
	_maskBack.connect("pressed", _on_Back_pressed)
	_maskFore.connect("pressed", _on_Fore_pressed)
	_maskedTop.connect("pressed", _on_Top_pressed)
	_maskedBottom.connect("pressed", _on_Bottom_pressed)

func _process(_delta: float) -> void:
	var mat: ShaderMaterial = _masked.get_surface_override_material(0)
	if mat:
		var current_transform = _mask.global_transform
		if not current_transform.is_equal_approx(_prev_mask_transform):
			mat.set_shader_parameter("mask_transform", current_transform)
			_prev_mask_transform = current_transform
		var current_size = _mask.mesh.size
		if not current_size.is_equal_approx(_prev_mask_size):
			mat.set_shader_parameter("mask_size", current_size)
			_prev_mask_size = current_size

func _on_Back_pressed() -> void:
	print("Back")

func _on_Fore_pressed() -> void:
	print("Fore")

func _on_Top_pressed() -> void:
	print("Top")

func _on_Bottom_pressed() -> void:
	print("Bottom")
