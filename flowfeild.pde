class FlowField {

  // A flow field is a two-dimensional array of PVectors.
  PVector[][] field;
  int cols, rows;
  int resolution;

  FlowField(int r) {
    resolution = r;
    // Determine the number of columns and rows.
    cols = width/resolution;
    rows = height/resolution;

    field = new PVector[cols][rows];
    init();
  }

  //change this to get a different field
  void init() {
    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        //In this example, we use Perlin noise to seed the vectors.
        float theta = map(noise(xoff, yoff), 0, 1, 0, TWO_PI);
        //Polar to Cartesian coordinate transformation to get x and y components of the vector
        field[i][j] = new PVector(cos(theta), sin(theta));
        yoff += 0.1;
      }
      xoff += 0.1;
    }
  }

  //A function to return a PVector based on a location
  PVector lookup(PVector lookup) {

    int column = int(constrain(lookup.x/resolution, 0, cols-1));
    int row = int(constrain(lookup.y/resolution, 0, rows-1));
    return field[column][row].get();
  }

  void display() {
    float sizeOfLine = 13;
    for ( int col = 0; col < cols; col++ ) {
      for ( int row = 0; row < rows; row++ ) {

        //for this cell in the grid, calculate the x and y to know where to draw
        float x = col * resolution;
        float y = row * resolution;

        //use the field 2D array to grab the PVector that represents the slope/direction 
        PVector current = field[col][row];

        //draw a small line segment here that uses the starting x and y we calculated
        //and the slope from the field array
        float endX = x+sizeOfLine*current.x;
        float endY = y+sizeOfLine*current.y;
        stroke(0);
        line(x,y, endX, endY);
        //if we want to make it a bit nicer, add an "end cap" to give some sense of 
        //direction. Let's just use a rect or ellipse, but at the "end" of the PVector
        ellipse(endX,endY, 3,3);
      }
    }
  }
}
