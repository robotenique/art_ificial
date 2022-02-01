
import java.util.Iterator;
import java.lang.Math;
import java.util.Random;
ArrayList<TriangleStore> triangles;
int numBrushes;
// TriangleStore t;
TriangleStore t1, t2;
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

float c = 0.001;
void setup(){
  size(1920, 1150); // window size
  background(0); // black background
  frameRate(60); // 60 frames per second
  int numTriangles = 10;
  float triangleSide = (float)((2/Math.sqrt(3))*(height/numTriangles)); // height is side*(sqrt(3)/2)
  float startYaxis = 0;
  triangles = new ArrayList<TriangleStore>();
  Random randomno = new Random();
  for (int i = 0; i < numTriangles; ++i) {
    println(i);
    triangles.add(
      new TriangleStore(
        triangleSide,
        startYaxis,
        (float)(randomno.nextGaussian()*(width/10) - width/2.5),
        new ColorGradient(new ColorRGB(255, 255, 255), new ColorRGB(0, 0, 0), 200, 1),
        new ColorGradient(new ColorRGB(150,(i*50)%255, 100 + (i*20)%255), new ColorRGB(10, (((i - numTriangles/2)^2)*40)%255, (i*20)%255), 10+i*(10), 1),
        false
      )
    );
    startYaxis += triangleSide*Math.sqrt(3)/2;
  }
}


void draw(){
  fill(250, 5);
  rect(0, 0, width, height);
  for (TriangleStore innerT : triangles) {
      innerT.draw();
      // t1.draw();
      // t2.draw();
  }
}


class TriangleStore{
    public float tx1, ty1, tx2, ty2, tx3, ty3;;
    public float p1, p2;
    public double tLength;
    float speedOffset, rd2;
    boolean withStroke;
    ColorGradient cgOutline, cgInline;


    TriangleStore(float tLength, float verticalOffset, float horizontalOffset, ColorGradient cg, ColorGradient cgIn, boolean withStroke) {
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

        // wether to display a stroke or not
        this.withStroke = withStroke;
        this.speedOffset = random(-0.1, 0.2);
        this.rd2 = random(0, 0.5);
    }


    void draw() {
        push();
        ColorRGB dummyC;
        dummyC = cgOutline.next();
        stroke(dummyC.r, dummyC.g, dummyC.b);
        dummyC = cgInline.next();
        fill(dummyC.r, dummyC.g, dummyC.b, 255);
        translate(p1, p2);
        if (!withStroke)
          noStroke();
        rotate(rd2*0.02*millis()*PI/3);
        triangle(tx1, ty1, tx2, ty2, tx3, ty3);
        
        strokeWeight(2);
        stroke(10, 10, 40);
        line(tx1, ty1, tx2, ty2);
        stroke(10, 10, 40);
        line(tx2, ty2, tx3, ty3);
        stroke(250, 230, 230);
        line(tx3, ty3, tx1, ty1);
        this.self_adjust();
        pop();
    }

    void self_adjust(){
        float adjFactor = (0.01*speedAdjuster(millis()*rd2));
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