import com.temboo.core.*;
import com.temboo.Library.Google.Spreadsheets.*;
import neurosky.*;
import org.json.*;
import processing.serial.*;
TembooSession session = new TembooSession("johnnyddunn", "myFirstApp", "3bc78779aa65494d9b6e4fc631dfb7cd");
Serial port;
ThinkGearSocket neuroSocket;
PrintWriter output;
String googleProfile = "johnnyddunn";
String currentTime;
String currentDate = month()+ "-"+day()+ "-"+year();
String BPMString;
int Sensor;     //Taken from Arduino
int IBI;        //Taken from Arduino
int BPM;        //Beats per minute, taken from Arduino
int fadeRate;   //Taken from Arduino
int heart = 0;  //Taken from Arduino
int blinkStrength;
int attention;
int meditation;
int blinkStrengthLevel;
int thetaValue;      //Copies of the mapped values of the wave length amplitudes, in meters
int lowAlphaValue;
int highAlphaValue;
int lowBetaValue;
int highBetaValue;
int lowGammaValue;
int midGammaValue;
int deltaValue;
int lucidity;      //How "lucid" the person is while dreaming
float mDelta;      //The mapped values of the wave length amplitudes, in meters
float mTheta;
float mLowAlpha;
float mHighAlpha;
float mLowBeta;
float mHighBeta;
float mLowGamma;
float mMidGamma;
float fillBackgroundWDelta;        //The background colors of the sketch
float fillOpacityWDelta;  
int sumOfBlinks;                //How much has the user blinked?
int minuteInterval = 60000;     //In the last minute?
int resultOfBlinks = 0;
int countOfBlinks = 0; 
int sumOfAttention;
int resultOfAttention = 0;
int secsOfAttention = 0;
int maxSecsOfAttention = 10;      //Sets the average calculator function to run every 10 seconds
int sumOfBPM;
int resultOfBPM = 0;
int secsOfBPM = 0;
int maxSecsOfBPM = 10;
int sumOfMeditation;
int resultOfMeditation = 0;
int secsOfMeditation = 0;
int maxSecsOfMeditation = 10;
int sumOfDelta;
int resultOfDelta = 0;
int secsOfDelta = 0;
int maxSecsOfDelta = 10;
int sumOfTheta;
int resultOfTheta = 0;
int secsOfTheta = 0;
int maxSecsOfTheta = 10;
int sumOfLowAlpha;
int resultOfLowAlpha = 0;
int secsOfLowAlpha = 0;
int maxSecsOfLowAlpha = 10;
int sumOfHighAlpha;
int resultOfHighAlpha = 0;
int secsOfHighAlpha  = 0;
int maxSecsOfHighAlpha = 10;
int sumOfLowBeta;
int resultOfLowBeta = 0;
int secsOfLowBeta = 0;
int maxSecsOfLowBeta = 10;
int sumOfHighBeta;
int resultOfHighBeta = 0;
int secsOfHighBeta = 0;
int maxSecsOfHighBeta = 10;
int sumOfLowGamma;
int resultOfLowGamma = 0;
int secsOfLowGamma = 0;
int maxSecsOfLowGamma = 10;
int sumOfMidGamma;
int resultOfMidGamma = 0;
int secsOfMidGamma = 0;
int maxSecsOfMidGamma = 10;
int lastTimeCheck;        //When was time last checked
int lastTimeCheckTen;     //For ten seconds
int lastTimeCheckMin;     //For one minute
int savedTime;            //The last saved time
int savedTimeTen;         //For ten seconds
int savedTimeMin;         //For one minute
//int averageTime = 10000;  //Take average every 10 seconds
int saveFrameTime = 10000;  ///Save frame every 10 seconds
int heartFill;            //What opacity value the heart color is filled at; will be based off BPM
boolean beat = false;
boolean changeBackgroundBlink = false;  
boolean lucidityBool = false;      
boolean secHasPassed = false;       
boolean saveFrameTimeBool = false;    
boolean BPMBool = true;
boolean attentionBool = true;
boolean meditationBool = true;
boolean deltaBool = true;
boolean thetaBool = true;
boolean alphaBool = true;
boolean betaBool = true;
boolean gammaBool = true;
boolean switchModes = false;
boolean flashBool = true;
PFont font;

void setup() {
  //runInitializeOAuthChoreo();
  //runFinalizeOAuthChoreo();
  output = createWriter("data.txt");      //Write print output data into data.txt file in sketch folder
  size(1024, 640);
  frameRate(30);                    
  //rectMode(CENTER);
  ellipseMode(CENTER);  
  println(" ");                           //Print Date Out
  print("Date : ");
  print(year());
  print("-");
  print(month());
  print("-");
  print(day());
  println("");
  savedTime = millis();                    //Start timers and clocks
  savedTimeTen = millis();  
  savedTimeMin = millis();
  ThinkGearSocket neuroSocket = new ThinkGearSocket(this);        //Connect MindSet
    try {
      neuroSocket.start();
    } 
    catch (Exception e) {
    //println("Is ThinkGear running??");
   }
  smooth();
  noFill();
  font = createFont("Verdana", 12);
  textFont(font);
/* for (int i = 0; i < deltaValue * thetaValue ; i += deltaValue) {      //Draws stars based off of values
       ellipse(random(width), random(height), 2, 2);
       fill(255,249,249);
 }*/
  // ARDUINO COMMUNICATION
  //println(Serial.list());
  //port = new Serial(this, Serial.list()[0], 115200);
  //port.clear();
  //port.bufferUntil('\n');    //END
}

void draw() {  
  fill(10000/fillBackgroundWDelta, 10000/fillBackgroundWDelta, 10000/fillBackgroundWDelta, 100);
  noStroke();
  rect(0, 0, width, height);
  currentTime = hour()+ ":"+minute()+ ":"+second();
  timeTimers();       //Start adding millis();
  mathAverages1();    //These average values of the sensor data
  mathAverages2();
  // DRAW THE HEART AND MAYBE MAKE IT BEAT
  if (BPMBool == true) {      //Did the user turn BPM monitoring off?
    if (beat == true){   // move the heart rate line over one pixel every time the heart beats 
    heartFill = 253;
     }
  if (beat == false) {
    heartFill = 0;
  }  
    smooth();
    fill(242, 15, 45, heartFill);
    stroke(242, 15, 45, 255);
    strokeWeight(1);
    // the 'heart' variable is set in serialEvent when arduino sees a beat happen
    heart--;                    // heart is used to time how long the heart graphic swells when your heart beats
    heart = max(heart, 0);       // don't let the heart variable go into negative numbers
    fill(242, 15, 45, heartFill);          // make the heart big
    strokeWeight(1);
    ellipse(width/2, height/2, 10 + BPM * 3, 10 + BPM * 1.5);
    strokeWeight(1);
    ellipse(width/2, height/2, 15 + BPM * 3, 15 + BPM * 1.5);
    strokeWeight(1);
    ellipse(width/2, height/2, 20 + BPM * 3, 20 + BPM * 1.5);
    beat = false;     //END
  }
  //Draw attention values
   if (attentionBool == true) {
    stroke(0, 116, 168, 255);
    fill(0, 116, 168, 20);
    strokeWeight(3);
    ellipse(width/2, height/2, attention*3, attention*3);  //END
    //Draw meditation values
   }
  if (meditationBool == true) {
    strokeWeight(3);
    stroke(209, 24, 117, 255);
    fill(209, 24, 117, 20);
    ellipse(width/2, height/2, meditation*3, meditation*3);  //END
   }
  //Draw delta wave amplitudes
  if (deltaBool == true) {
    stroke(100, 80, 24, 255);
    strokeWeight(3);
    fill(100, 80, 24, 1);
    ellipse(width/2, height/2, mDelta * 1.5 , mDelta* 1.5);    //END
  }
  //Draw theta wave amplitudes
  if (thetaBool == true) {
    stroke(38, 222, 38, 255);
    strokeWeight(2);
    fill(35, 196, 35, 20);
    ellipse(width/2, height/2, mTheta * 1.5, mTheta * 1.5);     //END
  }
    //Draw alpha wave amplitudes
  if (alphaBool == true) {
    stroke(252, 123, 10, 255);
    strokeWeight(1);
    fill(252, 123, 10, 20);
    ellipse(width/2, height/2, (mLowAlpha * 3), (mLowAlpha * 3));
    strokeWeight(1);
    ellipse(width/2, height/2, (mHighAlpha * 3), (mHighAlpha * 3));      //END
    }
  //Draw beta wave amplitudes
  if (betaBool == true) {
    stroke(224, 224, 34, 255);
    strokeWeight(1);
    fill(227, 208, 2, 20);
    ellipse(width/2, height/2, mLowBeta * 3, mLowBeta * 3);
    strokeWeight(2);
    ellipse(width/2, height/2, mHighBeta * 3, mHighBeta * 3);  //END
  }
  //Draw gamma wave amplitudes
  if (gammaBool == true) {
    stroke(164, 243, 239, 255);
    strokeWeight(1);
    fill(164, 243, 239, 20);
    ellipse(width/2, height/2, mLowGamma * 3, mLowGamma * 3);   //END
    stroke(46, 219, 211, 255);
    strokeWeight(2);
    fill(46, 219, 211, 20);
    ellipse(width/2, height/2, mMidGamma * 3, mMidGamma * 3);      //END
  }
  textWriter();    //Writes the text / interface
  saveFramer();    //Saves frames (Every 10 seconds)
}

//Draws stars on the screen
/* for (int i = 0; i < deltaValue * thetaValue ; i += deltaValue) {
       ellipse(random(width), random(height), 2, 2);
       fill(255,249,249);
 }*/ 

void timeTimers() {
  lastTimeCheck  = millis() - savedTime;
  lastTimeCheckTen = millis() - savedTimeTen;
  lastTimeCheckMin = millis() - savedTimeMin;
}

void blinkEvent(int blinkStrength) {  
  blinkStrengthLevel = blinkStrength;   
  if (blinkStrength >= 25) {   //Hard, definite blink
    changeBackground();                         //Draws the new background, in this case, a red flash
    println(" Blinked");
    saveFrame();  
  }
}

void changeBackground() {      //Flashes the screen red, as this is only called when blinking occurs
      countOfBlinks+=1;        //Ups the number of blinks counter
      if (flashBool == true) {
      fill(190, 247, 244, 255);
      noStroke();
      rect(0, 0, width, height);
      delay(200);
      }
}

public void eegEvent(int delta, int theta, int low_alpha, int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {  
  deltaValue = delta;
  thetaValue = theta;  
  lowAlphaValue = low_alpha;
  highAlphaValue = high_alpha;
  lowBetaValue = low_beta;
  highBetaValue = high_beta;
  lowGammaValue = low_gamma;
  midGammaValue = mid_gamma;  
  mDelta  = map(deltaValue, 0, 1000000, 0, 1000);      //Maps all the values into meters
  mTheta = map(thetaValue, 0, 1000000, 0, 1000);
  mLowAlpha = map(lowAlphaValue, 0, 1000000, 0, 1000);
  mHighAlpha = map(highAlphaValue, 0, 1000000, 0, 1000);
  mLowBeta = map(lowBetaValue, 0, 1000000, 0, 1000);
  mHighBeta = map(highBetaValue, 0, 1000000, 0, 100);
  mLowGamma = map(lowGammaValue, 0, 1000000, 0, 1000);
  mMidGamma = map(midGammaValue, 0, 1000000, 0, 1000);
  fillBackgroundWDelta = mDelta;              //Changes background opacity and colors based off of delta waves
  //Prints out data every second
  if (millis() > savedTime) {  
    secHasPassed = true;
    print("Time:");
    print(" ");
    print(hour()); 
    print(":");
    print(minute());
    print(":");
    print(second());
    print("  ");
    print("Delta: " + mDelta);
    print("  ");
    print("Theta: " + mTheta);
    print("  ");
    print("Low Alpha: " + mLowAlpha);
    print("  ");
    print("High Alpha: " + mHighAlpha);
    print("  ");
    print("Low Beta: " + mLowBeta);
    print("  ");
    print("High Beta: " + mHighBeta);
    print("  ");
    print("Low Gamma: " + mLowGamma);
    print("  ");
    print("Mid Gamma: " + mMidGamma);
    println("");
    output.println(hour());
    output.println(minute());
    output.println(second());
    output.println(mDelta);
    output.println(mTheta);
    output.println(mLowAlpha);
    output.println(mHighAlpha);
    output.println(mLowBeta);
    output.println(mHighBeta);
    output.println(mLowGamma);
    output.println(mMidGamma);
    savedTime = millis();     //END
  }
  if (lastTimeCheckMin >= minuteInterval) {    //Reset blink counter
    println("");
    print("Count of Blinks: "+countOfBlinks);
    saveFrame();
    countOfBlinks = 0;
    savedTimeMin = millis();                  //END
  }
}

void mathAverages1() {                        //Adds up the numbers  so that they can be divided
  if (secHasPassed == true) {
    secsOfBPM++;
    sumOfBPM += BPM;
    secsOfAttention++;
    sumOfAttention += attention;
    secsOfMeditation++;
    sumOfMeditation += meditation;
    secsOfDelta++;
    sumOfDelta += mDelta;
    secsOfTheta++;
    sumOfTheta += mTheta;
    secsOfLowAlpha++;
    sumOfLowAlpha += (mLowAlpha * 10);
    secsOfHighAlpha++;
    sumOfHighAlpha += (mHighAlpha * 10);
    secsOfLowBeta++;
    sumOfLowBeta += (mLowBeta * 10);
    secsOfHighBeta++;
    sumOfHighBeta  += (mHighBeta * 10);
    secsOfLowGamma++;
    sumOfLowGamma += (mLowGamma  * 10);
    secsOfMidGamma++;
    sumOfMidGamma += (mMidGamma * 10);
    secHasPassed = false;
  }
}

void mathAverages2() {                    //Divides up the added numbers to obtain the average
 if (secsOfBPM >= maxSecsOfBPM) {
    resultOfBPM = sumOfBPM / maxSecsOfBPM;
    secsOfBPM = 0;
    sumOfBPM = resultOfBPM;
    } 
 if (secsOfAttention >= maxSecsOfAttention) {
    resultOfAttention = sumOfAttention / maxSecsOfAttention;
    secsOfAttention = 0;
    sumOfAttention = resultOfAttention;
  }
  if (secsOfMeditation >= maxSecsOfMeditation) {
    resultOfMeditation = sumOfMeditation / maxSecsOfMeditation;
    secsOfMeditation = 0;
    sumOfMeditation = resultOfMeditation;
  }    
  if (secsOfDelta >= maxSecsOfDelta) {
    resultOfDelta = sumOfDelta/ maxSecsOfDelta;
    secsOfDelta = 0;
    sumOfDelta = resultOfDelta;
  }
  if (secsOfTheta >= maxSecsOfTheta) {
    resultOfTheta = sumOfTheta/ maxSecsOfTheta;
    secsOfTheta = 0;
    sumOfTheta = resultOfTheta;
  }
    if (secsOfLowAlpha >= maxSecsOfLowAlpha) {
    resultOfLowAlpha = sumOfLowAlpha / maxSecsOfLowAlpha;
    secsOfLowAlpha = 0;
    sumOfLowAlpha = resultOfLowAlpha;
  }
    if (secsOfHighAlpha >= maxSecsOfHighAlpha) {
    resultOfHighAlpha = sumOfHighAlpha / maxSecsOfHighAlpha;
    secsOfHighAlpha = 0;
    sumOfHighAlpha = resultOfHighAlpha;
  }
  if (secsOfLowBeta >= maxSecsOfLowBeta) {
    resultOfLowBeta = sumOfLowBeta / maxSecsOfLowBeta;
    secsOfLowBeta = 0;
    sumOfLowBeta = resultOfLowBeta;
  }
    if (secsOfHighBeta >= maxSecsOfLowBeta) {
    resultOfHighBeta = sumOfHighBeta / maxSecsOfHighBeta;
    secsOfHighBeta = 0;
    sumOfHighBeta = resultOfHighBeta;
  }
   if (secsOfLowGamma >= maxSecsOfLowGamma) {
     resultOfLowGamma = sumOfLowGamma / maxSecsOfLowGamma;
     secsOfLowGamma = 0;
     sumOfLowGamma = resultOfLowGamma;
   }
   if (secsOfMidGamma >= maxSecsOfMidGamma) {
     resultOfMidGamma = sumOfMidGamma / maxSecsOfMidGamma;
     secsOfMidGamma = 0;
     sumOfMidGamma = resultOfMidGamma;
   }
}

void runAppendRowChoreo() {          //Writes the data onto a spreadsheet in Google Drive
  // Create the Choreo object using your Temboo 
  if (switchModes == false) {
  AppendRow appendRowChoreo = new AppendRow(session);
  // Set inputs
  //appendRowChoreo.setClientSecret("bVV0tez3XjV7C-CqkQjQpqc0");
  //appendRowChoreo.setRefreshToken("1/xF9dnvFhFrZUHnapJu8HdgzS4HJAPhWGCMfp_hHidpo");
  //appendRowChoreo.setClientID("173253856188-1f41fnjcevap7d4g99dudq131pj8pmhb.apps.googleusercontent.com");
  //appendRowChoreo.setCredential("johnnyddunn");
  appendRowChoreo.setCredential("DreamSpreadsheetAppend");
  appendRowChoreo.setSpreadsheetTitle("DreamSpreadsheet");
  appendRowChoreo.setRowData(currentTime + "," + str(resultOfBPM) + "," + str(countOfBlinks)  + "," + str(resultOfAttention) + "," + str(resultOfMeditation) +
                                         "," + str(resultOfDelta) + "," + str(resultOfTheta) + "," + str(resultOfLowAlpha) + "," + str(resultOfHighAlpha) +
                                         "," + str(resultOfLowBeta) + "," + str(resultOfHighBeta) + "," + str(resultOfLowGamma) + "," + str(resultOfMidGamma)); 
  AppendRowResultSet appendRowResults = appendRowChoreo.run();
  }
}
  // Run the Choreo and store the results
  // Print results
  //println(appendRowResults.getResponse());
  //println(appendRowResults.getNewAccessToken());

void poorSignalEvent(int sig) {
}

void textWriter() { 
    fill(92, 92, 92, 255);
    text("Stats:", 10, 30);
    fill(242, 15, 45, 255);
    text("BPM [1]: "+BPM, 10, 45);
    fill(0, 116, 168, 255);
    text("Attention [2]: "+attention, 10, 60);
    fill(209, 24, 117, 255);
    text("Meditation [3]: "+meditation, 10, 75);
    fill(100, 80, 24, 255);
    text("Deta (Background) [4]: "+mDelta+" m", 10, 90);
    fill(35, 196, 35, 255);
    text("Theta [5]: "+mTheta+" m", 10, 105);
    fill(252, 123, 10, 255);
    text("Low Alpha [6]: "+mLowAlpha+" m",10, 120);
    text("High Alpha (Bold) [6]: "+mHighAlpha+" m",10, 135);
    fill(227, 208, 2, 255);
    text("Low Beta [7]: "+mLowBeta+" m",10, 150);
    text("High Beta [7]: "+mHighBeta+" m",10, 165);
    fill(46, 219, 211, 255);
    text("Low Gamma [8]: "+mLowGamma+" m",10, 180);
    text("Middle Gamma (Bold) [8]: "+mMidGamma+" m",10, 195);
    fill(92,92,92,255);
    text("Averages (Over Last 10 Seconds):", 10, 250);
    fill(242, 15, 45, 255);
    text("BPM: "+resultOfBPM, 10, 265); 
    fill(0, 116, 168, 255);    
    text("Attention: "+resultOfAttention, 10, 280);
    fill(209, 24, 117, 255);
    text("Meditation: "+resultOfMeditation, 10, 295);    
    fill(100, 80, 24, 255);
    text("Delta (Background):  "+resultOfDelta+" m", 10, 310);
    fill(35, 196, 35, 255);
    text("Theta: "+resultOfTheta+" m", 10, 325);
    fill(252, 123, 10, 255);
    text("Low Alpha: "+resultOfLowAlpha/10+" m",10, 340);
    text("High Alpha (Bold): "+resultOfHighAlpha/10+" m",10, 355);
    fill(227, 208, 2, 255);
    text("Low Beta: "+resultOfLowBeta/10+" m",10, 370);
    text("High Beta: "+resultOfHighBeta/10+" m",10, 385);
    fill(46, 219, 211, 255);
    text("Low Gamma: "+resultOfLowGamma/10+" m",10, 400);
    text("Middle Gamma (Bold): "+resultOfMidGamma/10+" m",10, 415);
    //fill(255, 18, 60, 255);
    fill(255,  54, 74, 255);
    text("Blinks In Last Minute: "+countOfBlinks, 10, 470);
    fill(92, 92, 92, 255);
    text("Awake: Yes", 10, 485);
    text("Dreaming: No", 10, 500);
    text("Lucid: No", 10, 515);
    text("Lucidity: ", 10, 530);
    if (lucidityBool == false) {
      text("N/A", 65, 530);
    }
    fill(92, 92, 92, 255); 
    text("Time: "+currentTime,  10, 585);
    text("Date: "+month()+ "-"+day()+ "-"+year(), 10, 600);
    fill(92, 92, 92, 255);
    text("Press [NUM] keys to turn them off", 10, 210);
    text("EEG / Biometric Visual Monitor", 800, 570);
    text("Interactive Lucid Dream Journal", 800, 585);
    text("and Meditation Device", 800, 600);
    text("[ALT] to close program and save raw data information.", 367, 551);
    text("[SPACE] to switch between spreadsheet data recording", 367, 568);
    text("(slow) and real-time visualization modes.", 367, 583);
    text("[B] to turn off the screen flash with blinking", 367, 600);
}

void saveFramer () {        //Saves frames of the sketch every 10 seconds
  if (lastTimeCheckTen > saveFrameTime) {
    saveFrameTimeBool = true;
    savedTimeTen = millis();     
  }
    if (saveFrameTimeBool == true) {
      saveFrame();
      runAppendRowChoreo();
  }
  saveFrameTimeBool = false;
}

public void attentionEvent(int attentionLevel) {
  attention = attentionLevel;
}

void meditationEvent(int meditationLevel) {
  meditation = meditationLevel;
}

void rawEvent(int[] raw) {
}	

void stop() {              //If MindWave's been disconnected, stop program
  neuroSocket.stop();
  super.stop();
}

void keyPressed() {        //User interface
  if (key == CODED) {
     if (keyCode == ALT) {
          output.flush();  // Writes the data to the text file
           output.close();  // Finishes the file
        exit();  // Stops the program
    }
   }
   if (key == '1' && BPMBool == true) {
     BPMBool = false;
   } else { 
     if (key == '1' && BPMBool == false) {
       BPMBool = true;
     }
   }
   if (key == '2' && attentionBool == true) {
     attentionBool = false;
   } else {
     if (key == '2' && attentionBool == false) {
       attentionBool = true;
     }
   }
   if (key == '3' && meditationBool == true) {
     meditationBool = false;
   } else {
     if (key == '3' && meditationBool == false) {
       meditationBool = true;
     }
   }
   if (key == '4' && deltaBool == true) {
     deltaBool = false;
   } else {
     if (key == '4' && deltaBool == false) {
       deltaBool = true;
     }
   }
  if (key == '5' && thetaBool == true) {
    thetaBool = false;
  } else {
    if (key == '5' && thetaBool == false) {
      thetaBool = true;
    }
  }
  if (key == '6' && alphaBool == true) {
    alphaBool = false;
  } else {
    if (key == '6' && alphaBool == false) {
      alphaBool = true;
    }
  }
  if (key == '7' && betaBool == true) {
    betaBool = false;
  } else {
    if (key == '7' && betaBool == false) {
      betaBool = true;
    }
  }
  if (key == '8' && gammaBool == true) {
    gammaBool = false;
  } else {
    if (key == '8' && gammaBool == false) {
      gammaBool = true;
    }
  }
    if (key == ' ' && switchModes == false) {
      switchModes = true;
    } else {
    if (key == ' ' && switchModes == true) {
        switchModes = false;
    }
  }
    if (key == 'b' || key == 'B')
     if (flashBool == true) {
       flashBool = false;
     }  else {
      if (flashBool == false) {
        flashBool = true;
      }
     }
}
