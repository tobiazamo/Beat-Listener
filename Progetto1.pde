import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;

Particle[] p = new Particle[10];

float kickSize, snareSize, hatSize;


void setup()
{

  // size(500,500)
  fullScreen();

  //creo particelle con direzione casuale, si muoveranno quando viene rilevato il beat di un rullante (snare)
  for (int i =0; i<p.length; i++) {
    p[i] = new Particle(new PVector(random(width), random(height)), random(-PI, PI));
  }

  minim = new Minim(this);

  song = minim.loadFile("Comfort_Fit_-_03_-_Sorry.mp3", 1024);
  song.play();
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(300);  
  kickSize = snareSize = hatSize = 16;
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);
}

void draw()
{
  fill(0, 20);
  rect(0, 0, width, height);

  if ( beat.isKick() ) kickSize = 32; // true when a kick (cassa) is detected
  if ( beat.isSnare() ) snareSize = 32; // true when a snare (rullante) is detected
  if ( beat.isHat() ) hatSize = 32;// true when a hat (piatto) is detected

  fill(kickSize*random(8.0,9.0),snareSize*random(8.0,9.0),hatSize*random(8.0,9.0));

  textSize(kickSize);
  text("KICK", width/4, height/2); // writes the text at the specified coordinates

  textSize(snareSize);
  text("SNARE", width/2, height/2);

  textSize(hatSize);
  text("HAT", 3*width/4, height/2);

  kickSize = constrain(kickSize * 0.95, 16, 32); 
  snareSize = constrain(snareSize * 0.95, 16, 32);
  hatSize = constrain(hatSize * 0.95, 16, 32);


  // a seconda del tipo di beat, appaiono dei triangoli in diverse posizioni dello schermo, il valore RED di fill cambia a seconda della posizione del mouse sull'asse delle x

  //se il beat rilevato è un kick, vengono disegnati dei cerchi concentrici rossi attorno alla particella a di dimensione a seconda del kickSize
  if (beat.isKick()) {
    noStroke();
    fill(map(mouseX, 0, width, 100, 255), random(0, 255), random(0, 255), 100);
    triangle(0, height, 0, 0, width/2, height/2);

    for (int i=0; i<p.length; i++) {
      p[i].radiusUp(kickSize, color(220, 20, 60));
    }
  }

  // se il beat rilevato è uno snare le particelle vengono "spinte" in una direzione casuale con forza che dipende da snareSize
  if (beat.isSnare()) {
    for (int i=0; i<p.length; i++) {
      p[i].Burst(snareSize);
    }
    noStroke();
    fill(map(mouseX, 0, width, 100, 255), random(0, 255), random(0, 255), 100);
    triangle(0, 0, width/2, height/2, width, 0);
  }

  //se il beat rilevato è un kick, vengono disegnati dei cerchi concentrici azzurri attorno alla particella a di dimensione a seconda del hatSize
  if (beat.isHat()) {
    noStroke();
    fill(map(mouseX, 0, width, 100, 255), random(0, 255), random(0, 255), 100);
    triangle(width, 0, width, height, width/2, height/2);

    for (int i=0; i<p.length; i++) {
      p[i].radiusUp(hatSize, color(0, 220, 255));
    }
  }

  //viene aggiunta la frizione per "frenare" le particelle mosse dallo snare
  for (int i=0; i<p.length; i++) {
    PVector friction = p[i].GetVelocity().normalize().mult(-0.07);
    p[i].applyForce(friction);
  }


  // utilizzo il metodo bufferSize() per disegnare le forme d'onda
  // ho preso come spunto l'esempio mostrato qui: http://code.compartmental.net/minim/audioplayer_field_left.html </a>
  for (int i = 0; i < song.bufferSize() - 1; i=i+40) {
    stroke(255);
    strokeWeight(4);
    float x1 = map( i, 0, song.bufferSize(), width/3, width/1.5 );
    float x2 = map( i+1, 0, song.bufferSize(), width/3, width/1.5 );
    line( x1, height/1.2 + song.left.get(i)*20, x2, height/1.2 + song.left.get(i+1)*100 );
  }



  for (int i=0; i<p.length; i++) {
    p[i].Update();
    p[i].CheckBorders();
    p[i].Display();
  }
}
