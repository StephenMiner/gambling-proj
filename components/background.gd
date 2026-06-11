extends Sprite2D

enum States {NEUTRAL, HAPPY, MAD};

var state : States;
var default_state : States;
var revert : bool = false;

var duration : float;
var time_elapsed : float;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_state = States.NEUTRAL;
	state = default_state;
	update_image();
	var coin = get_parent().get_node("Sprite2D");
	coin.money_change.connect(money_check);
	self.owner.pay_bld.connect(blood_check);
	self.owner.roll_performed.connect(roll_check);
	pass # Replace with function body.

func money_check()->void:
	if (Root.money > 0 and state != States.NEUTRAL):
		default_state = States.NEUTRAL;
		state = default_state;;
		
	if (Root.money <= 0 and state != States.MAD):
		default_state = States.MAD;
		state = default_state;
		revert = false;
		update_image();

func blood_check()->void:
	revert = true;
	duration = 4;
	time_elapsed = 0;
	if (state == States.HAPPY):
		return;
	state = States.HAPPY
	update_image();

func roll_check(outcome : Machine.Outcomes)->void:
	if (outcome != Machine.Outcomes.HIT): return;
	time_elapsed = 0;
	duration = 6;
	revert = true;
	if (state == States.HAPPY):
		return;
	state = States.HAPPY;
	update_image();

func update_image()->void:
	if state == States.NEUTRAL:
		self.texture = load("res://icons/pretty_neutral.png");
	elif state == States.HAPPY:
		self.texture = load("res://icons/pretty_happy.png");
	elif state == States.MAD:
		self.texture = load("res://icons/pretty_angry.png");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if revert:
		if (time_elapsed > duration):
			revert = false;
			state = default_state;
			time_elapsed = 0;
			update_image();
		time_elapsed += delta;
	pass
