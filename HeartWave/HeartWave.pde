//number of points of the graph shown simultaneously
static final int showPoints = 30;

//number of offset points which interpolate the former and latter area of the graph
static final int offsetNum = 50;

//array value of heartbeat graph
static final float[] graphVal = new float[]{
  0.521, 0.521, 0.521, 0.521, 0.521, 0.521, 0.521, 0.521, 0.521, 0.521,
  0.521, 0.521, 0.521, 0.521, 0.521, 0.522, 0.524, 0.527, 0.53, 0.533,
  0.536, 0.538, 0.54, 0.541, 0.54, 0.539, 0.536, 0.534, 0.53, 0.526,
  0.581, 0.649, 0.719, 0.767, 0.719, 0.676, 0.63, 0.59, 0.565, 0.527,
  0.493, 0.475, 0.448, 0.447, 0.475, 0.498, 0.511, 0.515, 0.52, 0.523,
  0.525, 0.526, 0.526, 0.526, 0.526, 0.526, 0.526, 0.526, 0.526, 0.526,
  0.526, 0.527, 0.528, 0.531, 0.533, 0.536, 0.54, 0.545, 0.549, 0.553,
  0.555, 0.558, 0.559, 0.559, 0.556, 0.553, 0.546, 0.541, 0.536, 0.532,
  0.53, 0.527, 0.524, 0.522, 0.521, 0.521, 0.521, 0.521, 0.521, 0.521,
  0.521, 0.521, 0.521, 0.521, 0.521, 0.521, 0.521, 0.521, 0.521, 0.521
};

int count = 0;

void setup(){
  size(640, 480);
  //frameRate(30);
  frameRate(graphVal.length + offsetNum * 2);
  smooth();
  
  blendMode(ADD);
}

void draw(){
  background(0);
  
  float dx = width / float(graphVal.length + offsetNum * 2);
  
  for(int i = 0; i < graphVal.length + offsetNum * 2; i++){
    if(i >= count && i < count + showPoints){
      if(i < offsetNum){
        //growBall(dx * i, height - graphVal[0] * height, 10, color(0, 255, 0, 3));
        growLine(dx * i, height - graphVal[0] * height, dx * (i + 1), height - graphVal[0] * height, 30, color(0, 255, 0, 5));
        
        strokeWeight(2);
        stroke(0, 255, 0);
        line(dx * i, height - graphVal[0] * height, dx * (i + 1), height - graphVal[0] * height);
        
      }
      else if(i >= offsetNum + graphVal.length - 2){
        //growBall(dx * i, height - graphVal[graphVal.length - 1] * height, 10, color(0, 255, 0, 3));
        growLine(dx * i, height - graphVal[graphVal.length - 1] * height, dx * (i + 1), height - graphVal[graphVal.length - 1] * height, 30, color(0, 255, 0, 5));
        
        strokeWeight(2);
        stroke(0, 255, 0);
        line(dx * i, height - graphVal[graphVal.length - 1] * height, dx * (i + 1), height - graphVal[graphVal.length - 1] * height);
      }
      else{
        //growBall(dx * i, height - graphVal[i - offsetNum] * height, 10, color(0, 255, 0, 3));
        growLine(dx * i, height - graphVal[i - offsetNum] * height, dx * (i + 1), height - graphVal[i - offsetNum + 1] * height, 30, color(0, 255, 0, 5));
        
        strokeWeight(2);
        stroke(0, 255, 0);
        line(dx * i, height - graphVal[i - offsetNum] * height, dx * (i + 1), height - graphVal[i - offsetNum + 1] * height);
      }
    }
  }
  
  count++;
  if(count >= graphVal.length + offsetNum * 2){
    count = 0;
  }
  
  //for creating a movie
  saveFrame("frames/######.tif");
  if(frameCount == 200){
    exit(); 
  }
}

void growLine(float x1, float y1, float x2, float y2, int wt, color c){
  strokeCap(ROUND);
  strokeWeight(wt);
  stroke(c);
  
  line(x1, y1, x2, y2);
}

void growBall(float w, float h, int r, color c){
  noStroke();
  fill(c);
  
  //filter(BLUR, 6);
  ellipse(w, h, r, r);
}