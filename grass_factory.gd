extends Object

static func rand_bbc() -> Vector3:
	var u:float = rand_range(0,1)
	var v:float = rand_range(0,1)
	if(u + v) >= 1:
		u = 1 - u
		v = 1 - v
	
	return Vector3(u, v, 1.0 - (u + v))

static func from_bbc_Vector3(
	p_uvw:Vector3,
	p_a:Vector3,
	p_b:Vector3,
	p_c:Vector3
)-> Vector3:
	return((p_a * p_uvw.x) + (p_b * p_uvw.y) + (p_c * p_uvw.z))
	
	
static func get_orthagonal_to(p_v:Vector3) -> Vector3:
	var x:float = abs(p_v.x)
	var y:float = abs(p_v.y)
	var z: float = abs(p_v.z)
	var other:Vector3 = Vector3.FORWARD
	if x > y && x > z :
		other = Vector3.RIGHT
	elif y > z :
		other = Vector3.UP
	
	return p_v.cross(other)	
		
		
		
		 

static func quat_shortest_arc(
	p_normal_from:Vector3,
	p_normal_to:Vector3
) -> Quat:
	var dot:float = p_normal_from.dot(p_normal_to)	
	if dot > 0.999999:
		return Quat.IDENTITY
	if dot < -0.999999:
		return Quat(get_orthagonal_to(p_normal_from), PI)
	var axis:Vector3 = p_normal_from.cross(p_normal_to)
	return Quat(axis.x, axis.y, axis.z, 1 + dot).normalized()
		
	
static func triangle_area(p_a:Vector3, p_b:Vector3, p_c:Vector3)->float:
	var a:float = p_a.distance_to(p_b)
	var b:float = p_b.distance_to(p_c)
	var c:float = p_c.distance_to(p_a)
	var s:float = (a + b + c) / 2
	return sqrt(s * (s - a) * (s - b) * (s - c)) 


static func generate(
	p_mesh:Mesh,
	p_density: float,
	p_blade_width: Vector2,
	p_blade_Height:Vector2,
	p_sway_pitch:Vector2,
	p_sway_yaw:Vector2
) -> Array:
	
	if !p_mesh:
		return []
		
	var spawns:Array = []
	var surface:Array = p_mesh.surface_get_arrays(0)
	var indices:PoolIntArray = surface[Mesh.ARRAY_INDEX]
	var positions:PoolVector3Array = surface[Mesh.ARRAY_VERTEX]
	var normals:PoolVector3Array = surface[Mesh.ARRAY_NORMAL]
	
	for index in range(0, indices.size(), 3):
		var j = indices[index]
		var k = indices[index + 1]
		var l = indices[index + 2]
		var area:float = triangle_area(
			positions[j],
			positions[k],
			positions[l]
		)
		var blades_per_face:int = int(round(area * PI * p_density))
		for _i in range(0, blades_per_face):
			var uvw:Vector3 = rand_bbc()
			var position:Vector3 = from_bbc_Vector3(uvw,positions[j],positions[k],positions[l])
		
			var normal:Vector3 = from_bbc_Vector3(uvw,normals[j],normals[k],normals[l])
			var q1:Quat = Quat(Vector3.UP, deg2rad(rand_range(0, 360)))
			var q2:Quat = quat_shortest_arc(Vector3.UP, normal)
			var transform:Transform = Transform(Basis(q2 * q1), position)
			var params:Color = Color(
				rand_range(p_blade_width.x, p_blade_width.y),
				rand_range(p_blade_Height.x, p_blade_Height.y),
				deg2rad(rand_range(p_sway_pitch.x, p_sway_pitch.y)),
				deg2rad(rand_range(p_sway_yaw.x, p_sway_yaw.y))
			)
			spawns.push_back([transform, params])
	return spawns
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
