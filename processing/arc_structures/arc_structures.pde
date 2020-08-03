ArcStructure[][] arcVector;
int nArcs, nColors;
float scale;
void setup() {
    size(1150, 1150);
    background(0);
    noFill();
    strokeWeight(2);
    smooth(2);
    nArcs = 3;
    nColors = 7;
    arcVector = new ArcStructure[nArcs][nArcs];
    scale = width / nArcs;

    for (int i = 0; i < nArcs; i++) {
        for (int j = 0; j < nArcs; j++) {
            arcVector[i][j] = new ArcStructure((1 + i)*width/nArcs - scale/2, (1 + j)*height/nArcs - scale/2, 30, i, i, j);
            //arcVector[i][j] = new ArcStructure(width / 2, height / 2, 10, i, i, j);
        }
    }
}

void draw() {
    for (int i = 0; i < nArcs; i++) {
        for (int j = 0; j < nArcs; j++) {
            arcVector[i][j].update();
            arcVector[i][j].draw();
        }
    }
    saveIfNeeded();
}

void saveIfNeeded() {
    if (keyPressed) {
        if (key == 's') {
            saveFrame("arc-#####.png");
        }
    }
}

class ArcStructure {
    float x0, y0, radius, thetaStart, thetaEnd, thetaStartReverse, thetaEndReverse;
    float oldx0, oldy0, origx0, origy0;
    float acc = 0;
    float t;
    color arcColor;
    int iteration;
    int switchVariable = 0;
    float pathVariable;


    ArcStructure(float x0, float y0, float radius, int iteration, int row, int col) {
        this.x0 = x0;
        this.y0 = y0;
        this.origx0 = x0;
        this.origy0 = y0;
        this.oldx0 = x0 - radius / 10;
        this.oldy0 = y0;
        this.radius = radius;
        this.thetaStart = HALF_PI + 2 * HALF_PI / 2;
        this.thetaEnd = PI / 1.5 + 3 * HALF_PI / 10;
        this.thetaStartReverse = (HALF_PI + (iteration - 1 - 3) * HALF_PI / 2) % TWO_PI;
        this.thetaEndReverse = (PI / 1.5 + (iteration - 1 - 3) * HALF_PI / 10) % TWO_PI;
        this.arcColor = color(50 + 30 + 255 * random(0, 1.1), 80, 50 + 255 * random(0, 1.1));
        this.iteration = iteration;
        this.pathVariable = calculatePathVariable(row, col);
        println(pathVariable);
    }

    ArcStructure(float x0, float y0, float radius, int iteration, int row, int col, color c) {
        this.x0 = x0;
        this.y0 = y0;
        this.origx0 = x0;
        this.origy0 = y0;
        this.oldx0 = x0 - radius / 10;
        this.oldy0 = y0;
        this.radius = radius;
        this.thetaStart = HALF_PI + 2 * HALF_PI / 2;
        this.thetaEnd = PI / 1.5 + 3 * HALF_PI / 10;
        this.thetaStartReverse = (HALF_PI + (iteration - 1 - 3) * HALF_PI / 2) % TWO_PI;
        this.thetaEndReverse = (PI / 1.5 + (iteration - 1 - 3) * HALF_PI / 10) % TWO_PI;
        this.arcColor = c;
        this.iteration = iteration;
        this.pathVariable = calculatePathVariable(row, col);
        println(pathVariable);
    }

    float calculatePathVariable(int row, int col) {
        return max(abs(10 * sin(30 * row) + 1) + abs(10 * cos(30 * col) + 1), 6);

    }

    void draw() {
        stroke(arcColor);
        //arc(x0, y0, radius, radius, thetaStart, thetaEnd);
        push();
        stroke(arcColor, 155);
        point(x0, y0);
        stroke(arcColor, 100);
        point(oldx0, oldy0);
        pop();
        //fill(255, 30);
        //arc(oldx0, oldy0, radius, radius, thetaStartReverse, thetaEndReverse);
    }

    void update() {
        t += 0.0006;
        updateCenter(t);
        //radius -= 0.0001;
        this.thetaStart += 0.005;
        this.thetaEnd += 0.005;
        this.thetaStartReverse += 0.005;
        this.thetaEndReverse += 0.005;
    }

    void updateCenter(float t) {
        //float wiggleX = (map(1 + abs(sin(150*t)), 1, 2, 0.95, 1));
        float wiggleY = (map(1 + abs(cos(1000*t)), 1, 2, 0.97, 1.07));
        float wiggleX = 1;
        //float wiggleY = 1;
        this.x0 = origx0 + scale/2 * sin(pathVariable * PI * t) * wiggleX;
        this.y0 = origy0 + scale/2 * cos(7 * PI * t) * wiggleY;
        this.oldx0 = x0 - radius / 10;
        this.oldy0 = y0;
    }

}
