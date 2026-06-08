extends Area2D

enum Outcomes {NEAR, MISS, HIT};

var probabilities : Dictionary;
var ordering : Array[Outcomes];

var processing : bool;
var lever : Area2D;
#var label : Label;

var panels : Array[Label];
var labels : Array[String];

var lTime : int; # Used to externally track accumulated time


const duration : int = 5; # How many seconds the animation should play for
const revealDelay : int = 2;
const COST : int = 250;
var timeElapsed : float;
var frame : int;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	probabilities = {Outcomes.NEAR: 0.75, Outcomes.MISS: 0.15, Outcomes.HIT: 0.5};
	ordering = [Outcomes.HIT, Outcomes.MISS, Outcomes.NEAR];
	processing = false;
	lever = get_parent().get_node("Handle");
	panels.resize(3);
	for i in range(1,4):
		var label : Label = get_node("Panel" + str(i));
		label.add_theme_color_override("font_color", Color.BLACK);
		panels[i-1] = label;
	timeElapsed = 0;
	frame = 0;
	lTime = 0;
	labels = ["A", "B", "C", "D", "E", "F", "G"];
	lever.lever_pulled.connect(pullLever);
	pass # Replace with function body.


func pullLever() -> void:
	if processing: return;
	processing = true;
	print(10);
	lever.use = false;
	pass;
	

func displayOutcome(outcome: Outcomes) -> void:
	var displayOrder : Array;
	var diff : int = randi() % 3;
	var diff1 : int = randi() % 3;
	var diff2 : int = randi() % 3;
	while (diff == diff1): # The only time I ever wished I had do-while
		diff1 = randi() % 3;
	while (diff2 == diff1 || diff2 == diff): # Efficiency be damned
		diff2 = randi() % 3;
	displayOrder = [diff, diff1, diff2];
	var pool : Array = labels.duplicate();
	pool.shuffle();
	pool.shuffle();
	match(outcome):
		Outcomes.NEAR:
			panels[displayOrder[0]].text = pool[0];
			panels[displayOrder[1]].text = pool[0];
			panels[displayOrder[2]].text = pool[1];
		Outcomes.MISS:
			panels[displayOrder[0]].text = pool[0];
			panels[displayOrder[1]].text = pool[1];
			panels[displayOrder[2]].text = pool[2];
			pass;
		Outcomes.HIT: 
			panels[displayOrder[0]].text = pool[0];
			panels[displayOrder[1]].text = pool[0];
			panels[displayOrder[2]].text = pool[0];
			pass;
	
func rollResult() -> void:
	var roll : int = randi() % 1000;
	for key in probabilities:
		var chance : float = probabilities[key];
	
func playAnimation() -> int:	
	if  timeElapsed > 0.025:
		for i in range(3):
			var label : Label = panels[i];
			label.text = rand_symb();
			move_child(label, get_node("Polygon2D").get_index());
		timeElapsed = 0;
		return 1;
	return 0;
	

func rand_symb() -> String:
	return labels[randi() % len(labels)];

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (processing and lTime > duration / 0.025): # Function plays once every 0.025 seconds. 
		processing = false;
		lTime = 0;
		var outcome : Outcomes = ordering[randi() % 3];
		print(Outcomes.find_key(outcome));
		displayOutcome(outcome);
	if processing:
		lever.use = false;
		lTime += playAnimation();
		timeElapsed += delta; # floating point calculation be damned
		
	pass
