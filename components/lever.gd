extends Area2D

@export var use : bool = true;
signal lever_pulled;

var mouseInside : bool;
var moving : bool = false;
var ay : float; #y-acceleration
var vy : float; #y-velocity
var originalY: float;
var maxY: float;
const maxVy : float = 500;
var ldel : float;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ay = 0;
	vy = 0;
	area_exited.connect(leave_area);
	originalY = position.y;
	maxY = originalY + 300;
	pass; # Replace with function body.

func _input(event: InputEvent) -> void:
	if not use: return;
	if mouseInside:
		if Input.is_action_pressed("leftClick"):
			var y : float = get_global_mouse_position().y;
			if y <= originalY - 1: 
				return;
			if y >= maxY:
				if use:
					lever_pulled.emit();
				print(4);
				return;
			position.y = y;
func leave_area(area: Area2D)->void:
	pass;
	

func controlling() -> bool:
	return mouseInside and Input.is_action_pressed("leftClick");

func _mouse_enter() -> void:
	mouseInside = true;
func _mouse_exit() -> void:
	mouseInside = false;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not controlling():
		vy = -100;
	if position.y + vy <= originalY:
		vy = (originalY - position.y);
	if abs(vy) < 10:
		use = true;
	position.y += vy * delta;
	pass;
