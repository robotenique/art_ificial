import java.util.Iterator;
void setup(){
  size(1150, 1150);
  int n = 4;
  float scale = width/n;
  ColorRGB start = new ColorRGB(23, 181, 5) ;
  ColorRGB end = new ColorRGB(122, 51, 10);
  ColorGradient cg = new ColorGradient(start, end, n*n);
  for(int i=0; i < n; i++){
    for(int j=0; j < n; j++){
      fill(cg.next().toColor());
      stroke(0);
      strokeWeight(4);
      rect(scale*i, scale*j, scale, scale);
    }
  }
  
}

void draw() {
  
}

// Color related classes
//import java.util.Iterator;
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
