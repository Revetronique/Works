import java.util.Iterator;

ArrayList<CharBullet> danmaku;
int colnum = 0, fontnum = 0;

String[] fontName = {
  "ASKaiSho-Bd",
  "Bermuda_Script",
  "BradleyHandITC",
  "Georgia-Italic",
  "Germany",
  "HGSMinchoE",
  "Vijaya-Bold",
  "富士ポップＰ"
};

PFont[] font = new PFont[fontName.length];

color[] col = {
  color(255),
  color(255, 0, 0),
  color(0, 255, 0),
  color(0, 0, 255),
  color(255, 255, 0),
  color(255, 0, 255),
  color(0, 255, 255)
};

void setup(){
  size(640, 480);
  //size(displayWidth, displayHeight);
  
  danmaku = new ArrayList<CharBullet>();
  for(int i = 0; i < font.length; i++){
    font[i] = createFont(fontName[i], 32);
  }
}

void draw(){
  background(0);
  
  Iterator<CharBullet> i = danmaku.iterator();
  
  while(i.hasNext()){
    CharBullet cb = i.next();
    
    if(mousePressed){
      if(mouseButton == RIGHT)  cb.shft = 5.0; 
      else if(mouseButton == LEFT)  cb.shft = 0.2;
    }
    else{
      cb.shft = 1.0;
    }
    
    if(cb.update()){
      i.remove();
    }
    else{
      cb.showChar();
    }
  }
}

void keyPressed(){
  if(key == CODED){
    switch(keyCode){
      case UP:
        colnum = (colnum + 1) % col.length;
        break;
      case DOWN:
        colnum = (colnum - 1 + col.length) % col.length;
        break;
      case RIGHT:
        fontnum = (fontnum + 1) % font.length;
        break;
      case LEFT:
        fontnum = (fontnum - 1 + font.length) % font.length;
        break;
      default:
        break;
    }
  }
  else{
    danmaku.add(new CharBullet(key));
  }
}

class CharBullet
{
  char tama;
  int x, y, speed, tSize;
  public float shft = 1.0;
  
  CharBullet(char _tama){
    randomSeed(millis());  //generate a seed for random number
    
    tama = _tama;
    tSize = (int)random(20, 80);
    
    x = (int)random(0, 10);
    y = (int)random(10, height - 10);
    speed = (int)random(10, 50);
  }
  
  void showChar(){
    fill(col[colnum]);
    textFont(font[fontnum], tSize);
    text(tama, x, y);
  }
  
  boolean update(){
    int dx = (int)(speed * shft);
    
    if(dx < 1)  x += 1;
    else  x += dx;
    
    if(x > width)  return true;
    else  return false;
  }
}
