extends Area2D

@export var use : bool = true;
signal lever_pulled;

var roller : Area2D;
var mouseInside : bool;
var moving : bool = false;
var ay : float; #y-acceleration
var vy : float; #y-velocity
var originalY: float;
var maxY: float;
const maxVy : float = 500;
var ldel : float;

var image : Sprite2D;
var time_elapsed : float;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ay = 0;
	vy = 0;
	area_exited.connect(leave_area);
	originalY = position.y;
	maxY = originalY + 300;
	time_elapsed = 0;
	roller = get_parent().get_node("Area2D");
	image = get_node("Sprite2D");
	image.texture = load("res://icons/lever.png");
	pass; # Replace with function body.

func _input(event: InputEvent) -> void:
	if not use: return;
	if mouseInside:
		if Input.is_action_pressed("leftClick"):
			var y : float = get_global_mouse_position().y;
			if y <= originalY - 1: 
				return;
			if y >= maxY:
				position.y = maxY;
				
				if use:
					lever_pulled.emit();
					time_elapsed = 0;
				return;
				
			position.y = y;
func leave_area(area: Area2D)->void:
	pass;
	

func controlling() -> bool:
	return mouseInside and Input.is_action_pressed("leftClick") and use;

func _mouse_enter() -> void:
	mouseInside = true;
func _mouse_exit() -> void:
	mouseInside = false;
	
func calc_needed_velocity() -> float:
	var dt : float = abs(roller.duration - time_elapsed);
	var dy : float = originalY - position.y; # should be negative which is good (up)
	return dy / dt;




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not controlling():
		vy = calc_needed_velocity();
	if position.y + (vy*delta) <= originalY:
		position.y = originalY;
		vy = 0;
		use = true;
	if not use:
		time_elapsed += delta;
	if (position.y > maxY):
		position.y = maxY;
	elif (position.y < originalY):
		position.y = originalY;
	else: position.y += vy * delta;
	
	pass;
