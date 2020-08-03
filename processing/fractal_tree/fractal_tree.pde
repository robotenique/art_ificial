import java.util.Iterator;
float branchHeight;
int maxDepth = 10;
FractalTree fc;
void setup(){
  size(1150, 1150);
  background(0);
  branchHeight = height/12;
  ColorRGB start = new ColorRGB(23, 181, 5) ;
  ColorRGB end = new ColorRGB(122, 49, 0);
  ColorGradient cg = new ColorGradient(start, end, maxDepth + 1); 

  fc = new FractalTree(width/2, height, cg);
}

void draw(){
  background(0);
  fc.draw();
}

class FractalTree {
  int depth = 0;
  float x0, y0, bHeight, angleRotationMultiplier;
  FractalTree children1, children2;
  int hasChildren = 0;
  ColorGradient cg;
  
  FractalTree (float x0, float y0, ColorGradient cg) {
    this.x0 = x0;
    this.y0 = y0;
    this.cg = cg;
  }
  
  FractalTree (float x0, float y0, float bHeight, float angleRotationMultiplier, ColorGradient cg, int depth) {
    this.x0 = x0;
    this.y0 = y0;
    this.bHeight = bHeight;
    this.angleRotationMultiplier = angleRotationMultiplier;
    this.depth = depth;
    this.cg = cg;
  }
  
  
  void draw() {
    if (depth == 0) {
      this.bHeight = map(mouseY, 0, height, height/5, height/12);
      this.angleRotationMultiplier = map(mouseX, 0, width, PI/10, PI/4);
    }
    stroke(cg.gradient.get(depth).toColor());
    strokeWeight(max(-0.7*depth + 10, 0));
    translate(x0, y0);
    line(0, 0, 0, -bHeight);
    translate(0, -bHeight);
    push();
    rotate(angleRotationMultiplier);
    line(0, 0, 0, -bHeight);
    if(depth < maxDepth) {
      children1 = new FractalTree(0, -bHeight, bHeight*0.67, angleRotationMultiplier, cg, depth + 1);
      children1.draw();
    }
    pop();
    push();
    rotate(-angleRotationMultiplier);
    line(0, 0, 0, -bHeight);
    if(depth < maxDepth) {
      children2 = new FractalTree(0, -bHeight, bHeight*0.67, angleRotationMultiplier, cg, depth + 1);
      children1.draw();
    } 
    pop();

  }

}

// Color related classes

class ColorRGB {
  public float r, g, b;
  ColorRGB (float r, float g, float b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
  ColorRGB() {
    this.r = 0;
    this.g = 0;
    this.b = 0;
  }
  
  color toColor() {
    return color(r, g, b);
  }
}

class ColorGradient implements Iterator<ColorRGB>{
  ColorRGB start, end;
  int numColors;
  public ArrayList<ColorRGB> gradient;
  int indexCycle = 0;
  
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
