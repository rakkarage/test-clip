extends Node3D

@onready var _mask = %Mask
@onready var _maskArea = %Mask/Area3D
@onready var _maskViewport = %Mask/SubViewport
@onready var _maskInterface = %Mask/SubViewport/Interface
@onready var _maskBack = %Mask/SubViewport/Interface/Back
@onready var _maskFore = %Mask/SubViewport/Interface/Fore
@onready var _masked = %Masked
@onready var _maskedArea = %Masked/Area3D
@onready var _maskedViewport = %Masked/SubViewport
@onready var _maskedInterface = %Masked/SubViewport/Interface
@onready var _maskedTop = %Masked/SubViewport/Interface/Top
@onready var _maskedBottom = %Masked/SubViewport/Interface/Bottom

func _ready() -> void:
	_maskInterface.connect("draw", _on_draw)
	_maskBack.connect("pressed", _on_Back_pressed)
	_maskFore.connect("pressed", _on_Fore_pressed)
	_maskedTop.connect("pressed", _on_Top_pressed)
	_maskedBottom.connect("pressed", _on_Bottom_pressed)

func _process(_delta: float) -> void:
	var mat = _masked.get_surface_override_material(0)
	if mat:
		mat.set_shader_parameter("mask_transform", _mask.global_transform)
		mat.set_shader_parameter("mask_size", _mask.mesh.size)

# error workaround
# "get_height: Viewport Texture must be set to use it."
# https://github.com/godotengine/godot/issues/66247#issuecomment-1738525354
# why need to setup viewport texture manually?
func _on_draw() -> void:
	print("draw")

func _on_Back_pressed() -> void:
	print("Back")

func _on_Fore_pressed() -> void:
	print("Fore")

func _on_Top_pressed() -> void:
	print("Top")

func _on_Bottom_pressed() -> void:
	print("Bottom")
