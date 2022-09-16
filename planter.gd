tool
extends MultiMeshInstance

const meshFactory = preload("res://mesh_factory.gd")
const grassFactory = preload("res://grass_factory.gd")


export(float) var density:float = 1.0 setget set_density
export(Vector2) var width = Vector2(0.01, 0.02) setget set_width
export(Vector2) var height = Vector2(0.04, 0.08) setget set_height
export(Vector2) var sway_yaw = Vector2(0.0, 10.0) setget set_sway_yaw
export(Vector2) var sway_pitch = Vector2(0.0, 10.0) setget set_sway_pitch
export(Mesh) var mesh:Mesh = null setget set_mesh


func _init():
	rebuild()

func _ready():
	rebuild()


func rebuild():
	if !multimesh:
		multimesh = MultiMesh.new()
	
	multimesh.instance_count = 0
	
	var spawns:Array = grassFactory.generate(
		mesh,
		density,
		width,
		height,
		sway_pitch,
		sway_yaw
	)
	if spawns.empty():
		return
	
	multimesh.mesh = meshFactory.simple_grass()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.set_custom_data_format(MultiMesh.CUSTOM_DATA_FLOAT)
	multimesh.set_color_format(MultiMesh.COLOR_NONE)
	multimesh.instance_count = spawns.size()
	
	for index in multimesh.instance_count:
		var spawn:Array = spawns[index]
		multimesh.set_instance_transform(index, spawn[0])
		multimesh.set_instance_custom_data(index, spawn[1])
	
	
func set_density(p_density):
	density = p_density
	if density < 1.0:
		density = 1.0
	rebuild()
	
func set_width(p_width):
	width = p_width
	rebuild()
	
func set_height(p_height):
	height = p_height
	rebuild()
	
func set_sway_yaw(p_sway_yaw):
	sway_yaw = p_sway_yaw
	rebuild()
	
func set_sway_pitch(p_sway_pitch):
	sway_pitch = p_sway_pitch
	rebuild()
	
func set_mesh(p_mesh):
	mesh = p_mesh
	rebuild()	
	
	








