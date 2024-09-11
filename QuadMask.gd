extends Node3D

@onready var _mask := %Mask
@onready var _maskBack := %Mask/SubViewport/Interface/Back
@onready var _maskFore := %Mask/SubViewport/Interface/Fore
@onready var _masked := %Masked
@onready var _maskedTop := %Masked/SubViewport/Interface/Top
@onready var _maskedBottom := %Masked/SubViewport/Interface/Bottom

func _ready() -> void:
	_maskBack.connect("pressed", _on_Back_pressed)
	_maskFore.connect("pressed", _on_Fore_pressed)
	_maskedTop.connect("pressed", _on_Top_pressed)
	_maskedBottom.connect("pressed", _on_Bottom_pressed)

func _process(_delta: float) -> void:
	var mat: ShaderMaterial = _masked.get_surface_override_material(0)
	if mat:
		mat.set_shader_parameter("mask_transform", _mask.global_transform)
		mat.set_shader_parameter("mask_size", _mask.mesh.size)

func _on_Back_pressed() -> void:
	print("Back")

func _on_Fore_pressed() -> void:
	print("Fore")

func _on_Top_pressed() -> void:
	print("Top")

func _on_Bottom_pressed() -> void:
	print("Bottom")
