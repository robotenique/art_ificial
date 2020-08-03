int framerate = 60;
float ratioFromBase = framerate/60;
int clockCounter;
float clockAngleAggregator;
int firstSpiralColor = 255;
int first = 0;
float originalDistanceFromOrigin, originalDistanceFromOrigin2;
void setup() {
  size(1000, 1000);
  noStroke();
  background(0);
  rectMode(CENTER);
  frameRate(framerate);
}


void draw() {
  for(int i = 1; i < 10; i++){
    drawInvertedSpirals(500, 500, map(i, 1, 10, 0.1, 0.4), 10, i, i/10.0);
  }
  
  saveIfNeeded();
}

void saveIfNeeded(){
  if (keyPressed) {
    if (key == 's') {
      saveFrame("red-spirals-#####.png");
    }
  }
}

void drawInvertedSpirals(float x, float y, float radiusMultiplier, float elipseRadius, float colorWheelDisplacement, float angleAdditional){
  float milistep = ratioFromBase*0.01*millis();
  float currRadius2 = elipseRadius/5 + 5*milistep;
  if (radiusMultiplier <= 0.1){
    //drawFirstSpiral(x, y, radiusMultiplier, elipseRadius);
  }
  //fill(255-getColor(ratioFromBase*0.5*millis()), 10, 50, 244);  
  fill(abs(255*sin(milistep - colorWheelDisplacement) + 1),
      10,
      abs(map(angleAdditional, 0.1, 1, 40, 210)*sin(milistep - colorWheelDisplacement) + 1),
      map(angleAdditional, 0.1, 1, 150, 10));
  float rX = x+currRadius2*radiusMultiplier*7.2*sin(milistep + angleAdditional);
  float rY = y+currRadius2*radiusMultiplier*7.2*cos(milistep + angleAdditional);
  float mappedRadius = mappedRadiusRatio(rX, rY, 2.5, originalDistanceFromOrigin2);
  ellipse(rX,
          rY,
          elipseRadius*(1.3+abs(cos(milistep)))*2*mappedRadius,
          elipseRadius*(1.3+abs(sin(milistep)))*mappedRadius);
  if (first < 2) {
      float initX = x+currRadius2*radiusMultiplier*7.2*sin(milistep + angleAdditional);
      float initY = y+currRadius2*radiusMultiplier*7.2*cos(milistep + angleAdditional);
      originalDistanceFromOrigin2 = distance(initX, initY, 500, 500);
      first++;
    }
  
  
}

void drawFirstSpiral(float x, float y, float radiusMultiplier, float elipseRadius) {
  float milistep = ratioFromBase*0.01*millis();
  float currRadius = elipseRadius/10 + 10*milistep;
  // this will cycle between ligher and darker shades
  fill((1 + abs(255*sin(milistep))), 255);
  float angleIncrement = 0.8*milistep;
  float rX = x+radiusMultiplier*currRadius*cos(angleIncrement);
  float rY = y+radiusMultiplier*currRadius*sin(angleIncrement);
  float mappedRadius = mappedRadiusRatio(rX, rY, 2.5, originalDistanceFromOrigin);
  ellipse(rX,
          rY,
          elipseRadius*(1 + abs(sin(milistep*2)))*mappedRadius,
          elipseRadius*(1 + abs(sin(milistep*2)))*mappedRadius);
  
  clockAngleAggregator += angleIncrement%TWO_PI;
  if(clockAngleAggregator >= TWO_PI){
    clockAngleAggregator = 0;
    clockCounter++;
    if (clockCounter%2 == 0){
      firstSpiralColor = (firstSpiralColor + 20)%255;
    }
  }
  if (first < 2) {
    float initX = x+radiusMultiplier*currRadius*cos(angleIncrement);
    float initY = y+radiusMultiplier*currRadius*sin(angleIncrement);
    originalDistanceFromOrigin = distance(initX, initY, 500, 500);
    first++;
  }
  
}

float distance(float x1, float y1, float x2, float y2){
 return sqrt(pow(x1 - y1, 2) + pow(x2 - y2, 2));
}

float mappedRadiusRatio(float rX, float rY, float maxRatioFromCurrent, float originDist){
  float currDistanceFromOrigin = distance(rX, rY, 500, 500);
  return map(currDistanceFromOrigin, originDist, width*sqrt(2)/2, 1, maxRatioFromCurrent);
}


float getColor(float milistep){    
  if (milistep%510 > 255){
    return 510 - milistep%510;
  }else {
    return milistep%510;
  }
}
