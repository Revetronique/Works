void serialEvent()
{
  int len = 0;
  
  //read header and length sent from App.
  if(Serial.available() > 1){
    mode = (char)Serial.read();
    len = Serial.read();
  }
  
  if(len == 0) return;  //mode select
  
  //read remaining data sent from App.
  char dat[len];
  
  Serial.readBytes(dat, len);
  
  //予め記憶されたやつ
  if(mode == 'D'){
    bmpNum = dat[0];
  }
  //好きなように描画できるモード
  else if(mode == 'M'){
    int x = (int)dat[0];
    int y = (int)dat[1];
    int ledon = (int)dat[2];
    
    flag[x][y] = (ledon == 0) ? false : true;
  }
  //描画のリセット
  else if(mode == 'r'){
    mode = 'M';
    for(int y = 0; y < NUM; y++){
      for(int x = 0; x < NUM; x++){
        flag[x][y] = false;
      }
    }
  }
  //文字を表示する<アルファベットのみ>
  else if(mode == 'P'){
    lenMsg = len;
    message = "";
    for(int i = 0; i < len; i++){
      message += dat[i];
    }
  }
  //文字のアニメーションを決める<テロップのように流れる, ルパン三世のようなやつの2種類>
  else if(mode == 'p'){
    mode = 'P';
    effectMsg = (byte)dat[0];
  }
  //パラパラ漫画のようなアニメーション
  //コマを増やしたときにバグ発生
  else if(mode == 'A'){
    lenPic = len / NUM;
    
    for(int i = 0; i < len; i++){
      animeDat[i / NUM][i % NUM] = dat[i];
    }
  }
}
