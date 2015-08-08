import gifAnimation.*;

GifMaker gifMaker;

//Constants
static final int HMAX = 360, SMAX = 100, BMAX = 100, AMAX = 100;

static final String LOAD_MSG = "NOW LOADING";  //loading message
static final int FPS = 50;  //animation speed (FPS)
static final int BLINK = 2;  //seconds
static final int LOADSPD = BLINK * 3;  //seconds
static final int ROTATE = 1;  //seconds

//static member variables
//message
color font_color;
int font_width = 0;
int font_height = 0;
int font_adjY = -50;  //adjust the vertical coodination (-:up, +:down)
int weightOutline = 3;

//circuls rotation
color circle_color;
int circle_num = 5;
int circle_dmt = 10;
int rot_dist = 20;
int rot_adjY = -5;

//progress bar indicator
color bar_color;
int bar_width = 150;
int bar_height = 20;
int bar_adjY = 50;  //adjust the vertical coodination (-:up, +:down)

void setup() {
  //application setting
  size(200, 200, P2D);
  frameRate(FPS);  //set frame speed
  colorMode(HSB, HMAX, SMAX, BMAX, AMAX);  //specify color with HUE(0 ~ 360), SATURATION(0 ~ 100), BRIGHTNESS(0 ~ 100)
  noStroke();  //no outline by all figures

  //message configuration
  PFont font = loadFont("DaunPenh-48.vlw");
  textFont(font, 32);
  font_color = color(0, 0, 100);
  font_width = (int)textWidth(LOAD_MSG);  //width of the message text
  font_height = (int)(textAscent() + textDescent());  //height of the message text
  
  //circles rotation configuration
  circle_color = color(180, 60, 80);
  
  //bar indicator configuration
  bar_color = color(120, 100, 100);
  
  gifMaker = new GifMaker(this, "Loading.gif");
  gifMaker.setRepeat(0);
  gifMaker.setDelay(20);  //50fps (20ms)
}

void draw() {
  //parameters
  float param = 0;
  int temp = 0;
  int limit = 0;  //limitation of loop(how many times does it repeat for-loop)
  int x = 0, y = 0;  //top left to draw figures
  
  //background color
  background(0);

  //text message
  temp = BLINK * FPS;
  param = frameCount % temp - temp / 2;  //param as alpha value
  param /= temp / 2;
  
  fill(font_color, AMAX - AMAX * param * param);  //set alpha
  text(LOAD_MSG, (width - font_width) / 2, (height - font_height) / 2 + font_adjY);
  
  //circles rotation
  temp = FPS * ROTATE;
  param = frameCount % temp;
  param *= TWO_PI / temp;
  
  pushMatrix();
  translate(width / 2, height / 2 + rot_adjY);;
  rotate(param);
  for(int i = 0; i < circle_num; i++){
    color c = lerpColor(color(hue(circle_color), 10, 100), circle_color, i / (float)circle_num);
    fill(c);
    ellipse(0, -rot_dist, circle_dmt, circle_dmt);
    rotate(QUARTER_PI);
  }
  popMatrix();
  
  //progress bar indicator
  //background
  x = (width - bar_width) / 2 - weightOutline;
  y = height / 2 + bar_adjY - weightOutline;
  limit = bar_height + weightOutline * 2;
  
  for(int i = 0; i < limit; i++){
    color c = lerpColor(color(0, 0, 20), color(0, 0, 90), sin(PI * i / limit - QUARTER_PI));
    fill(c);
    rect(x, y + i, bar_width + weightOutline * 2, 1);
  }
  
  //foreground
  //x = (width - bar_width) / 2;
  y = height / 2 + bar_adjY;
  limit = bar_height;
  temp = LOADSPD * FPS;
  param = (frameCount % temp) / (float)temp;
  
  for(int i = 0; i < limit; i++){
    color c = color(hue(bar_color), 100, 50);
    c = (i >= 2 && i <= 4) ? color(hue(bar_color), 25, 100) : lerpColor(c, bar_color, cos(PI * i / limit - QUARTER_PI));
    fill(c);
    rect(x, y + i, (bar_width + weightOutline * 2) * param, 1);
  }
  
  //create GIF file
  gifMaker.addFrame();
  if(frameCount >= (LOADSPD * FPS)){  //pass 100 frames in the program
    gifMaker.finish();  //finish making GIF animation
    //exit();
  }
}
