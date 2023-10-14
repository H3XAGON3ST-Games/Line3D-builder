@tool
extends Node3D

# Fork of the project Godot-3D-Line-Renderer by ApocalypticPhosphorus
#
# MIT License
# Copyright (c) 2023 H3XAGON3ST
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

@export_category("Line Property")
@export_range(0.005, 20) var line_radius: float = 0.1 :
	set(value):
		if (line_radius != value):
			line_radius = value
			_update_line()

@export_range(0.005, 10) var radius_multiplier: float = 1 :
	set(value):
		if (radius_multiplier != value):
			radius_multiplier = value
			_update_line()

@export_range(4, 30) var line_resoultion: int = 8 :
	set(value):
		if (line_resoultion != value):
			line_resoultion = value
			_update_line()

@export_node_path("Path3D") var path: 
	set(value):
		if (path != value):
			path = value
			_update_line()

@onready var csg_polygon := $CSGPolygon3D

func _update_line() -> void:
	csg_polygon = get_node_or_null(^"CSGPolygon3D") if typeof(csg_polygon) == TYPE_NIL else csg_polygon
	
	if path == null or csg_polygon == null:
		return
	
	if !path.is_empty() and csg_polygon.path_node.is_empty():
		csg_polygon.path_node = get_fix_node_path(path)
	
	if path.is_empty() and !csg_polygon.path_node.is_empty():
		csg_polygon.path_node = NodePath("")
	
	if !path.is_empty() and !csg_polygon.path_node.is_empty():
		var circle = PackedVector2Array()
		for degree in line_resoultion:
			var x = (line_radius * radius_multiplier) * sin(PI * 2 * degree / line_resoultion)
			var y = (line_radius * radius_multiplier) * cos(PI * 2 * degree / line_resoultion)
			var coords = Vector2(x,y)
			circle.append(coords)
		csg_polygon.polygon = circle

func get_fix_node_path(nodepath: NodePath) -> NodePath: # To fix the path to local to the parent
	return NodePath("../" + nodepath.get_name(0))
