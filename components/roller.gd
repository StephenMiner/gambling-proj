extends Area2D
class_name Machine
enum Outcomes {NEAR, MISS, HIT};

var probabilities : Dictionary;
var ordering : Array[Outcomes];

var processing : bool; # true if we are actively rolling
var animating : bool; # true if we are playing the animation to show the outcome
var lever : Area2D;
#var label : Label;

var displayOrder : Array;
var unlocked_slots : Array; #unused

var panels : Array[Label];
var labels : Array[String];

var lTime : int; # Used to externally track accumulated time


@export var duration : int = 2; # How many seconds the animation should play for
@export var revealDelay : float = 0.5;

var timeElapsed : float;
var frame : int;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	probabilities = {Outcomes.NEAR: 75, Outcomes.MISS: 15, Outcomes.HIT: 5}; #defaults
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
	
	if (Root.money < Root.cost):
		#probably very time inneficient, but idk if I can cache signal "vars"
		var deny : ColorRect = get_node("ColorRect");
		deny.broke.emit(); # Perhaps some redundancy here...
		return;
	processing = true;
	Root.money -= Root.cost;
	var coin : Sprite2D = get_parent().get_node("Sprite2D");
	coin.money_change.emit(); # May want to hook into this later;
	lever.use = false;
	pass;
	

func displayOutcome(outcome: Outcomes) -> void:
	
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
	
func rollResult() -> Outcomes:
	var roll : int = randi() % gen_sum(probabilities.values());
	var weight_map : Dictionary[int, Array] = chance_to_outcome();
	var sorted_weights : Array[Outcomes] = sorted_outcomes();
	for outcome in sorted_weights:
		var weight : int = probabilities[outcome];
		print("Roll: " + str(roll) + "," + Outcomes.find_key(outcome));
		roll -= weight;
		if (roll < 1):
			# Array[Outcomes]
			var options : Array = weight_map[weight];
			return options[randi() % len(options)];
	return Outcomes.MISS # This case should never come up!!

func gen_sum(ints : Array) -> int: # I saw there is lambda but the impl is ugly as hell	
	var sum : int = 0;
	#Array[ints]
	for item in ints:
		sum += item;
	return sum;
	
func playRollingAnimation() -> int:	
	if  timeElapsed > 0.025:
		for i in range(3):
			var label : Label = panels[i];
			label.text = rand_symb();
			move_child(label, get_node("Polygon2D").get_index());
		timeElapsed = timeElapsed - 0.025;
		return 1;
	return 0;

func playFinalAnimation() -> void:
	pass; # May not do anything with this;

func rand_symb() -> String:
	return labels[randi() % len(labels)];


# The reason why i maintain this is because when rolling weights
# I don't like that I can get a 49, but if two items have a weight of 50
# one is always chosen, and the next one is on 51+.
# This way I can randomize the results whenever the 50 weight item would be chosen
func chance_to_outcome()->Dictionary[int, Array]:
	# Dictionary[int, Array[Outcomes]] unsupported??? The left has gone INSANE
	var outcome_map : Dictionary[int, Array] = {};
	for key in probabilities:
		var weight : int = probabilities[key];
		if weight in outcome_map:
			outcome_map[weight].append(key);
		else: outcome_map[weight] = [key];
	return outcome_map;

#Sorted from least to greatest
func sorted_outcomes()->Array[Outcomes]:
	var sorted : Array[Outcomes] = [];
	for key in probabilities:
		sorted.append(key);
	sorted.sort_custom(sort_ascending);
	#sorted.reverse();
	return sorted;

func sort_ascending(o1, o2) -> bool:
	return probabilities[o1] < probabilities[o2];
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (processing and lTime > duration / 0.025): # Function plays once every 0.025 seconds. 
		processing = false;
		lTime = 0;
		timeElapsed = 0;
		var outcome : Outcomes = rollResult(); #sets displayOrder
		unlocked_slots = range(len(displayOrder));
		animating = true;
		print(Outcomes.find_key(outcome));
		if (outcome == Outcomes.HIT):
			Root.money += Root.payout;
			var coin : Sprite2D = get_parent().get_node("Sprite2D");
			coin.money_change.emit(); # May want to hook into this later;
		displayOutcome(outcome);
	if processing:
		lever.use = false;
		lTime += playRollingAnimation();
		timeElapsed += delta; # floating point calculation be damned
		
	pass
