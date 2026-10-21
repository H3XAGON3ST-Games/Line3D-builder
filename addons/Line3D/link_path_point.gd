@tool
extends Node
class_name LinkPathPoint

@onready var path_3d: Path3D = self.get_parent()
@export var marker_3d: Marker3D

#var first_initialization: bool = true
@export var path_point_id: int = 0
	#set(value):
		#if first_initialization:
			#await self.ready
		#
		#if path_point_id < 0: 
			#path_point_id = 0
		#elif path_point_id > curve.point_count - 1:
			#path_point_id = curve.point_count - 1
		#
		#path_point_id = value

var curve
var points_count: int

func _ready() -> void:
	if path_3d == null:
		return
	
	curve = path_3d.curve
	points_count = curve.point_count
	
	#first_initialization = false


func _physics_process(delta: float) -> void:
	#if first_initialization:
		#return
	
	if points_count == null or path_3d == null or marker_3d == null:
		return
	
	if points_count < path_point_id:
		return
	
	curve.set_point_position(path_point_id, path_3d.to_local(marker_3d.global_position))
