
import java.util.Iterator;
import java.lang.Math;
import java.util.Random;
ArrayList<TriangleStore> triangles;
float defaultSpeed, manualGambiarraNumber, timeToRecord;
int backgroundColor, backgroundAlpha, toRotate;
boolean toChangeSpeed, saveFrames;
float fixMillis=0;
/*
 * A bunch of stuff here is based on some trigonometry relations.
 * I probably won't remember anything about these formulas.
 * 
 * TODO: detail inside each triangle (e.g. inv triangle, or elipse inside it)
 * wiggle y-axis trajectory
 * color gradient
 * custom randomly determined rotation
 * maybe add a reflection (x-axis) coming from the other side :D1
 */

void setup(){
  size(1920, 1150); // window size
  background(0); // black background
  frameRate(60); // 60 frames per second
  // ----------- GENERAL CANVAS CONFIG -----------
  int numTriangles = 10;
  backgroundColor = 0;
  backgroundAlpha = 15;
  toRotate = 1;
  toChangeSpeed = false;
  defaultSpeed = 0.045;
  saveFrames = true;
  timeToRecord = 90; // time to record sketch in seconds
  manualGambiarraNumber = 16.99; // :D power user feature



  float triangleSide = (float)((2/Math.sqrt(3))*(height/numTriangles)); // height is side*(sqrt(3)/2)
  float startYaxis = 0;
  triangles = new ArrayList<TriangleStore>();
  Random randomno = new Random();
  for (int i = 0; i < numTriangles; ++i) {
    triangles.add(
      new TriangleStore(
        triangleSide,
        startYaxis,
        (float)(randomno.nextGaussian()*(width/10) - width/2.5),
        new ColorGradient(new ColorRGB(255, 255, 255), new ColorRGB(0, 0, 0), 200, 1),
        new ColorGradient(new ColorRGB(150,(i*50)%255, 100 + (i*20)%255), new ColorRGB(10, (((i - numTriangles/2)^2)*40)%255, (i*20)%255), 40+i*(10), 1)
        )
    );
    startYaxis += triangleSide*Math.sqrt(3)/2;
  }
}


void draw(){
  fixMillis += manualGambiarraNumber;
  fill(backgroundColor, backgroundAlpha);
  rect(0, 0, width, height);
  for (TriangleStore innerT : triangles)
      innerT.draw();
  saveIfNeeded();
}

void saveIfNeeded(){ 
  float seconds = (float)(millis())/1000;
  if (saveFrames && seconds < timeToRecord)
    saveFrame("imgDump/crazyt-#####.png");
}

class TriangleStore{
    public float tx1, ty1, tx2, ty2, tx3, ty3;;
    public float p1, p2;
    public double tLength;
    float speedOffset, rd2, rd3;
    ColorGradient cgOutline, cgInline;


    TriangleStore(float tLength, float verticalOffset, float horizontalOffset, ColorGradient cg, ColorGradient cgIn) {
        // triangle Length
        this.tLength = tLength;
        // coordinate reference point
        this.p1 = horizontalOffset;
        this.p2 = verticalOffset;

        // triangle points
        this.tx1 = 0;
        this.ty1 = (float) (tLength*Math.sqrt(3)/2);
        this.tx2 = tLength;
        this.ty2 = ty1;
        this.tx3 = tLength/2;
        this.ty3 = 0;

        // stroke and inner color gradient
        this.cgOutline = cg;
        this.cgInline = cgIn;

        this.speedOffset = random(-0.1, 0.2);
        this.rd2 = random(0, 0.5);
        this.rd3 = (random(1) < 0.5) ? -1 : 1;
    }


    void draw() {
        push();
        ColorRGB dummyC;
        dummyC = cgOutline.next();
        stroke(dummyC.r, dummyC.g, dummyC.b);
        dummyC = cgInline.next();
        fill(dummyC.r, dummyC.g, dummyC.b, 255);
        translate(p1, p2);
        noStroke();
        rotate(toRotate*rd3*0.006*fixMillis*PI/4);
        triangle(tx1, ty1, tx2, ty2, tx3, ty3);
        float componentR = floor(100*exp(sin(0.004*fixMillis + 1)) - 16);
        float componentG = floor(100*exp(sin(0.004*fixMillis - 1)) - 16);
        float componentB = floor(100*exp(sin(0.004*fixMillis + 2)) - 16);
        fill(componentR, componentG ,componentB, 255); // inv the color but applying some handcrafted adjustment
        triangle((tx1 + tx2)/2, (ty1 + ty2)/2, (tx2 + tx3)/2, (ty2 + ty3)/2, (tx3 + tx1)/2, (ty3 + ty1)/2);
        stroke(componentR, componentG, componentB, 200);
        strokeWeight(2);
        line(tx1, ty1, tx2, ty2);
        stroke(componentR, componentG, componentB, 200);
        line(tx2, ty2, tx3, ty3);
        stroke(255, componentG, componentB, 200);
        line(tx3, ty3, tx1, ty1);
        this.self_adjust();
        pop();
    }

    void self_adjust(){
        float adjFactor = (toChangeSpeed) ? (defaultSpeed*speedAdjuster(fixMillis*rd2)) : defaultSpeed;
        p1 += tLength*adjFactor;
        p1 %= width;
    }

    float speedAdjuster(float x){
      // a crazy sum of trigonometric functions to create a nice velocity pattern
      // https://www.desmos.com/calculator/a9dokhqj2i
      float c1, c2, c3;
      c1 = sin((float)(Math.sqrt(x/(0.1)))) + 1;
      c2 = -cos(x*0.5) + 1;
      c3 = sin(x*1.5)*sin(x*sin(speedOffset*x)) + 1;

      return c1 + c2 + c3;
    }
}


// Color related classes
//import java.util.Iterator;
/**
* The ColorRGB represents a single color, and provides a useful way to
* access the Red, Green and Blue components, as well as alpha level of a color.
* Objects from ColorRGB are the base for more complex color structures such as
* ColorGradient.
*/
class ColorRGB {
  public float r, g, b;
  public float alpha = 255.0;

  ColorRGB (float r, float g, float b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  ColorRGB (float r, float g, float b, float alpha) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.alpha = alpha;
  }

  ColorRGB() {
    this.r = 0;
    this.g = 0;
    this.b = 0;
  }

  color toColor() {
    return color(r, g, b, alpha);
  }
}

/**
* The ColorGradient is an iterator for a gradient of colors.
* We need to provide the start and end of the gradient, and the number of colors
* in between, and the class has the Iterator interface which makes it
* very handy to use inside loops for example.
*/
class ColorGradient implements Iterator<ColorRGB>{
  ColorRGB start, end;
  int numColors;
  int gradientMode; // either 0 (default iteration method) or 1 (pyramid iteration method)
  public ArrayList<ColorRGB> gradient;
  public int indexCycle = 0;
  int auxV = 1; // to invert the counting method (only used for gradientMode = 1)

  
  ColorGradient (ColorRGB start, ColorRGB end, int numColors) {
    this.start = start;
    this.end= end;
    this.numColors = numColors;
    this.gradient = calculateColorGradient();
    this.gradientMode = 0;
  }

  ColorGradient (ColorRGB start, ColorRGB end, int numColors, int mode) {
    this.start = start;
    this.end= end;
    this.numColors = numColors;
    this.gradient = calculateColorGradient();
    this.gradientMode = mode;
  }
  
  ArrayList<ColorRGB> calculateColorGradient() {
    ArrayList<ColorRGB> cList = new ArrayList<ColorRGB>();
    float alpha = 0;
    for(int i=0; i < numColors; i++){
      ColorRGB newColor = new ColorRGB();
      // I don't remember where I got this...
      alpha += (1.0/numColors);
      newColor.r = start.r*alpha + (1 - alpha) * end.r;
      newColor.g = start.g*alpha + (1 - alpha) * end.g;
      newColor.b = start.b*alpha + (1 - alpha) * end.b;
      cList.add(newColor);
    }
    return cList;
  }

  public ColorRGB next() {
    ColorRGB nextColor = gradient.get(indexCycle%numColors);
    if (gradientMode == 0) {
        indexCycle++;    
    } else if (gradientMode >= 1) {
        indexCycle += auxV;
        if (indexCycle == (numColors - 1))
            auxV = -1;
        if (indexCycle == 0)
            auxV = 1;
    }
    return nextColor;
  }
  // always have next color
  public boolean hasNext() {
    return true;
  }
}