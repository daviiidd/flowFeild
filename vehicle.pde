class Vehicle {

  PVector location;
  PVector velocity;
  PVector acceleration;
  // Additional variable for size
  float r;
  float maxforce;
  float maxspeed;

  Vehicle(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    r = 10.0;
    
    maxspeed = 5;
    maxforce = 0.2;
  }

  // Our standard motion model
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
    
    //stay on screen...
    if(location.x < 0) location.x = width;
    else if(location.x > width) location.x = 0;
    if(location.y < 0) location.y = height;
    else if(location.y > height) location.y = 0;
  }

  // Newton’s second law; we could divide by mass if we wanted.
  void applyForce(PVector force) {
    acceleration.add(force);
  }                                            

  // Our seek steering force algorithm
  void seek(PVector target) {
    PVector desired = PVector.sub(target,location);
    float distToTarget = desired.mag();
    
    desired.normalize();
    
    //if we are too close to our target, limit our speed 
    if( distToTarget < 100 ) {
      desired.mult( 0.01 * distToTarget );
    }
    //else use our normal maxspeed
    else {
      desired.mult(maxspeed);  
    }
    
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
  
  
  void follow(FlowField flow) {
    //instead of a calculated-to-the-target desired vector, we
    //just ask the flow field for our desired vector
    PVector desired = flow.lookup(location);
    desired.mult(maxspeed);
 

    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
  
  

  void display() {
    // Vehicle is a triangle pointing in
    // the direction of velocity; since it is drawn
    // pointing up, we rotate it an additional 90 degrees.
    float theta = velocity.heading() + PI/2;
    fill(175);
    stroke(0);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
  }
}
