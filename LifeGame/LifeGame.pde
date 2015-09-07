CellAutomata ca;

//Display property
int edge = 5;  //Interval between the window and edge cells
int diameter = 6;  //diameter of cells
int radius = diameter / 2;

void setup(){
  //Initialize the instance of class CA
  int numLine = 50;
  ca = new CellAutomata(numLine);
  ca.initCells(0.21);
  
  //Window property
  size(2 * edge + diameter * numLine, 2 * edge + diameter * numLine);
  frameRate(10);
  
  //ellipseMode(CENTER);  //default
  //noStroke();
}

void draw(){
  //update the display
  int numLine = ca.GetLineNum();
  color c;
  
  background(0);
  
  for(int i = 0; i < numLine; i++){    //vertical
    for(int j = 0; j < numLine; j++){  //horizontal
      if(ca.GetCellState(j, i) == 1)  c = color(30, 200, 10);
      else  c = color(50);
      
      fill(c);
      ellipse(edge + diameter * j + radius, edge + diameter * i + radius, diameter, diameter);
    }
  }
  
  //multi threading
  Thread th = new Thread(ca);
  th.start(); 
}

void keyPressed(){
  switch(key){
    case '0':
      ca.setBoundaryMode(ca.BOUNDARYDEAD);
      break;
    case '1':
      ca.setBoundaryMode(ca.BOUNDARYALIVE);
      break;
    case '2':
      ca.setBoundaryMode(ca.LINKCOUNTERPART);
      break;
    case 'n':
      ca.setNeighborMode(ca.NEWMANN);
      break;
    case 'm':
      ca.setNeighborMode(ca.MOORE);
      break;
    case 'r':
      ca.initCells(0.23);
      break;
  }
}

class CellAutomata implements Runnable {
  public final int BOUNDARYDEAD = 0;  //default
  public final int BOUNDARYALIVE = 1;
  public final int LINKCOUNTERPART = 2;
  
  public final int NEWMANN = 0;
  public final int MOORE = 4;  //default
  
  //Simulation Setting
  private byte[] stateCell;  //State of each cells (false:Dead, true:Live)
  
  private int numCell = 30;  //number of cells in each line
  private byte mode = (byte)(this.BOUNDARYDEAD | this.MOORE);  //[0 - 1]:Boundary, [2]:Neighborhood, [3 - 7]: No assign
                                                       //0:Outside cells as dead, 1:Outside cells as live, 2:Each edge
                                                       //0: Newmann, 4: Moore
  
  //Pseudo Property Method (like C# language)
  public int GetLineNum(){
    return this.numCell;
  }
  
  public void setBoundaryMode(int _mode){
    this.mode &= 0xFC;  //B11111100
    this.mode |= _mode;
  }
  
  public void setNeighborMode(int _nbr){
    this.mode &= 0xFB;  //B11111011
    this.mode |= _nbr;
  }
  
  //Constructor
  CellAutomata(){
    this.stateCell = new byte[this.numCell * this.numCell];
  }
  CellAutomata(int _num){
    this.numCell = _num;
    
    this.stateCell = new byte[this.numCell * this.numCell];  //Array of state of the cells is defined its size after numCell is assigned
  }
  CellAutomata(int _num, byte _mode, byte _nbr){
    this.numCell = _num;
    this.mode = (byte)(_mode | _nbr);
    
    this.stateCell = new byte[this.numCell * this.numCell];  //Array of state of the cells is defined its size after numCell is assigned
  }
  
  //public methods
  //initialize the state of all cells
  public void initCells(float rate){  //rate: how often the state becomes alive
    int max = this.numCell * this.numCell;
    int thres = (int)(rate * 1000);
    
    for(int i = 0; i < max; i++){
      int rnd = (int)random(1000);
      
      if(rnd < thres)  stateCell[i] = (byte)1;
      else             stateCell[i] = (byte)0;
    }
  }
  
  //main method (parallel processing)
  public void run(){
    byte[] nextCell = new byte[this.stateCell.length];
    
    //update all of the cell state
    for(int i = 0; i < this.numCell; i++){    //vertical
      for(int j = 0; j < this.numCell; j++){  //horizontal
        byte state = GetCellState(j, i);
        byte alive = getAliveNeighborCells(j, i);
        
        //estimate whether the state become alive or 
        if(alive == 3)       nextCell[i * this.numCell + j] = 1;                                   //birth or alive (3)
        else if(alive == 2)  nextCell[i * this.numCell + j] = state; //keep (2)            
        else                 nextCell[i * this.numCell + j] = 0;                                   //death (2 nor 3)
      }
    }
    
    stateCell = nextCell;
  }
  
  //get the current state of selected cell
  public byte GetCellState(int col, int row){
    byte rslt = 0;
    
    if(getBoundaryMode() == this.BOUNDARYDEAD){
        if(col < 0 || col >= this.numCell || row < 0 || row >= this.numCell)  rslt = 0;
        else rslt = stateCell[row * this.numCell + col];
    }else if(getBoundaryMode() == this.BOUNDARYALIVE){
        if(col < 0 || col >= this.numCell || row < 0 || row >= this.numCell)  rslt = 1;
        else rslt = stateCell[row * this.numCell + col];
    }else if(getBoundaryMode() == this.LINKCOUNTERPART){
        if(col < 0 || col >= this.numCell || row < 0 || row >= this.numCell)  rslt = LinkEdgeToCounter(col, row);
        else rslt = stateCell[row * this.numCell + col];
    }
    
    return rslt;
  }
  
  //private methods  
  //get the array of the state of neighbor cells where the selected cell is
  private byte getAliveNeighborCells(int col, int row){
    byte rslt = 0;
    
    //Calculate all of alive cells arround the selected cell
    rslt += GetCellState(col, row - 1);  //top
    rslt += GetCellState(col - 1, row);  //left
    rslt += GetCellState(col + 1, row);  //right
    rslt += GetCellState(col, row + 1);  //bottom
    //Only Moore's Neighborhood
    if(getNeighborMode() == this.MOORE){
      rslt += GetCellState(col - 1, row - 1);
      rslt += GetCellState(col + 1, row - 1);
      rslt += GetCellState(col - 1, row + 1);
      rslt += GetCellState(col + 1, row + 1);
    }
    
    return rslt;
  }
  
  //Connect the edge of the region to the counterpart edge (like Packman's stage tunnel)
  private byte LinkEdgeToCounter(int col, int row){
    int h = (col < 0) ? this.numCell - 1 : 0;
    int v = (row < 0) ? this.numCell - 1 : 0;
    
    return stateCell[v * this.numCell + h];    
  }

  private int getBoundaryMode(){
    int bound = mode & 0x03;
    
    if(bound == this.BOUNDARYDEAD){
      return this.BOUNDARYDEAD;
    }else if(bound == this.BOUNDARYALIVE){
      return this.BOUNDARYALIVE;
    }else if(bound == this.LINKCOUNTERPART){
      return this.LINKCOUNTERPART;
    }else{
      return this.BOUNDARYDEAD;  //default
    }
  }
  
  private int getNeighborMode(){
    int nbr = mode & 0x04;
    
    if(nbr == this.MOORE){
      return this.MOORE;
    }else if(nbr == this.NEWMANN){
      return this.NEWMANN;
    }else{
      return this.MOORE;  //default
    }
  }
}
