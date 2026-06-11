extends Area2D

var cooldown : int = 2;
var time_elapsed : float = 0.0;
var on_cooldown : bool = false;
var mouseInside : bool = false;

var label : Label;



func _input(event: InputEvent) -> void:
	if on_cooldown: return;
	if mouseInside and Input.is_action_pressed("leftClick"):
		on_cooldown = true;
		time_elapsed = 0;
		Root.blood_spilt+=1;
		self.owner.pay_bld.emit();
		pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label = get_node("Label");
	pass # Replace with function body.


func _mouse_enter() -> void:
	mouseInside = true;
func _mouse_exit() -> void:
	mouseInside = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "Fingers Spent: " + str(Root.blood_spilt);
	if on_cooldown:
		time_elapsed += delta;
		if time_elapsed >= cooldown:
			on_cooldown = false;
			time_elapsed = 0;
	pass
