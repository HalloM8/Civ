/* TO DO:
Bug where spawning on edge of map still exists
Fix bug where forest tiles randomize every move, caused by fog of war
Fix unitGUI by figuring out which hexes to display as options
Fix inconsistent mountain icons on tiles - No idea
Distribute resources and generate yields through noise
Finish GUI - Also improve GUI Graphics, maybe polyart design?
Better terrain generation - Usage of noise for forest type generation and random dirt pillar generation
Add Ruins
Add Music
Add Zoom
Add Techs
Add Combat System
Add a ton of units, likely implemented through a csv file
Hotseat Multiplayer, enjoy indexing everything.
You won't make it this far lol but if you do incredible job
If you get this project finished: Try animation, which may end horribly
*/

// Settings

boolean showWaves = true;

float scaleFactor = 1;
float translateX = 0;
float translateY = 0;

// Techs

ArrayList<String> possibleBuilds = new ArrayList<String>();
ArrayList<Integer> possibleBuildTimes = new ArrayList<Integer>();
String era = "ancient";
boolean mountaineering = false;
boolean sailing = false;

boolean unitSelected = false;
int unitSel = 0;
boolean buildingSelected = false;
int buildingSel = 0;


// Hex Data

ArrayList<Integer> xHexes = new ArrayList<Integer>();
ArrayList<Integer> yHexes = new ArrayList<Integer>();
ArrayList<Integer> sizes = new ArrayList<Integer>();
ArrayList<String> hexTypes = new ArrayList<String>();
ArrayList<Boolean> hexVisible = new ArrayList<Boolean>();

ArrayList<Integer> forestRandTypes = new ArrayList<Integer>();
int forestRandCounter = 0;

ArrayList<Integer> xPosS = new ArrayList<Integer>();
ArrayList<Integer> yPosS = new ArrayList<Integer>();
ArrayList<Integer> movements = new ArrayList<Integer>();
ArrayList<Integer> totalMovements = new ArrayList<Integer>();
ArrayList<String> units = new ArrayList<String>();
ArrayList<Integer> visibilities = new ArrayList<Integer>();

int[] iconXPosS = {0,0,0,0,0};
int[] iconYPosS = {0,0,0,0,0};
String[] iconTypes = {"","","","",""};

ArrayList<Integer> prodChoiceXPosS = new ArrayList<Integer>();
ArrayList<Integer> prodChoiceYPosS = new ArrayList<Integer>();
ArrayList<String> prodChoiceTypes = new ArrayList<String>();

ArrayList<Integer> buildingXPosS = new ArrayList<Integer>();
ArrayList<Integer> buildingYPosS = new ArrayList<Integer>();
ArrayList<String> buildingTypes = new ArrayList<String>();
ArrayList<String> buildingColor = new ArrayList<String>();
color[] cityColors = {#ff0000, #ffa500, #ffff00, #008000, #0000ff, #4b0082, #ee82ee};
int cityColor = 0;

PFont civFont;

int hexSize = 20;
int mouseThreshold = 25;
int randomHex;
int xPos;
int yPos;
int xSize;
int ySize;

String[] allActions = {"settleCity", "sleep", "rangedAttack", "meleeAttack", "fortify"};
String[] settlerActions = {"settleCity", "sleep"};

boolean settlerGUI = false;
boolean cityGUI = false;
boolean popGUI = false;
boolean prodGUI = false;

float noiseScale = 0.003;
float unitScale = 1.5;
float decScale = 2;
float iconScale = 1.5;

int coins = 0;
float sciencePT = 0;
float coinsPT = 0;

PImage deepOceanImg;
PImage oceanImg;
PImage seaImg;
PImage grassImg;
PImage beachImg;
PImage forestImg1;
PImage forestImg2;
PImage forestImg3;
PImage forestImg4;
PImage mountainImg;
PImage snowImg;
PImage cloudImg;

PImage ancientSeImg;

PImage ancientSeIcon;

PImage scoutImg;
PImage settlerImg;

PImage scoutIcon;
PImage settlerIcon;

PImage nextTurn;
PImage settleCityImg;

PImage scienceImg;
PImage coinImg;

PImage popIcon;
PImage prodIcon;

// Backup Colors

// Low to High
color deepOcean = #016a86;
color ocean = #006994;
color sea = #20b2aa;
color beach = #fdd8b5;
// color ocean = #016a86;
// color sea = #016a86;

color grass = #27ae60;
color forest = #27ae60;
// color forest = #7cfc00;
color mountain = #bfaaa1;
color snow = #ffffff;
color cloud = #87ceeb;
color[] colors = {deepOcean,ocean,sea,beach,grass,forest,mountain,snow,cloud};
String[] nonSpawns = {"deepOcean","ocean","sea","mountain","snow"};

void drawMap() {
  float xChange = 1.722;
  float yChange = 5.98;
  for (int y = 0; y < ySize/hexSize; y++) {
    for (int x = 0; x < xSize/hexSize; x++) {
      if (x % 2 == 1) {
        if (x*hexSize*xChange <= width+hexSize && y*hexSize*yChange <= height) {
          plotHex(x*hexSize*xChange, y*hexSize*yChange);
          xHexes.add(int(x*hexSize*xChange));
          yHexes.add(int(y*hexSize*yChange));
        }
      } else {
        if (x*hexSize*xChange <= width+hexSize && y*hexSize*yChange <= height) {
          plotHex(x*hexSize*xChange, y*hexSize*yChange+(hexSize*3));
          xHexes.add(int(x*hexSize*xChange));
          yHexes.add(int(y*hexSize*yChange+(hexSize*3)));
        }
      }
      hexVisible.add(false);
    }
  }
}

void redrawMap(boolean seeAll) {
  for (int i = 0; i < xHexes.size(); i++) {
    if (hexVisible.get(i) == true || seeAll == true) {
      if (hexTypes.get(i) == "deepOcean") {
        fill(deepOcean);
        drawHex(xHexes.get(i), yHexes.get(i), hexSize);
        image(deepOceanImg, xHexes.get(i), yHexes.get(i));
      }
      if (hexTypes.get(i) == "ocean") {
        fill(ocean);
        drawHex(xHexes.get(i), yHexes.get(i), hexSize);
        image(oceanImg, xHexes.get(i), yHexes.get(i));
      }
      if (hexTypes.get(i) == "sea") {
        fill(sea);
        drawHex(xHexes.get(i), yHexes.get(i), hexSize);
        image(seaImg, xHexes.get(i), yHexes.get(i));
      }
      if (hexTypes.get(i) == "beach") {
        fill(beach);
        drawHex(xHexes.get(i), yHexes.get(i), hexSize);
        image(beachImg, xHexes.get(i), yHexes.get(i));
      }
      if (hexTypes.get(i) == "grass") {
        fill(grass);
        drawHex(xHexes.get(i), yHexes.get(i), hexSize);
        image(grassImg, xHexes.get(i), yHexes.get(i));
      }
      if (hexTypes.get(i) == "forest") {
        fill(forest);
        drawHex(xHexes.get(i), yHexes.get(i), hexSize);
        if (forestRandTypes.get(forestRandCounter) == 0) {
          image(forestImg1, xHexes.get(i), yHexes.get(i));
        } else if (forestRandTypes.get(forestRandCounter) == 1) {
          image(forestImg2, xHexes.get(i), yHexes.get(i));
        } else if (forestRandTypes.get(forestRandCounter) == 2) {
          image(forestImg3, xHexes.get(i), yHexes.get(i));
        } else { 
          image(forestImg4, xHexes.get(i), yHexes.get(i));
        }
      }
      if (hexTypes.get(i) == "mountain") {
        fill(mountain);
        drawHex(xHexes.get(i), yHexes.get(i), hexSize);
        image(mountainImg, xHexes.get(i), yHexes.get(i));
      }
      if (hexTypes.get(i) == "snow") {
        fill(snow);
        drawHex(xHexes.get(i), yHexes.get(i), hexSize);
        image(snowImg, xHexes.get(i), yHexes.get(i));
      }
    } else {
      fill(cloud);
      image(cloudImg, xHexes.get(i), yHexes.get(i));
    }
  }
  for (int i = 0; i < buildingXPosS.size(); i++) {
    if (buildingTypes.get(i) == "city") {
      if (era == "ancient") {
        tint(unhex(buildingColor.get(i)));
        image(ancientSeImg, buildingXPosS.get(i), buildingYPosS.get(i));
        noTint();
      }
    }
  }
  forestRandCounter = 0;
}

void plotHex(float x, float y) {
  float v = noise(x * noiseScale, y * noiseScale);
  if (v < 0.05) {
    hexTypes.add("deepOcean");
  } else if (v < 0.1) {
    hexTypes.add("ocean");
  } else if (v < 0.3) {
    hexTypes.add("sea");
  } else if (v < 0.32) {
    hexTypes.add("beach");
  } else if (v < 0.4) {
    hexTypes.add("grass");
  } else if (v < 0.6) {
    hexTypes.add("forest");
  } else if (v < 0.9) {
    hexTypes.add("mountain");
  } else if (v < 0.95)  {
    hexTypes.add("snow");
  }
}

void drawHex(float x, float y, float gs) {
  beginShape();
  for (float a = PI/6; a < TWO_PI; a += TWO_PI/6) {
    float vx = x + cos(a) * gs*2;
    float vy = y + sin(a) * gs*2;
    vertex(vx, vy);
  }
  endShape(CLOSE);
  forestRandCounter++;
}

void posShuffle(boolean reloc) {
  randomHex = int(random(xHexes.size()));
  xPos = xHexes.get(randomHex);
  yPos = yHexes.get(randomHex);
  
  if (reloc == true) {
    xPosS.remove(xPosS.size()-1);
    yPosS.remove(yPosS.size()-1);
  }
  xPosS.add(xPos);
  yPosS.add(yPos);
}

void drawPlainHex(float x, float y, float gs) {
  beginShape();
  for (float a = PI/6; a < TWO_PI; a += TWO_PI/6) {
    float vx = x + cos(a) * gs*2;
    float vy = y + sin(a) * gs*2;
    vertex(vx, vy);
  }
  endShape(CLOSE);
}

void visibility() {
  for (int i = 0; i < xHexes.size(); i++) {
    for (int n = 0; n < xPosS.size(); n++) {
      if (visibilities.size() > 0) {
        if (dist(xHexes.get(i), yHexes.get(i), xPosS.get(n), yPosS.get(n)) < visibilities.get(n)*hexSize*3.5) {
          hexVisible.set(i, true);
        }
      } else {
        if (dist(xHexes.get(i), yHexes.get(i), xPosS.get(n), yPosS.get(n)) < 5*hexSize*3.5) {
          hexVisible.set(i, true);
        }
      }
    }
  }
}

void possibleMoves() {
  for (int i = 0; i < xHexes.size(); i++) {
    fill(255,0,0,80);
    if (dist(xHexes.get(i), yHexes.get(i), xPosS.get(unitSel), yPosS.get(unitSel)) < (totalMovements.get(unitSel)-movements.get(unitSel))*hexSize*3.9) {
      color hexNorthColor = get(xHexes.get(i),yHexes.get(i)-hexSize+1);
      color hexSouthColor = get(xHexes.get(i),yHexes.get(i)+hexSize-1);
      color hexWestColor = get(xHexes.get(i)-hexSize+1,yHexes.get(i));
      color hexEastColor = get(xHexes.get(i)+hexSize-1,yHexes.get(i));
      if ((sailing == true || (hexNorthColor != deepOcean && hexNorthColor != ocean && hexNorthColor != sea)) && (mountaineering == true || (hexNorthColor != mountain && hexNorthColor != snow))) {
        if ((sailing == true || (hexSouthColor != deepOcean && hexSouthColor != ocean && hexSouthColor != sea)) && (mountaineering == true || (hexSouthColor != mountain && hexSouthColor != snow))) {
          if ((sailing == true || (hexWestColor != deepOcean && hexWestColor != ocean && hexWestColor != sea)) && (mountaineering == true || (hexWestColor != mountain && hexWestColor != snow))) {
            if ((sailing == true || (hexEastColor != deepOcean && hexEastColor != ocean && hexEastColor != sea)) && (mountaineering == true || (hexEastColor != mountain && hexEastColor != snow))) {
               drawPlainHex(xHexes.get(i), yHexes.get(i), hexSize*0.5);
            }
          }
        }
      }
    }
  }
  spawnAllUnits();
}

void setup() {
  civFont = createFont("civFont.ttf", 26);
  textFont(civFont);
  
  grassImg = loadImage("grass_05.png");
  beachImg = loadImage("sand_02.png");
  forestImg1 = loadImage("grass_10.png");
  forestImg2 = loadImage("grass_11.png");
  forestImg3 = loadImage("grass_12.png");
  forestImg4 = loadImage("grass_13.png");
  seaImg = loadImage("seaImg.png");
  oceanImg = loadImage("oceanImg.png");
  deepOceanImg = loadImage("deepOceanImg.png");
  mountainImg = loadImage("mountainImg.png");
  snowImg = loadImage("snowImg.png");
  cloudImg = loadImage("cloudImg.png");
  
  ancientSeImg = loadImage("indianTent_front.png");
  
  ancientSeIcon = loadImage("indianTent_front.png");
  
  scoutImg = loadImage("scout.png");
  settlerImg = loadImage("settler.png");
  
  scoutIcon = loadImage("scout.png");
  settlerIcon = loadImage("settler.png");
  
  nextTurn = loadImage("nextTurn.png");
  settleCityImg = loadImage("settleCityImg.png");
  
  scienceImg = loadImage("scienceImg.png");
  coinImg = loadImage("coinImg.png");
  popIcon = loadImage("pop.png");
  prodIcon = loadImage("production.png");
  
  grassImg.resize(int(hexSize*2*0.8*decScale), int(hexSize*2*0.8*decScale));
  beachImg.resize(int(hexSize*2*1*decScale), int(hexSize*2*1*decScale));
  forestImg1.resize(int(hexSize*2*0.8*decScale), int(hexSize*2*0.8*decScale));
  forestImg2.resize(int(hexSize*2*0.8*decScale), int(hexSize*2*0.8*decScale));
  forestImg3.resize(int(hexSize*2*0.8*decScale), int(hexSize*2*0.8*decScale));
  forestImg4.resize(int(hexSize*2*0.8*decScale), int(hexSize*2*0.8*decScale));
  seaImg.resize(int(hexSize*2*1*decScale), int(hexSize*2*0.7*decScale));
  oceanImg.resize(int(hexSize*2*1*decScale), int(hexSize*2*0.7*decScale));
  deepOceanImg.resize(int(hexSize*2*1*decScale), int(hexSize*2*0.7*decScale));
  mountainImg.resize(int(hexSize*2*0.5*decScale), int(hexSize*2*0.5*decScale));
  snowImg.resize(int(hexSize*2*0.5*decScale), int(hexSize*2*0.5*decScale));
  cloudImg.resize(int(hexSize*2*0.5*decScale), int(hexSize*2*0.5*decScale));
  
  ancientSeImg.resize(int(hexSize*2*0.5*decScale), int(hexSize*2*0.5*decScale));
  
  ancientSeIcon.resize(int(24*1.3*iconScale), int(24*1.3*iconScale));
  
  scoutIcon.resize(int(24*1*iconScale), int(24*1*iconScale));
  settlerIcon.resize(int(24*1*iconScale), int(24*1*iconScale));
  
  scoutImg.resize(int(hexSize*2*0.8*unitScale), int(hexSize*2*0.8*unitScale));
  settlerImg.resize(int(hexSize*2*0.8*unitScale), int(hexSize*2*0.8*unitScale));
  
  nextTurn.resize(int(30*2*6*iconScale), int(30*2*3*iconScale));
  settleCityImg.resize(int(30*2*0.6*iconScale), int(30*2*0.6*iconScale));
  
  scienceImg.resize(40,40);
  coinImg.resize(40,40);
  
  popIcon.resize(int(24*1.1*iconScale), int(24*1.3*iconScale));
  prodIcon.resize(int(24*1.5*iconScale), int(24*1.5*iconScale));
  
  // Mountain Range: 5, 0.6
  // Archipelago: 1, 0
  // Plains with not much water: 2,1 
  // Plains with some water: 2, 0.7
  // Continents: 2, 0.1
  // Dense Forest: 5, 0.5
  noiseDetail(1000, 0.01);
  noStroke();
  frameRate(60);
  ellipseMode(CENTER);
  imageMode(CENTER);
  shapeMode(CENTER);
  // 3:2 Aspect Ratio
  // size(2736,1824);
  // 16:9 Aspect Ratio
  fullScreen();
  smooth(8);
  
  int counter = 0;
  while (hexSize*counter < 2000) {
    sizes.add(hexSize*counter);
    counter++;
  }
  boolean setX = false;
  boolean setY = false;
  for (int i = 0; i < sizes.size(); i++) {
    if (sizes.get(i) > 305 && setY == false) {
      ySize = sizes.get(i);
      setY = true;
    } else if (sizes.get(i) > 1640 && setX == false) {
      xSize = sizes.get(i);
      setX = true;
    }
  }
  
  for (int n = 0; n < (ySize/hexSize)*(xSize/hexSize)*2; n++) {
    forestRandTypes.add(int(random(3)));
  }
  
  drawMap();
  
  // Origin unit
  posShuffle(false);
  redrawMap(true);
  while ((get(xPos-hexSize+1,yPos) == deepOcean || get(xPos-hexSize+1,yPos) == ocean || get(xPos-hexSize+1,yPos) == sea || get(xPos-hexSize+1,yPos) == mountain || get(xPos-hexSize+1,yPos) == snow) || 
  (get(xPos-int(4.4*hexSize)+1,yPos) == deepOcean || get(xPos-int(4.4*hexSize)+1,yPos) == ocean || get(xPos-int(4.4*hexSize)+1,yPos) == sea || get(xPos-int(4.4*hexSize)+1,yPos) == mountain || get(xPos-int(4.4*hexSize)+1,yPos) == snow) ||
  (get(xPos+int(4.4*hexSize)-1,yPos) == deepOcean || get(xPos+int(4.4*hexSize)-1,yPos) == ocean || get(xPos+int(4.4*hexSize)-1,yPos) == sea || get(xPos+int(4.4*hexSize)-1,yPos) == mountain || get(xPos+int(4.4*hexSize)-1,yPos) == snow) ||
  (get(xPos-int(2.7*hexSize),yPos-int(4*hexSize)) == deepOcean || get(xPos-int(2.7*hexSize),yPos-int(4*hexSize)) == ocean || get(xPos-int(2.7*hexSize),yPos-int(4*hexSize)) == sea || get(xPos-int(2.7*hexSize),yPos-int(4*hexSize)) == mountain || get(xPos-int(2.7*hexSize),yPos-int(4*hexSize)) == snow) ||
  (get(xPos+int(2.7*hexSize),yPos+int(4*hexSize)) == deepOcean || get(xPos+int(2.7*hexSize),yPos+int(4*hexSize)) == ocean || get(xPos+int(2.7*hexSize),yPos+int(4*hexSize)) == sea || get(xPos+int(2.7*hexSize),yPos+int(4*hexSize)) == mountain || get(xPos+int(2.7*hexSize),yPos+int(4*hexSize)) == snow) &&
  (xPos > width-300 && xPos < 300 && yPos > height-200 && yPos < 200)) {
    posShuffle(true);
  }
  visibility();
  background(cloud);
  redrawMap(false);
  image(scoutImg, xPos, yPos);
  units.add("scout");
  // Add settler
  xPos = int(xPosS.get(0)+(1.7*hexSize));
  yPos = int(yPosS.get(0)+(3*hexSize));
  xPosS.add(int(xPosS.get(0)+(1.7*hexSize)));
  yPosS.add(int(yPosS.get(0)+(3*hexSize)));
  image(settlerImg, xPos, yPos);
  units.add("settler");
  
  possibleBuilds.add("scout");
  possibleBuildTimes.add(2);
  
  for (int i = 0; i < xPosS.size(); i++) {
    if (units.get(i) == "scout") {
      totalMovements.add(3);
      visibilities.add(5);
    } else if (units.get(i) == "settler") {
      totalMovements.add(3);
      visibilities.add(5);
    }
    movements.add(0);
  }
}

void move(float xMove, float yMove) {
  if (movements.get(unitSel) < totalMovements.get(unitSel)) {
    visibility();
    redrawMap(false);
    if (sailing == true || (get(int(xPosS.get(unitSel)+(xMove*hexSize)), int(yPosS.get(unitSel)+(yMove*hexSize))) != deepOcean && get(int(xPosS.get(unitSel)+(xMove*hexSize)), int(yPosS.get(unitSel)+(yMove*hexSize))) != ocean && get(int(xPosS.get(unitSel)+(xMove*hexSize)), int(yPosS.get(unitSel)+(yMove*hexSize))) != sea)) {
      if (mountaineering == true || get(int(xPosS.get(unitSel)+(xMove*hexSize)), int(yPosS.get(unitSel)+(yMove*hexSize))) != mountain) {
        xPosS.set(unitSel, int(xPosS.get(unitSel)+(xMove*hexSize)));
        yPosS.set(unitSel, int(yPosS.get(unitSel)+(yMove*hexSize)));
        movements.set(unitSel, movements.get(unitSel)+1);
      }
    }
    possibleMoves();
    
    /* ArrayList<Integer> possibleEndsCombos = new ArrayList<Integer>();
    ArrayList<Integer> possibleEndsX = new ArrayList<Integer>();
    ArrayList<Integer> possibleEndsY = new ArrayList<Integer>();
    String[] movementList = {"north-west","north","north-east","south-west","south","south-east"};
    for (int i = 0; i < totalMovements.get(unitSel) - movements.get(unitSel); i++) {
      for (int a = 0; a < 6; a++) {
        for (int b = 0; b < 6; b++) {
          for (int c = 0; c < 6; c++) {
            String[] combos = {movementList[a],movementList[b],movementList[c]};
            combos = sort(combos);
            // printArray(combos);
          }
        }
      }
    } */
  }
}

void spawnAllUnits() {
  for (int i = 0; i < xPosS.size(); i++) {
    if (units.get(i) == "scout") {
      image(scoutImg, xPosS.get(i), yPosS.get(i));
    } else if (units.get(i) == "settler") {
      image(settlerImg, xPosS.get(i), yPosS.get(i));
    }
  }
}

void mousePressed() {
  if (mouseX > (width-100)-100 && mouseX < (width-100)+100 && mouseY > (height-100)-100 && mouseY < (height-100)+100) {
    for (int i = 0; i < xPosS.size(); i++) {
      movements.set(i,0);
      redrawMap(false);
      spawnAllUnits();
    }
  }
  for (int i = 0; i < xPosS.size(); i++) {
    if (mouseX > xPosS.get(i)-hexSize && mouseX < xPosS.get(i)+hexSize && mouseY > yPosS.get(i)-hexSize && mouseY < yPosS.get(i)+hexSize) {
      if (unitSelected == true && i == unitSel) {
        unitSel = 0;
        unitSelected = false;
        
        if (units.get(i) == "settler") {
          settlerGUI = false;
        }
        background(cloud);
        redrawMap(false);
        spawnAllUnits();
      } else {
        unitSel = i;
        unitSelected = true;
        possibleMoves();
        
        if (units.get(i) == "settler") {
          settlerGUI = true;
        }
      }
    }
  }
  if (movements.get(unitSel) < totalMovements.get(unitSel)) {
    for (int i = 0; i < iconXPosS.length; i++) {
      if (mouseX > iconXPosS[i]-mouseThreshold && mouseX < iconXPosS[i]+mouseThreshold && mouseY > iconYPosS[i]-mouseThreshold && mouseY < iconYPosS[i]+mouseThreshold) {
        if (iconTypes[i] == "settleCity") {
          background(cloud);
          redrawMap(false);
          if (era == "ancient") {
            tint(cityColors[cityColor]);
            image(ancientSeImg, xPosS.get(unitSel), yPosS.get(unitSel));
            noTint();
            buildingXPosS.add(xPosS.get(unitSel));
            buildingYPosS.add(yPosS.get(unitSel));
            buildingTypes.add("city");
            buildingColor.add(hex(cityColors[cityColor]));
            cityColor++;
            if (cityColor > cityColors.length) {
              cityColor = 0;
            }
            xPosS.remove(unitSel);
            yPosS.remove(unitSel);
            movements.remove(unitSel);
            totalMovements.remove(unitSel);
            units.remove(unitSel);
            unitSel = 0;
            unitSelected = false;
            settlerGUI = false;
            for (int n = 0; n < iconXPosS.length; n++) {
              iconXPosS[n] = 0;
              iconYPosS[n] = 0;
              iconTypes[n] = "";
            }
          }
          spawnAllUnits();
        } else if (iconTypes[i] == "pop") {
          popGUI = true;
        } else if (iconTypes[i] == "prod") {
          prodGUI = true;
        }
      }
    }
  }
  for (int i = 0; i < buildingXPosS.size(); i++) {
    if (mouseX > buildingXPosS.get(i)-hexSize && mouseX < buildingXPosS.get(i)+hexSize && mouseY > buildingYPosS.get(i)-hexSize && mouseY < buildingYPosS.get(i)+hexSize) {
      if (buildingSelected == true && i == buildingSel) {
        buildingSel = 0;
        buildingSelected = false;
        
        if (buildingTypes.get(i) == "city") {
          cityGUI = false;
        }
        background(cloud);
        redrawMap(false);
        spawnAllUnits();
      } else {
        buildingSel = i;
        buildingSelected = true;
        
        if (buildingTypes.get(i) == "city") {
          cityGUI = true;
        }
      }
    }
  }
  for (int i = 0; i < prodChoiceXPosS.size(); i++) {
    if (mouseX > prodChoiceXPosS.get(i)-80 && mouseX < prodChoiceXPosS.get(i)+80 && mouseY > prodChoiceYPosS.get(i)-40 && mouseY < prodChoiceYPosS.get(i)+40) { 
      if (prodChoiceTypes.get(i) == "scout") {
        cityGUI = false;
        prodGUI = false;
        print("hello");
        image(scoutImg, buildingXPosS.get(buildingSel), buildingYPosS.get(buildingSel));
        xPosS.add(buildingXPosS.get(buildingSel));
        yPosS.add(buildingYPosS.get(buildingSel));
        movements.add(0);
        totalMovements.add(3);
        units.add("scout");
        visibilities.add(5);
        background(cloud);
        redrawMap(false);
        spawnAllUnits();
      }
    }
  }
}

void keyPressed() {
  if (unitSelected == true) {
    if (key == 'q' || key == 'Q') {
      move(-1.7,-3.0);
    }
    if (key == 'w' || key == 'W') {
      move(-1.7,-3.0);
    } 
    if (key == 'e' || key == 'E') {
      move(1.7,-3.0);
    } 
    if (key == 'a' || key == 'A') {
      move(-3.41,0);
    } 
    if (key == 's' || key == 'S') {
      move(1.7,3.0);
    } 
    if (key == 'd' || key == 'D') {
      move(3.45,0);
    }
    spawnAllUnits();
  }
}

/* void mouseWheel(MouseEvent event) {
  if (event.getCount() != -1) {
    scaleFactor = scaleFactor*(event.getCount()*2);
  }
} */

void draw() {
  fill(255);
  rect(width,height,-200,-200,50,0,0,0);
  image(nextTurn,width-85,height-85);
  /* fill(255);
  quad(0,0,0,45,600,45,700,0);
  image(scienceImg,20,20);
  fill(#00d9ff);
  text("+" + sciencePT,45,30);
  image(coinImg,130,20);
  fill(#d4af37);
  text(coins + " (+" + coinsPT + ")",155,30); 
  
  fill(255);
  quad(width,0,width,50,width-600,50,width-700,0); */
  
  for (int i = 0; i < xPosS.size(); i++) {
    if (movements.get(i) == totalMovements.get(i)) {
      strokeWeight(hexSize/6);
      stroke(255,0,0);
      line(xPosS.get(i)-hexSize, yPosS.get(i)-hexSize, xPosS.get(i)+hexSize, yPosS.get(i)+hexSize);
      noStroke();
    }
  }
  if (settlerGUI == true) {  
    fill(255);
    rect(width,height-150,-200,-200,50,0,0,0);
    if (movements.get(unitSel) == totalMovements.get(unitSel)) {
      strokeWeight(hexSize/6);
      stroke(255,0,0);
      line(width-170,height-250,width-130,height-210);
      noStroke();
    }
    image(settlerIcon, width-100, height-310);
    for (int i = 0; i < settlerActions.length; i++) {
      fill(200);
      drawPlainHex(width-((i+1)*50), height-260, 13);
      iconXPosS[i] = width-((i+1)*50);
      iconYPosS[i] = height-260;
      if (settlerActions[i] == "settleCity") {
        image(settleCityImg, width-((i+1)*50), height-260);
        iconTypes[i] = settlerActions[i];
      }
    }
  }
  if (cityGUI == true) {
    fill(255);
    rect(0,height,200,-200,0,50,0,0);
    tint(unhex(buildingColor.get(unitSel)));
    if (era == "ancient") {
      image(ancientSeIcon, 100, height-140);
    }
    noTint();
    fill(200);
    drawPlainHex(60, height-60, 20);
    image(popIcon, 60, height-60);
    iconXPosS[0] = 60;
    iconYPosS[0] = height-60;
    iconTypes[0] = "pop";
    drawPlainHex(140, height-60, 20);
    image(prodIcon, 140, height-60);
    iconXPosS[0] = 140;
    iconYPosS[0] = height-60;
    iconTypes[0] = "prod";
  }
  if (prodGUI == true) {
    fill(255);
    rect(0,height-170,200,-600,0,50,0,0);
    for (int i = 0; i < possibleBuilds.size(); i++) {
      if (possibleBuilds.get(i) == "scout") {
        fill(200);
        rect(20, height-740+((i+1)*-20), 160, 80, 20, 20, 20, 20);
        // prodChoices are registed 47 times for some reason???
        prodChoiceXPosS.add(100);
        prodChoiceYPosS.add((height-740+((i+1)*-20)+40));
        prodChoiceTypes.add("scout");
        image(scoutIcon, 50, height-820+((i+1)*100));
        fill(0);
        text(possibleBuildTimes.get(i) + " turns", 80, height-820+((i+1)*100)+10);
      }
    }
  }
}
