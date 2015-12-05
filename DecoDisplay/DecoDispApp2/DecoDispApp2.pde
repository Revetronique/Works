/*Libraries*/
import processing.serial.*;
import controlP5.*;  //necessary to install library in advance

/*Constants*/
static final int TopLeftX = 10;
static final int TopLeftY = 20;

static final int NUM = 8;
static final int PICS = 16;
int CELWID = 25;

/*Global Fields*/
Serial port;

char mode = 'D';  //M: manual drawing, P: typograph, A: animation, D: default

//manual drawing
boolean[][] flag = new boolean[NUM][NUM];

//animation
long[] animePics = new long[PICS];
byte numPic = 1;
byte selPic = 1;

//text
String typedText = "";
int textcursor = 0;

ControlP5 cp5;

void setup()
{
  //Window Configuration
  size(250, 300);
  ellipseMode(CORNER);
  noStroke();
  
  //Avoid Exception(there's no available serial port)
  if(Serial.list().length <= 0) {
    noLoop();
    javax.swing.JOptionPane.showMessageDialog(null, "No available serial port.");
    exit();
  }

  //Serial communication setting
  println(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);
  
  //generate random seed
  randomSeed(0);
  
  //graphic user interface
  cp5 = new ControlP5(this);
  
  //add tab menu
  cp5.addTab("manual")
     .setColorBackground(color(0, 160, 100))
     .setColorLabel(color(255))
     .setColorActive(color(255,128,0))
     ;
  cp5.addTab("typing")
     .setColorBackground(color(0, 160, 100))
     .setColorLabel(color(255))
     .setColorActive(color(255,128,0))
     ;
  cp5.addTab("anime")
     .setColorBackground(color(0, 160, 100))
     .setColorLabel(color(255))
     .setColorActive(color(255,128,0))
     ;
  
  //configurate tab setting
  cp5.getTab("default")
     .activateEvent(true)
     .setLabel("my default tab")
     .setId(0)
     ;
  cp5.getTab("manual")
     .activateEvent(true)
     .setId(1)
     ;
  cp5.getTab("typing")
     .activateEvent(true)
     .setId(2)
     ;
  cp5.getTab("anime")
     .activateEvent(true)
     .setId(3)
     ;
  
  //text animation
  cp5.addButton("Flyout")
     .setBroadcast(false)
     .setPosition(10,250)
     .setSize(50,30)
     .setValue(2)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.addButton("Cutoff")
     .setBroadcast(false)
     .setPosition(80,250)
     .setSize(50,30)
     .setValue(2)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  //picture flash
  cp5.addButton("FlashPics")
     .setBroadcast(false)
     .setPosition(10,250)
     .setSize(50,30)
     .setValue(2)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.addButton("Prev")
     .setBroadcast(false)
     .setPosition(90,250)
     .setSize(20,30)
     .setValue(2)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.addButton("Next")
     .setBroadcast(false)
     .setPosition(120,250)
     .setSize(20,30)
     .setValue(2)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.addButton("Add")
     .setBroadcast(false)
     .setPosition(160,250)
     .setSize(30,30)
     .setValue(2)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.addButton("Del")
     .setBroadcast(false)
     .setPosition(200,250)
     .setSize(30,30)
     .setValue(2)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
     
  cp5.getController("Flyout").moveTo("typing");
  cp5.getController("Cutoff").moveTo("typing");
  
  cp5.getController("FlashPics").moveTo("anime");
  cp5.getController("Next").moveTo("anime");
  cp5.getController("Prev").moveTo("anime");
  cp5.getController("Add").moveTo("anime");
  cp5.getController("Del").moveTo("anime");
}

void draw()
{
  background(10);
  
  if(mode == 'D'){
    //do nothing
    fill(255);
    textSize(24);
    text("Click Here!", 50, height/2);
  }
  else if(mode == 'M'){
    fill(255);
    textSize(16);
    text("Select dots to draw pictures.", 10, height - 50);
    text("(LEFT: ON/OFF, RIGHT: CLEAR)", 10, height - 30);
    
    for(int j = 0; j < NUM; j++){
      int posY = TopLeftY + CELWID * j;
      
      for(int i = 0; i < NUM; i++){
        int posX = TopLeftX + CELWID * i;
        
        if(flag[i][j] == true)
          fill(color(0, 100, 255, 150));
        else                  
          fill(color(128, 128, 128, 128));
        
        ellipse(posX, posY, CELWID, CELWID);
      }
    }
  }
  else if(mode == 'P'){    
    fill(255);
    textSize(16);
    text(typedText.substring(0, textcursor) + (frameCount/6 % 2 == 0 ? "|" : " ") + typedText.substring(textcursor, typedText.length()), TopLeftX, TopLeftY, width - 2 * TopLeftX, height);
    
    text("Type your desired message.", 10, height - 80);
  }
  else if(mode == 'A'){    
    fill(255);
    textSize(12);
    text("ALL", width - 30, 40);
    text(numPic, width - 30, 60);
    text("NOW", width - 30, 80);
    text(selPic, width - 30, 100);
    
    for(int j = 0; j < NUM; j++){
      int posY = TopLeftY + CELWID * j;
      
      for(int i = 0; i < NUM; i++){
        int posX = TopLeftX + CELWID * i;
        long shift = (long)1 << (j * NUM + i);
        
        if((animePics[selPic - 1] & shift) != 0)
          fill(color(0, 100, 255, 150));
        else                  
          fill(color(128, 128, 128, 128));
        
        ellipse(posX, posY, CELWID, CELWID);
      }
    }
  }
}