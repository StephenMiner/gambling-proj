class_name Root;
extends Node2D

signal pay_bld;
signal roll_performed(outcome : Machine.Outcomes);

static var money : int = 100;
static var max_debt : int = -30;
static var cost : int = 10;
static var payout : int = 50;
static var blood_spilt : int = 0;

static var font : Resource = load("res://fonts/choire.pixel.ttf");
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#test_tint();
	pass # Replace with function body.


func test_tint()->void:
	for i in range(21):
		blood_spilt += 1;
		pay_bld.emit();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
