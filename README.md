# Civ
Civ on Processing

1. Download the folder and processing file into the same directory
2. Open the processing file with the processing IDE that can be downloaded from: https://processing.org/download/
3. Run the code, note: there's still many bugs.
4. If you encounter a NullPointerException, put the data folder and processing file in a new folder named "Civ"
5. You can change the size of the map by changing the integer variable "hexSize" at the top of the doc.
You can turn off fog of war by replace and finding every "redrawMap(true)" with "redrawMap(false)"
You can change whether units can sail or climb mountains by changing "sailing" and "mountaineering" to "true" at the top of the doc
You can change the number of settlers spawned by changing "i < x" on line 430
6. Current known bugs: Spawning issues, settler spawns in water or mountain or scout spawns on border of map while settler spawns off the map or units spawn behind the next turn button
Mountain icons don't spawn on mountain tiles on very high detail (very low hexSize)
Forest icons randomize every time a unit is moved

HOW TO PLAY:

Select a unit by clicking on it
Control its movement through QWEASD
Interact with settler by clicking on it. If you open its menu and move without making a choice, you'll have to press twice on the settler to open the menu again
Settle a city
Click on city to interact with it
Click on gear icon to open possible productions
Click on scout option to spawn a scout at the city, this is currently broken because I'm working on spawning a scout at the city AFTER a set number of turns instead of immediately. I can also fix the 47 scouts spawning there by implementing this too.
Press next turn to refresh movements
For each city you settle, its color changes
