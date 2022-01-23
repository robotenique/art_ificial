 import java.util.Iterator;
ArrayList<NoisyBrush> brushList;

void setup(){
  size(1920, 1150); // window size
  background(0); // black background
  frameRate(120); // 60 frames per second
  noStroke(); // remove the outline
  brushList = new ArrayList<NoisyBrush>();
  float defaultInc = 0.001;
  float defaultxoff = 0.0;
  float defaultyoff = 5.0;
  NoisyBrush[] suit = {
    new NoisyBrush(
      defaultxoff,
      defaultyoff,
      defaultInc,
      new ColorRGB(255, 0, 0),
      new ColorRGB(255, 230, 0),
      500
    ),
    new NoisyBrush(
      defaultxoff + 5,
      defaultyoff - 3,
      defaultInc,
      new ColorRGB(255, 255, 200),
      new ColorRGB(255, 0, 0),
      100
    )
  };

  for (NoisyBrush nb : suit) {
    brushList.add(nb);
  }

  // brushList.add(new NoisyBrush(new ColorRGB(255.0, 255.0, 255.0), new ColorRGB(100.0, 100.0, 255.0), 10));
  // brushList.add(new NoisyBrush(new ColorRGB(255.0, 0.0, 255.0), new ColorRGB(100.0, 100.0, 255.0), 10));


  // nb = new NoisyBrush(new ColorRGB(255.0, 255.0, 255.0), new ColorRGB(100.0, 100.0, 255.0), 10);
}

void draw(){
  // alpha background
  fill(0, 5);
  rect(0, 0, width, height);
  for (NoisyBrush nb : brushList) 
    nb.draw();
  
}


// single Entity Object
class NoisyBrush {
  float xoff = 0.0;
  float yoff = 5.0;
  float xincrement = 0.005;
  ColorRGB start;
  ColorGradient innerColors;
  int sizeW = 25;
  int auxV = 1; // to invert the counting method
  int nColors;

  NoisyBrush (float xoff, float yoff, float xincrement, ColorRGB start, ColorRGB end, int nColors) {
    this.xoff = xoff;
    this.yoff = yoff;
    this.xincrement = xincrement;
    this.start = start;
    this.innerColors = new ColorGradient(start, end, nColors);
    this.nColors = nColors;
    sizeW = int(random(25, 50));
  }

   NoisyBrush (ColorRGB start, ColorRGB end, int nColors) {
    this.start = start;
    this.innerColors = new ColorGradient(start, end, nColors);
  }


  void draw() {
    float noiseVal = noise(xoff)*width;
    float noiseValHeight = noise(yoff)*height;
    xoff += xincrement;
    yoff += xincrement;
    push();
    ColorRGB a = innerColors.gradient.get((innerColors.indexCycle%innerColors.gradient.size()));
    fill(a.toColor());
    // directly manipulating the gradient to iterate in a different
    // order than the default implementation
    if (sin(xoff*0.00001) > 0){
      innerColors.indexCycle += auxV;
      if (innerColors.indexCycle == (nColors - 1))
        auxV = -1;
      if (innerColors.indexCycle == 0)
        auxV = 1;
    }
      
    ellipse(noiseVal, noiseValHeight, sizeW*(abs(sin(millis()*0.001)) +0.5), sizeW*(abs(cos(millis()*0.001)) +0.5));
    pop();
  }

}

// aux functions
int signum(float f) {
  if (f > 0) return 1;
  if (f < 0) return -1;
  return 0;
}

float squareWave(float x) {
  return signum(sin(PI*x));
}

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
  public ArrayList<ColorRGB> gradient;
  public int indexCycle = 0;
  
  ColorGradient (ColorRGB start, ColorRGB end, int numColors) {
    this.start = start;
    this.end= end;
    this.numColors = numColors;
    this.gradient = calculateColorGradient();
  }
  
  ArrayList<ColorRGB> calculateColorGradient() {
    ArrayList<ColorRGB> cList = new ArrayList<ColorRGB>();
    float alpha = 0;
    for(int i=0; i < numColors; i++){
      ColorRGB newColor = new ColorRGB();
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
    indexCycle++;
    return nextColor;
  }
  // always have next color
  public boolean hasNext() {
    return true;
  }
}