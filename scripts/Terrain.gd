extends Spatial

export (PackedScene) var block;
export (Material) var grass;
export (Material) var dirt;
export (Material) var sand;
export (Material) var water;
export (Material) var ice;

export (int) var width = 64;
export (int) var depth = 64;
export (int) var layers = 1;
export (float) var blockSize = 1;

var noise: OpenSimplexNoise;

func _ready():
	
	noise = OpenSimplexNoise.new();
	noise.seed = randi();
	noise.octaves = 1;
	
	generateTerrain();

func generateTerrain():
	for layer in range(layers):
		generateLayer(layer);

func generateLayer(layer: int):
	for x in range(width):
		for z in range(depth):
			generateCell(layer, x, z);

func generateCell(layer: int, x: int, z: int):
	
	var mapPosition = Vector3(x, layer, -z);
	var worldPosition = mapPosition * blockSize;
	
	var value = noise.get_noise_3dv(mapPosition);
	if(value < -0.5): return;
	
	var cell: CSGBox = block.instance();
	cell.width = blockSize;
	cell.height = blockSize;
	cell.depth = blockSize;

	cell.material = determineCellMaterial(worldPosition);

	cell.translation = to_local(worldPosition);
	add_child(cell);

func determineCellMaterial(position: Vector3) -> Material:
	
	var cellHeight = position.y / blockSize;
	var material;
	
	if(cellHeight <= 0): material = water;
	elif(cellHeight < 1): material = sand;
	elif(cellHeight < 3): material = dirt;
	elif(cellHeight < 5): material = grass;
	elif(cellHeight < 7): material = ice;

	return material;