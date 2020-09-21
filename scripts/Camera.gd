extends Camera

export (float) var sensibility = 1;

func _ready():
	# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	pass;

func _unhandled_input(event):

	if(event is InputEventKey):
		handleKey(event);
	elif(event is InputEventMouseMotion):
		handleMouseMotion(event);

func handleKey(event: InputEventKey):

	if(event.is_action_pressed('ui_cancel')):
		get_tree().quit();
	
	var rightStr = event.get_action_strength('ui_right');
	var leftStr = event.get_action_strength('ui_left');
	var frontStr = event.get_action_strength('ui_up');
	var backStr = event.get_action_strength('ui_down');

	var up = event.get_action_strength('fly_up');
	var down = event.get_action_strength('fly_down');

	var motion := Vector3(
		rightStr - leftStr, 
		up - down, 
		backStr - frontStr
	);

	translation = translation + motion * sensibility;

func handleMouseMotion(event: InputEventMouseMotion):
	pass;