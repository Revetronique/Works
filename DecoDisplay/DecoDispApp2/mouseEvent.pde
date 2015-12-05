void mousePressed()
{
  if(mouseButton == LEFT){
    if(mode == 'D'){
      byte bmpNum = (byte)random(4);
      SerialSendProtocol(mode, 1, new byte[]{bmpNum});
    }
    else if(mode == 'M'){
      //detect which cell is selected
      int ledPosX = mouseX - TopLeftX;
      int ledPosY = mouseY - TopLeftY;
      
      if(ledPosX < 0 || ledPosY < 0)  return;
      
      ledPosX /= CELWID;
      ledPosY /= CELWID;
      
      if(ledPosX >= NUM || ledPosY >= NUM)  return;
        
      flag[ledPosX][ledPosY] = !flag[ledPosX][ledPosY];
      
      //Serial communication
      int ledon = (flag[ledPosX][ledPosY]) ? 1 : 0;
      byte[] dat = new byte[] {(byte)ledPosX, (byte)ledPosY, (byte)ledon};
      
      SerialSendProtocol(mode, dat.length, dat);
    }
    else if(mode == 'A'){
      //detect which cell is selected
      int ledPosX = mouseX - TopLeftX;
      int ledPosY = mouseY - TopLeftY;
      
      if(ledPosX < 0 || ledPosY < 0)  return;
      
      ledPosX /= CELWID;
      ledPosY /= CELWID;
      
      if(ledPosX >= NUM || ledPosY >= NUM)  return;
      
      //update the picture data
      int idx = ledPosX + ledPosY * NUM;
      long shift = (long)1 << idx;
      
      if((animePics[selPic - 1] & shift) != 0){
        animePics[selPic - 1] ^= shift;
      }
      else{
        animePics[selPic - 1] |= shift;
      }
    }
  }
  else if(mouseButton == RIGHT){
    if(mode == 'M'){
      for(int i = 0; i < flag.length; i++){
        for(int j = 0; j < flag[i].length; j++){
          flag[i][j] = false;
        }
      }
      SerialSendProtocol('r', 1, new byte[]{0});
    }
    else if(mode == 'A'){
      animePics[selPic - 1] = 0;
    }
  }
}