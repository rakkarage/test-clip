extends Node3D

@onready var _camera: Camera3D = $Camera3D
@onready var _raycast: RayCast3D = $Camera3D/RayCast3D
@onready var _mask: QuadInput = %Mask
@onready var _maskBack: Button = %Mask/SubViewport/Interface/Back
@onready var _maskFore: Button = %Mask/SubViewport/Interface/Fore
@onready var _maskArea: Area3D = %Mask/Area3D
@onready var _masked: QuadInput = %Masked
@onready var _maskedArea: Area3D = %Masked/Area3D
@onready var _maskedTop: Button = %Masked/SubViewport/Interface/Top
@onready var _maskedBottom: Button = %Masked/SubViewport/Interface/Bottom

var _prev_mask_transform := Transform3D()
var _prev_mask_size := Vector2()

func _ready() -> void:
	_maskBack.connect("pressed", _on_Back_pressed)
	_maskFore.connect("pressed", _on_Fore_pressed)
	_maskedTop.connect("pressed", _on_Top_pressed)
	_maskedBottom.connect("pressed", _on_Bottom_pressed)
	_maskedArea.collision_layer = 2
	_masked.use_input_mask = true

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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_masked.is_mouse_inside_mask = _is_mouse_inside_mask()

func _is_mouse_inside_mask() -> bool:
	var mouse_pos := _camera.get_viewport().get_mouse_position()
	var ray_origin := _camera.project_ray_origin(mouse_pos)
	var ray_target := ray_origin + _camera.project_ray_normal(mouse_pos) * 1000.0
	_raycast.global_transform.origin = ray_origin
	_raycast.target_position = ray_target
	_raycast.force_raycast_update()
	return _raycast.is_colliding() and _raycast.get_collider() == _maskArea
