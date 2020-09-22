extends CSGBox

var targetHeight = 0;
export (float) var rate = 2;

func _process(delta):

	if(!Simulator.startedAnimation): return;

	if(height >= targetHeight): return;

	height += rate * delta;
	translation.y += delta * rate / 2;
