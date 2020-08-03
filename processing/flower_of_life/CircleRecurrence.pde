class CircleRecurrence {
    float x0, y0, radiusA, radiusB;
    int depth = 0;
    GlobalVariables currGlobalVariables;

    CircleRecurrence(float x, float y, float radius, float radius2, int depth, GlobalVariables gv) {
        x0 = x;
        y0 = y;
        radiusA = radius;
        radiusB = radius2;
        this.depth = depth;
        this.currGlobalVariables = gv;
    }

    void show() {
        // plot itself
        ellipse(x0, y0, radiusA, radiusB);
        // plot all other circles around it
        if (depth < currGlobalVariables.maxDepth) {
          //float ratioReduction = min(pow(0.9, -((pow(depth, 2))/8)) - 0.3, 1.0);
          float ratioReduction = max(-0.024*(pow(depth, 2)/0.1) + 1, -0.031*depth + 0.7);
            for (int i = 0; i < currGlobalVariables.nSplits; i++) {
                float theta = (i + 1) * (TWO_PI / currGlobalVariables.nSplits);
                CircleRecurrence currCircle = new CircleRecurrence(x0 + (radiusA/2) * sin(theta),
                    y0 + (radiusA/2) * cos(theta),
                    radiusA*ratioReduction,
                    radiusB*ratioReduction,
                    depth + 1,
                    this.currGlobalVariables);
                    fillColor2(theta);

                currCircle.show();
            }
        }
    }
    
    private void fillColor(){
      float rComp = abs(sin(1+depth/(0.101*currGlobalVariables.maxDepth*PI)));
      float gComp = abs(cos(1+depth/(0.101*currGlobalVariables.maxDepth*PI)));
      float bComp = abs(cos(1+depth - 2/(0.101*currGlobalVariables.maxDepth*PI)));
      fill(rComp*255, gComp*255, bComp*255, rComp*20);
    }
    
    private void fillColor2(float theta){
      float rComp = abs(sin(pow(theta, 1.8)/2));
      float gComp = abs(sin(theta));
      float bComp = abs(sin(sin(theta)/(0.5*theta)));
      //stroke(rComp*255, gComp*40, bComp*255, 255/(1+depth));
      stroke(0, 255/(1+depth));
      fill(rComp*255, gComp*40, bComp*255, 255/(1+depth/3));
    }

}
