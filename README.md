Making this in VIM so dont mind the formatting  
  
# What is happening
service\_denial\.gd:  
Just adding a short color pulse for feedback that you dont have enough
money  
  
roller\.gd:  
I have code in mind I want to write to implement the probabilities (and
        allow them to be dynamic), just need to write it.  

The stuff already there just dictates the actual slot machine
functionality. It merges both the graphical functions and logical
functions.  
  
coin\.gd:  
Right now, this just controls the coin image display and the money counter.
Don't think I will do anything else with this.  
  
lever\.gd:  
Self explanatory, controls the function of the lever that gets pulled to
run the slot machine. It emits a signal that roller\.gd listens for. This
script's functionality can also be blocked while roller\.gd is rolling a
result as well.  
  
tinter\.gd:  
Probably need to adjust the pulsating, but the stuff here just gives me a
way to toggle a pulsating red overlay on the screen.
  
root\.gd:  
Just using this as a dump script for any globals I want. So far, "money"
and "cost" (cost to roll slots) are stored here. Note that these values are
not constants.  
