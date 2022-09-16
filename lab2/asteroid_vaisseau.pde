int currentTime;
int previousTime;
int deltaTime;

ArrayList<Mover> flock;
int flockSize = 20;
int maxflock = 30;
ArrayList<Projectile> bullets;
int maxBullets = 10;


boolean canfire = true;
boolean saveVideo = false;

Vaisseau v;

void setup () {
  size (800, 600);
  currentTime = millis();
  previousTime = millis();
  
  v = new Vaisseau();
  v.location.x = width / 2;
  v.location.y = height / 2;
  
  bullets = new ArrayList<Projectile>();

  flock = new ArrayList<Mover>();
  
  for (int i = 0; i < flockSize; i++) {
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-5, 5), random(-5, 5)));
    m.fillColor = color(random(255), random(255), random(255));
    flock.add(m);
  }
  
  
}

void draw () {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;

  
  update(deltaTime);
  display();
  
  savingFrames(5, deltaTime);  
  
    
  for ( Projectile p : bullets) {
    p.display();
  }
  
}

PVector thrusters = new PVector(0, -0.02);

/***
  The calculations should go here
*/
void mousePressed()
{
  if(flockSize <= maxflock)
  {
   Mover m = new Mover(new PVector(mouseX, mouseY), new PVector(random (-5, 5), random(-5, 5)));
    m.fillColor = color(random(255), random(255), random(255));
    flock.add(m);
    flockSize += 1;

  }
}
void update(int delta) {
  if (keyPressed) {
    switch (key) {
      case 'w':
        v.thrust();
        break;
      case 'a':
         v.pivote(-.03);
         break;
      case 'd':
         v.pivote(.03);
        break;
      case ' ':
      if(canfire)
      {        
        fire();
      }
        canfire = false;
        break;
        case 'r':
          restart();
        break;
  }
  }
  for (Mover m : flock) {
          m.flock(flock);

      m.update(delta);
    }
  v.update(delta);
for (int i = flock.size() - 1; i >= 0; i--) {
       Mover m = flock.get(i);
      if(v.isColliding(m))
      {
      boolean clear = false;
      PVector respawn = new PVector(width/2,height/2);
          while(!clear){
            respawn = new PVector(random(0,width),random(0,height));
            for(Mover x : flock){
              if(PVector.dist(x.location, respawn) >= 10){
              clear = true;
              }
              else
              {
                clear = false;
              }
            }
          }
          v = new Vaisseau();
          v.location = respawn;
      }
      for ( Projectile p : bullets) {
        if(m.isColliding(p))
        {
            flock.remove(i);
            flockSize--;
        }
        
      }
    }
    for ( Projectile p : bullets) {
          p.update(deltaTime);
  }
}

/***
  The rendering should go here
*/
void display () {
  background(0);
    for (Mover m : flock) {
    m.display();
    }
  v.display();
    for ( Projectile p : bullets) {
    p.display();
  }
}

//Saving frames for video
//Put saveVideo to true;
int savingAcc = 0;
int nbFrames = 0;

void savingFrames(int forMS, int deltaTime) {
  
  if (!saveVideo) return;
  
  savingAcc += deltaTime;
  
  if (savingAcc < forMS) {
    saveFrame("frames/####.tiff");
	nbFrames++;
  } else {
	println("Saving frames done! " + nbFrames + " saved");
    saveVideo = false;
  }
}
void fire() {
  
  if (bullets.size() < maxBullets) {
    Projectile p = new Projectile();
    
    p.location = v.location.copy();
    p.topSpeed = 5;
    p.velocity = v.getShootingVector().copy().mult(p.topSpeed);
   
    p.activate();
    
    bullets.add(p);
  } else {
    for ( Projectile p : bullets) {
      if (!p.isVisible) {
        p.location.x = v.location.x;
        p.location.y = v.location.y;
        p.velocity.x = v.getShootingVector().x;
        p.velocity.y = v.getShootingVector().y;
        p.velocity.mult(p.topSpeed);
        p.activate();
        break;
      }
    }
  }  
}
void restart()
{
  flockSize = 20;
   v = new Vaisseau();
  v.location.x = width / 2;
  v.location.y = height / 2;
  
  bullets = new ArrayList<Projectile>();

  flock = new ArrayList<Mover>();
  
  for (int i = 0; i < flockSize; i++) {
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-5, 5), random(-5, 5)));
    m.fillColor = color(random(255), random(255), random(255));
    flock.add(m);
  }
}

void keyReleased() {
    switch (key) {
      case 'w':
        v.noThrust();
        break;
     case ' ':
       canfire = true;
     break;
    }  
}
