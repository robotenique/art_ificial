void setup() {
    size(1150, 1150);
    background(0);
    noFill();
    //noSmooth();
    noStroke();
    smooth(10);
    strokeWeight(4);
    
    //stroke(255);

}

void draw() {
    background(0);
    translate(width / 2, width / 2);
    int maxDepthMapped = int(map(mouseX, 0, width, 1, 5));
    int nSplitsMapped = int(map(mouseY, 0, height, 3, 20));
    stroke(255);
    CircleRecurrence c = new CircleRecurrence(0, 0, 300, 300, 0, new GlobalVariables(maxDepthMapped, nSplitsMapped));
    c.show();
    noLoop();
}

void mouseMoved(){
  loop();
}

// gambiarra elegante
class GlobalVariables {
    public int maxDepth, nSplits;
    final static int maxDepthHardcap = 10;
    final static int maxNSplitsHardcap = 20;
    GlobalVariables(int maxDepth, int nSplits) {
        this.maxDepth = min(maxDepth, maxDepthHardcap);
        this.nSplits = min(nSplits, maxNSplitsHardcap);
    }
}
