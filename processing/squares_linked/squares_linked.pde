import java.util.List;
import java.util.ArrayList;
int rows, cols;
RectangleDynamic[][] rectGrid;
int globalNumRectangles = 0;
final int MAX_RECTANGLES = 300;
void setup(){
  rows = 12;
  cols = 12;
  size(900, 900);
  background(0);
  rectMode(CENTER);
  translate(width/2, height/2);
  rectGrid = new RectangleDynamic[rows][cols];
  float scaleVal = width/rows;
  float scaleValY = height/cols;
   for(int i=0; i< rows;i++){
    for(int j=0; j< rows;j++){
      rectGrid[i][j] = new RectangleDynamic(i*scaleVal, j*scaleValY, 2*scaleVal);
    }
  }
}

void draw(){
  background(255);  
  updateRectangles(rectGrid);
  saveIfNeeded();
}

void saveIfNeeded(){
  if (keyPressed) {
    if (key == 's') {
      saveFrame("squares-#####.png");
    }
  }
}
class RectangleDynamic {
  float scaleDynamic, originalSize;
  float x, y, currX, currY;
  int depth = 0;
  float towards = 0;
  List<RectangleDynamic> internalRectangles;
  RectangleDynamic father;
  RectangleDynamic(float x, float y, float size){
    this.x = x;
    this.y = y;
    this.scaleDynamic = size;
    this.originalSize = size;
    this.internalRectangles = new ArrayList<RectangleDynamic>();
    globalNumRectangles++;
  }
  
  RectangleDynamic(float x, float y, float size, int depth, RectangleDynamic father){
    this(x, y, size);
    this.depth = depth;
    this.father = father;
  }
  
  void update(){
    float val = (random(1) < 0.5)? 1: 0.9;
    scaleDynamic += val*0.005;
    towards += 0.5;
  }
  
  void criticalEvent(){
    if(globalNumRectangles < MAX_RECTANGLES && random(1) < 0.01*(depth+0.05) && depth < 3 && internalRectangles.size() < 4) {
      float sc = random(2, 4);
      float coord = random(0.7, 1.3);
      if(scaleDynamic/sc < 2.0) {
        updateRectangleslist(internalRectangles);
        return;
      }
        
      internalRectangles.add(new RectangleDynamic(
          this.x,
          this.y,
          this.scaleDynamic/1.5,
          this.depth + 1,
          this
        )
      );
    }
    
    updateRectangleslist(internalRectangles);
  }

  void show(){
    stroke(max(200*(abs(sin(scaleDynamic)*10)), 20), 255);
    noStroke();
    switch(depth){
      case 0:
        noFill();
        break;
      case 1:
        fill(255, 50, 50, 100);
        break;
      case 2:
        fill(50, 50, 255, 150);
        break;
      case 3:
        fill(50, 255, 0, 200);
        break;
      default:
        noFill();
    }
    currX = (towards+scaleDynamic+x*sin(scaleDynamic))%width;
    currY = (towards+scaleDynamic+y*cos(scaleDynamic))%height;
    rect(currX, currY, originalSize, originalSize);
    criticalEvent();
  }
  
  void linkToFather(){
    stroke(0, 120);
    line(this.currX, this.currY, father.currX, father.currY);
  }
}

void updateRectangleslist(List<RectangleDynamic> rectList){
  noFill();
  stroke(255, 255, 255, 120);
  for(RectangleDynamic r: rectList){
    r.show();
    if(r.depth > 1) {
      r.linkToFather();
    }
    r.update();
  }

}
void updateRectangles(RectangleDynamic[][] grid){
  noFill();
  stroke(255);
  for(int i=0; i < grid.length; i++){
    for(int j=0; j < grid[i].length; j++){
      grid[i][j].show();
      grid[i][j].update();
    }
  }
}
