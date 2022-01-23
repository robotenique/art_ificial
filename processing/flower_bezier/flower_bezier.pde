SshapedCurve ss, ss2;
ArrayList<SshapedCurve> ssArray;
ArrayList<Integer> numPetalsList;
int n;
void setup(){
  size(1150, 1150);
  background(0);
  ss = new SshapedCurve(10, 0, 400, 100, 0);
  ss.registerTranslation(width/2, height/2);  
  n = 2;
  int maxDepth = 3;
  ssArray = new ArrayList<SshapedCurve>();
  numPetalsList = new ArrayList<Integer>();

  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      noFill();
      recFn(i*width/n, j*height/n, width/n, 0, maxDepth, ssArray, 0);
    }
  
  }
  for(SshapedCurve a: ssArray) {
    numPetalsList.add(int(random(3, 10)));
  }
}

void saveIfNeeded(){
  if (keyPressed) {
    if (key == 's') {
      saveFrame("pattern-#####.png");
    }
  }
}

void recFn(float originX, float originY, float sideX, int depth, int maxDepth, ArrayList<SshapedCurve> ssList, int fatherNsquares){
  if (depth < maxDepth) {
    int nSquares = int(random(1, 3));
    float ratioSide = sideX/nSquares;
    
    for(int i=0; i <  nSquares; i++){
      for(int j=0; j <  nSquares; j++){
        recFn(originX + i*ratioSide, originY + j*ratioSide, ratioSide, depth + 1, maxDepth, ssList, nSquares);
      }
    }
    
    
  } else {
    //println(originX, originY);
    SshapedCurve newSCurve = new SshapedCurve(0, 0, sideX*0.5, sideX*random(0.2, 0.6), fatherNsquares);
    newSCurve.registerTranslation(originX + .5*sideX, originY + .5*sideX);
    ssArray.add(newSCurve);

  }
}

void draw() {
  saveIfNeeded();
  //background(255);
  for(int i=0; i < ssArray.size(); i++) {
      push();
      drawFlower(ssArray.get(i), numPetalsList.get(i));
      pop();
  }
}

class SshapedCurve {
  float x1, y1, cpx1, cpy1, cpx2, cpy2, x2, y2;
  float yOffset, controlXOffset;
  float initT;
  float tx0, ty0;
  int depth;
  SshapedCurve (float x1, float y1, float yOffset, float controlXOffset, int depth) {
    assert (yOffset > 0);
    assert (controlXOffset > 0);
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x1;
    this.y2 = y1 - yOffset;
    this.yOffset = yOffset;
    this.controlXOffset = controlXOffset;
    this.cpx1 = x1 - controlXOffset;
    this.cpx2 = x1 + controlXOffset;
    this.cpy1 = y1 - yOffset/2;
    this.cpy2 = cpy1;
    initT = cpy1;
    this.depth = depth; 
  }
  
  void draw(){
    noFill();
    initT += 0.001;
    // the control points of the bezier curve
    if (depth == 1) {
      stroke(50+random(20), 50+random(255), 10+random(255), 20);
    }else if (depth == 2) {
      stroke(200+random(20), 20+random(100), 100+random(100), 20);
    } else {
      stroke(200+random(50), 100+random(100), 100+random(-50, 50), 20);
    }
      
    float cpYvalue = -abs(y2*0.5*sin(initT));
    float cpXvalueOffset = (controlXOffset/2) + abs((controlXOffset*2 - (controlXOffset/2))*sin(initT*5));
    float cpXvalueOffset2 = (controlXOffset/2) + abs((controlXOffset*2 - (controlXOffset/2))*sin(initT*5 + radians(120)));
    bezier(0, 0, - cpXvalueOffset, cpYvalue - y1, cpXvalueOffset2, cpYvalue - y1, x2 - x1, y2 - y1);
    //push();
    //stroke(255, 0, 0);
    //strokeWeight(4);
    //point(x1 - cpXvalueOffset, cpYvalue);
    //point(x1 + cpXvalueOffset2, cpYvalue);
    //pop();

  }
  
  void plotTransform(boolean useAngle, float angle) {
    translate(tx0, ty0);
    if (useAngle) {
      rotate(angle);
    }
  }
  
  
  
  void registerTranslation(float x0, float y0) {
    this.tx0 = x0;
    this.ty0 = y0;
  }

  void debugDraw(){
   push();
   ellipseMode(CENTER);
   fill(200, 100, 200);
   ellipse(0,0, 40, 40);
    pop();

  }
}

void drawFlower(SshapedCurve ss, int nPetals) {
  ss.draw();
  for(int i=0; i < nPetals; i++) {
    push();
    ss.plotTransform(true, (1 + i)*TWO_PI/nPetals);    
    ss.draw();
    pop();
  }
}
//bezier(x1, y1, cpx1, cpy1, cpx2, cpy2, x2, y2);
//x1, y1  Coordinates of the curve’s starting point
//cpx1, cpy1  Coordinates of the first control point
//cpx2, cpy2  Coordinates of the second control point
//x2, y2  Coordinates of the curve’s ending point
