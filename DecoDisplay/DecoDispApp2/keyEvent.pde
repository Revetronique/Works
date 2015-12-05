void keyPressed()
{
  if(mode != 'P')  return;
  
  if(key != CODED){
    switch(key){
      case BACKSPACE:
        if(textcursor > 0){
          typedText = typedText.substring(0, textcursor - 1) + typedText.substring(textcursor, typedText.length());
          textcursor--;
        }
        break;
      case DELETE:
        if(textcursor < typedText.length())
          typedText = typedText.substring(0, textcursor) + typedText.substring(textcursor + 1, typedText.length());
        break;
      case TAB:
        typedText += "  ";
        textcursor += 2;
        break;
      case ENTER:
      case RETURN:
        // comment out the follwing two lines to disable line-breaks;
        //typedText += "\n";
        break;
      case ESC:
        break;
      default:
        if(textcursor < 128){
          typedText = typedText.substring(0, textcursor) + str(key) + typedText.substring(textcursor, typedText.length());
          textcursor++;
        }
        break;
    }
  }
  else{
    switch(keyCode){
      case LEFT:
        if(textcursor > 0)  textcursor--;
        break;
      case RIGHT:
        if(textcursor < typedText.length() && textcursor < 255)  textcursor++;
        break;
    }    
  }
}