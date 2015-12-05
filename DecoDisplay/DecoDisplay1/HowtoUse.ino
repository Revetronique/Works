/*************************************************** 
  This is a library for our I2C LED Backpacks

  Designed specifically to work with the Adafruit LED Matrix backpacks 
  ----> http://www.adafruit.com/products/872
  ----> http://www.adafruit.com/products/871
  ----> http://www.adafruit.com/products/870

  These displays use I2C to communicate, 2 pins are required to 
  interface. There are multiple selectable I2C addresses. For backpacks
  with 2 Address Select pins: 0x70, 0x71, 0x72 or 0x73. For backpacks
  with 3 Address Select pins: 0x70 thru 0x77

  Adafruit invests time and resources providing this open source code, 
  please support Adafruit and open-source hardware by purchasing 
  products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.  
  BSD license, all text above must be included in any redistribution
 ****************************************************/
 
//functions
/*
matrix.writeDisplay();
matrix.clear();

matrix.drawBitmap(0, 0, smile_bmp, 8, 8, LED_ON);

matrix.drawPixel(0, 0, LED_ON);

matrix.drawLine(0,0, 7,7, LED_ON);

matrix.drawRect(0,0, 8,8, LED_ON);
matrix.fillRect(2,2, 4,4, LED_ON);

matrix.drawCircle(3,3, 3, LED_ON);

matrix.setRotation(3);

matrix.setTextSize(1);
matrix.setTextWrap(false);  // we dont want text to wrap so it scrolls nicely
matrix.setTextColor(LED_ON);
for (int8_t x=0; x>=-36; x--) {
  matrix.clear();
  matrix.setCursor(x,0);
  matrix.print("Hello");
  matrix.writeDisplay();
  delay(100);
}
*/
