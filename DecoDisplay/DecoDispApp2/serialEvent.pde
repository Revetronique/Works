void SerialSendProtocol(char cmd, int len, byte[] dat)
{
  //Data sending process
  port.write((byte)(0xFF & cmd));  //Header (mode)
  port.write((byte)(0xFF & len));  //Data length
  
  if(dat == null)  return;  //mode select
  
  for(int i = 0; i < dat.length; i++){
    port.write(0xFF & dat[i]);  //data contents
  }
}

void sendStringData(String msg){
  int strLen = msg.length();
  byte[] dat = new byte[strLen];
  
  for(int i = 0; i < strLen; i++){
    dat[i] = (byte)msg.charAt(i);
  }
  
  SerialSendProtocol(mode, strLen, dat);
}

void serialEvent(Serial p)
{
  if(p.available() > 0){
    int dat = p.read();
    println(dat);
  }
}