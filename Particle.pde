class Particle {

  float lowerBound = 30;
  PVector position;
  float heading;
  PVector velocity = new PVector(random(-0.5, 0.5), random(-0.5, 0.5));
  PVector acceleration = new PVector(0.0, 0.0);
  float mass=1;


  Particle (PVector _position, float h) {
    position = _position;
    heading = h;
  }

  PVector GetVelocity() {
    return new PVector( velocity.x, velocity.y);
  }


  void Update() {
    velocity.add(acceleration);
    position.add(velocity); 
    acceleration.mult(0);
  }


  // questo metodo crea un vettore nella direzione della particella, viene chiamato quando viene rilevato uno "snare"
  void Burst(float a) {
    PVector force = PVector.fromAngle(heading - random(PI));
    force.mult(a*0.1);
    applyForce(force);
  }

  void CheckBorders() {
    if (position.x < 0 ) {
      position.x = width;
    } else if ( position.x > width ) {
      position.x = 0;
    }
    if (position.y < 0 ) {
      position.y = height;
    } else if ( position.y > height ) {
      position.y = 0;
    }
  }


  // metodo per disegnare i cerchi concentrici quando viene rilevato un "kick" o "hat"
  void radiusUp(float h, color c) {
    if (lowerBound <= 150) {
      for (int j = 0; j<30; j=j+10) {
        noFill();
        strokeWeight(2);
        stroke(c);
        ellipse(position.x, position.y, lowerBound-j, lowerBound-j);
      }
      lowerBound=lowerBound+h;
    } else {
      lowerBound = 30;
    }
  }


  void applyForce(PVector _force) {
    PVector f = PVector.div(_force, mass);
    acceleration.add(f);
  }

  void Display() {
    noStroke();
    fill(220, 20, 60);
    ellipse(position.x, position.y, 12, 12);
  }
}
