void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    switch(theControlEvent.getTab().getId()){
      case 0:
        mode = 'D';
        SerialSendProtocol(mode, 0, null);
        break;
      case 1:
        mode = 'M';
        SerialSendProtocol(mode, 0, null);
        break;
      case 2:
        mode = 'P';
        SerialSendProtocol(mode, 0, null);
        break;
      case 3:
        mode = 'A';
        SerialSendProtocol(mode, 0, null);
        break;
    }
  }
}

//buttons event handler
void Flyout(){
  sendStringData(typedText);
  SerialSendProtocol('p', 1, new byte[]{0});
}

void Cutoff(){
  sendStringData(typedText);
  SerialSendProtocol('p', 1, new byte[]{1});
}

void FlashPics(){
  byte[] dat = new byte[NUM * numPic + 1];
  for(int i = 0; i < numPic; i++){
    for(int j = 0; j < NUM; j++){
      int pos = j * NUM;
      long mask = (long)0xFF << pos;
      byte temp = (byte)((animePics[i] & mask) >> pos);
      dat[i * NUM + j] = temp;
    }
  }
  //println(dat);
  //println(dat.length);
  SerialSendProtocol('A', dat.length, dat);
}
void Next(){
  if(selPic < numPic)  selPic++;
}
void Prev(){
  if(selPic > 1)  selPic--;
}
void Add(){
  if(numPic < PICS)  numPic++;
}
void Del(){
  if(numPic > 1){
    numPic--;
    animePics[numPic] = 0;
  }
  if(selPic > numPic)
    selPic--;
}