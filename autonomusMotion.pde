FlowField ff;
Vehicle v;

void setup() {
  size(700, 700);
  ff = new FlowField(15);
  v = new Vehicle( width/2, height/2 );
}

void draw() {
  background(255);
  
  ff.display();
  v.follow(ff);
  v.update();
  v.display();
  if (mousePressed == true){
   v.location.set(mouseX,mouseY); 
  }

}
