extends MeshInstance

export (int) var sizeX = 384;
export (int) var sizeZ = 384;
export (float) var heightMultiplier = 50;
export (Vector2) var mapSize = Vector2(128, 128);

export (Color, RGB) var water;
export (Color, RGB) var dirt;
export (Color, RGB) var sand;
export (Color, RGB) var grass;
export (Color, RGB) var forest;
export (Color, RGB) var ice;

var elevationNoise: OpenSimplexNoise;
var moistureNoise: OpenSimplexNoise;

func _ready():

	elevationNoise = OpenSimplexNoise.new();
	elevationNoise.seed = randi();
	elevationNoise.octaves = 8;
	# elevationNoise.lacunarity = 1.5;
	# elevationNoise.period = 20;
	# elevationNoise.persistence = 0.2;

	moistureNoise = OpenSimplexNoise.new();
	moistureNoise.seed = randi();
	moistureNoise.octaves = 5;
	# moistureNoise.lacunarity = 1.5;
	moistureNoise.period = 40;
	# moistureNoise.persistence = 0.2;

	mesh = generate();

func generate() -> Mesh:

	var planeMesh = PlaneMesh.new();
	planeMesh.size = mapSize;
	planeMesh.subdivide_width = sizeX;
	planeMesh.subdivide_depth = sizeZ;

	var mdt := MeshDataTool.new();
	var st := SurfaceTool.new();

	st.create_from(planeMesh, 0);
	mdt.create_from_surface(st.commit(), 0);

	for i in range(mdt.get_vertex_count()):
		var v = mdt.get_vertex(i);
		v.y = getHeight(v);
		# v.y = int(max(0, elevationNoise.get_noise_2d(v.x, v.z)) * heightMultiplier) % 50;
		mdt.set_vertex(i, v);
		mdt.set_vertex_color(i, getVertexColor(v));

	var arrayMesh = ArrayMesh.new();
	mdt.commit_to_surface(arrayMesh);

	st.create_from(arrayMesh, 0);
	st.generate_normals();
	mdt.create_from_surface(st.commit(), 0);

	mdt.commit_to_surface(arrayMesh);
	return arrayMesh;

func getHeight(position: Vector3) -> float:
	return max(0, elevationNoise.get_noise_2d(position.x, position.z)) * heightMultiplier;
	# return int(max(0, elevationNoise.get_noise_2d(position.x, position.z)) * heightMultiplier) / 12.0 * 20;

func getVertexColor(vertex: Vector3) -> Color:
	
	# return Color.gray;

	var height = vertex.y / heightMultiplier;
	var moisture = max(0, moistureNoise.get_noise_2d(vertex.x, vertex.z));

	if(height <= 0): return water;
	if(height < 0.011): return sand;
	if(height < 0.02 && moisture < 0.2): return dirt;

	if(height < 0.3):
		
		if(moisture < 0.2): 
			return grass;
		
		# if(moisture < 0.25):
		# 	return dirt;
		 
		return forest;

	return ice;
