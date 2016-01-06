Maxim maxim;
AudioPlayer player1;
AudioPlayer player2;

Accelerometer accel;

PImage [] images;
PImage [] recordPlayer;
PImage TV;
int currentPosition = 0;
boolean flag = true;
float[] spec1;
float[] spec2;
float speedAdjust=1.0;
float rotateDeck1 = 0;
float rotateDeck2 = 0;
boolean deck1Playing = false;
boolean deck2Playing = false;
int margin = width/40;

int tvx, tvy;
int animx, animy;
int deck1x, deck1y;
int deck2x, deck2y;

float time1 = 0;
float time2 = 0;

float hue;
float sat;
float bri;

void setup() {
 size(640, 960);
 background(10);
 imageMode(CENTER);
 colorMode(HSB);
 images = loadImages("Animation_data/movie", ".jpg", 134);
 recordPlayer = loadImages("black-record_", ".png", 36);
 TV = loadImage("TV.png");
 maxim = new Maxim(this);
 player1 = maxim.loadFile("atmos.wav");
 player1.setLooping(true);
 player2 = maxim.loadFile("beat2.wav");
 player2.setLooping(true);
 player1.volume(0.5);
 accel = new Accelerometer();
 //player1.setAnalysing(true);
 //player2.setAnalysing(true);
 frameRate(25);
}




void draw()
{
  
  
  float ratio = 0;
  
  
  
  hue = map(mouseX, 0, width, 0, 255);
  sat = map(mouseY, 0, width, 0, 255);
  bri = dist(mouseX,mouseY,width/2,height/2);
  
  float speed = dist(pmouseX, pmouseY, mouseX, mouseY);
  float lineWidth = map(speed, 0, 1, 1, 10);
  
  
  float alpha = map(speed, 0, 20, 0, 10);
  //background(10); 
  
  lineWidth = constrain(lineWidth, 0, 3);
  
  pushMatrix();
  if(time1!=0||time2!=0)
  translate(width*0.5,height*0.5);
  //time=time+0.01;
  for (int i = 0;i < 20; i++) {
  rotate(sin(time1+time2));
  stroke(hue, sat, bri, 150);
  strokeWeight(lineWidth);
  line(pmouseX, pmouseY , mouseX, mouseY);
  brush5(pmouseX, pmouseY,mouseX, mouseY,lineWidth);
  brush6(mouseX, mouseY,speed, speed,lineWidth);
  //brush7(pmouseX, pmouseY,mouseX, mouseY,lineWidth);
  fill(0, alpha);
  }
  popMatrix();

  noStroke();
  // draw the current image
  imageMode(CENTER);
  image(images[int(currentPosition)], width/2, height/2);
  image(TV, width/2, height/2, TV.width, TV.height);
  
  deck1x = (width/2)-recordPlayer[0].width/2-(margin*10);
  deck1y = height/2+recordPlayer[0].height/2+margin;
  image(recordPlayer[(int) rotateDeck1], deck1x, deck1y, recordPlayer[0].width, recordPlayer[0].height);
  deck2x = (width/2)+recordPlayer[0].width/2+(margin*10);
  deck2y = height/2+recordPlayer[0].height/2+margin;
  image(recordPlayer[(int) rotateDeck2], deck2x, deck2y, recordPlayer[0].width, recordPlayer[0].height);

  speedAdjust = map(accel.getX(), -10, 10, 0, 2);
  
  if (deck1Playing || deck2Playing) {
    
    player1.speed(speedAdjust);
    player2.speed((player2.getLengthMs()/player1.getLengthMs())*speedAdjust);
    currentPosition= int((currentPosition+1)*speedAdjust);
  }
  
    // when you get to the end, loop
  if(currentPosition >= images.length)
  {
     currentPosition = 0;
  }
  
  if (deck1Playing) {

    rotateDeck1 += 1*speedAdjust;

    if (rotateDeck1 >= recordPlayer.length) {

      rotateDeck1 = 0;
    }
    
   spec1 = player1.getPowerSpectrum();
    if(spec1!=null){
      for(int i=0; i<spec1.length;i++){
       
        time1 = time1+spec1[i];
       
      }
    }
      
   }

  if (deck2Playing) {

    rotateDeck2 += 1*speedAdjust;

    if (rotateDeck2 >= recordPlayer.length) {

      rotateDeck2 = 0;
    }
    
    spec2 = player2.getPowerSpectrum();
    
    if(spec2!=null){
      for(int i=0; i<spec2.length;i++){
        time2 = time2 + spec2[i];
      }
    }
     
    
  }
  
  //saveFrame("output.png");
  
}

 



void mousePressed()
{
  
  
  //if (mouseX > (width/2)-recordPlayer[0].width-(margin*10) && mouseX < recordPlayer[0].width+((width/2)-recordPlayer[0].width-(margin*10)) && mouseY>TV.height+margin && mouseY <TV.height+margin + recordPlayer[0].height) {
  if(dist(mouseX, mouseY, deck1x, deck1y) < recordPlayer[0].width/2){
    
    deck1Playing = !deck1Playing;
  }

  if (deck1Playing) {
    //player1.cue(0);
    player1.play();
    
  } 
  else {
    time1 = 0;
    player1.stop();
  }

  if(dist(mouseX, mouseY, deck2x, deck2y) < recordPlayer[0].width/2){
  
    deck2Playing = !deck2Playing;
  }

  if (deck2Playing) {
    //player2.cue(0);
    player2.play();
    
  } 
  else {
    time2 = 0;
    player2.stop();
  }
  

}
   
   

   
