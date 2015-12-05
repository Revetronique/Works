//Arduinoのシリアル通信バッファは標準で64byte
//シリアルバッファを256byteに変更する方法 (今回はPro Miniのみ)
//[予め、元のファイルをコピーしておくこと]
//1. hardware/arduino/cores/arduinoにあるHardwareSerial.hのバッファサイズを64->256に変更
//2. boards.txtのbuild.coreを新しく作成したファイルがあるフォルダに指定(コピーを作成した場合)
//https://www.facebook.com/ArduinoUNO1/posts/877606578958580

#include <Wire.h>
#include "Adafruit_LEDBackpack.h"
#include "Adafruit_GFX.h"

const int NUM = 8;

Adafruit_8x8matrix matrix = Adafruit_8x8matrix();

char mode = 'D';  //M: manual drawing, P: picture select, A: animation, D: default

byte bmpNum = 0;

boolean flag[8][8];  //自由描画用

byte animeDat[16][8];  //アニメーションのコマ
int lenPic = 1;      //コマ数

String message = "Hello";
int lenMsg = 5;
byte effectMsg = 1;

void setup()
{
  Serial.begin(9600);
  while(!Serial){}
  //Serial.setTimeout(3000);  //シリアル通信のタイムアウト; 1000msがデフォルト
  
  matrix.begin(0x70);
  
  // Seed random number generator from an unused analog input:
  randomSeed(analogRead(A0));
}

//初回は必ず書き込むこと
static const uint8_t PROGMEM
  smile_bmp[] =
  { B00111100,
    B01000010,
    B10100101,
    B10000001,
    B10100101,
    B10011001,
    B01000010,
    B00111100 },
  neutral_bmp[] =
  { B00111100,
    B01000010,
    B10100101,
    B10000001,
    B10111101,
    B10000001,
    B01000010,
    B00111100 },
  frown_bmp[] =
  { B00111100,
    B01000010,
    B10100101,
    B10000001,
    B10011001,
    B10100101,
    B01000010,
    B00111100 },
  niku_bmp[] = 
  { B00011000,
    B11111111,
    B10011001,
    B10100101,
    B10000001,
    B10011001,
    B10100101,
    B10000001 };
    
void loop()
{
  //シリアル通信
  //1. モード選択<文字列入力、自由描画、アニメーション>
  //2. データ通信
  //描画
  //複数のLEDをつなげて描画する機能
  //Processing or Androidアプリ
  //入力画面
  
  //デフォルト描画
  if(mode == 'D'){
    matrix.clear();
    switch(bmpNum){
      case 0:
        matrix.drawBitmap(0, 0, niku_bmp, 8, 8, LED_ON);
        break;
      case 1:
        matrix.drawBitmap(0, 0, smile_bmp, 8, 8, LED_ON);
        break;
      case 2:
        matrix.drawBitmap(0, 0, frown_bmp, 8, 8, LED_ON);
        break;
      case 3:
        matrix.drawBitmap(0, 0, neutral_bmp, 8, 8, LED_ON);
        break;
    }
    matrix.writeDisplay();
  }
  //自由描画
  else if(mode == 'M'){
    for(int j = 0; j < NUM; j++){
      for(int i = 0; i < NUM; i++){
        if(flag[i][j])  matrix.drawPixel(i, j, LED_ON);
        else            matrix.drawPixel(i, j, LED_OFF);
      }
    }
    matrix.writeDisplay();
  }
  //文字列
  else if(mode == 'P'){
    if(effectMsg == 0){
      for (int8_t x=0; x>=-6*lenMsg; x--) {
        matrix.clear();
        matrix.setCursor(x,0);
        matrix.print(message);
        matrix.writeDisplay();
        delay(100);
      }
    }
    else if(effectMsg == 1){
      for (int8_t x=0; x<lenMsg; x++) {
        matrix.clear();
        //matrix.writeDisplay();
        //delay(180);
        matrix.setCursor(1,0);
        matrix.print(message.charAt(x));
        matrix.writeDisplay();
        delay(200);
      }
    }
  }
  else if(mode == 'A'){
    for(int i = 0; i < lenPic; i++){
      matrix.clear();
      for(int j = 0; j < NUM; j++){    //vertical
        for(int k = 0; k < NUM; k++){  //horizontal
          byte mask = (byte)((1 << k) & 0xFF);
          if((animeDat[i][j] & mask) != 0)  matrix.drawPixel(k, j, LED_ON);
          else                              matrix.drawPixel(k, j, LED_OFF);
        }
      }
      matrix.writeDisplay();
      delay(100);
    }
  }
}
