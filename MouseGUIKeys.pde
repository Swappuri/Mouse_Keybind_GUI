import processing.serial.*;
import controlP5.*;
import java.util.HashMap;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.util.Map;

PFont font;
Serial port;
ControlP5 cp5;
Robot robot;
String[] buttonLabels = {"left-click", "right-click", "space", "shift", "control", "alt", "up", "down", "left", "right"};
boolean[] waitingForKeyPress = {false, false, false, false, false, false, false, false, false, false};
HashMap<Integer, String> keyNames = new HashMap<Integer, String>();
String[] validKeys = {"up", "down", "right", "left", "shift", "alt", "control", "enter", "backspace", "tab", "left-click", "right-click", "space"};
String val = "";
char[] button = {0, 1, 32, 16, 17, 18, 38, 40, 37, 39}; 

public class KeyDictionary {
    private final Map<Character, Integer> KEY_MAP = new HashMap<>();
     {
        KEY_MAP.put('A', KeyEvent.VK_A);
        KEY_MAP.put('B', KeyEvent.VK_B);
        KEY_MAP.put('C', KeyEvent.VK_C);
        KEY_MAP.put('D', KeyEvent.VK_D);
        KEY_MAP.put('E', KeyEvent.VK_E);
        KEY_MAP.put('F', KeyEvent.VK_F);
        KEY_MAP.put('G', KeyEvent.VK_G);
        KEY_MAP.put('H', KeyEvent.VK_H);
        KEY_MAP.put('I', KeyEvent.VK_I);
        KEY_MAP.put('J', KeyEvent.VK_J);
        KEY_MAP.put('K', KeyEvent.VK_K);
        KEY_MAP.put('L', KeyEvent.VK_L);
        KEY_MAP.put('M', KeyEvent.VK_M);
        KEY_MAP.put('N', KeyEvent.VK_N);
        KEY_MAP.put('O', KeyEvent.VK_O);
        KEY_MAP.put('P', KeyEvent.VK_P);
        KEY_MAP.put('Q', KeyEvent.VK_Q);
        KEY_MAP.put('R', KeyEvent.VK_R);
        KEY_MAP.put('S', KeyEvent.VK_S);
        KEY_MAP.put('T', KeyEvent.VK_T);
        KEY_MAP.put('U', KeyEvent.VK_U);
        KEY_MAP.put('V', KeyEvent.VK_V);
        KEY_MAP.put('W', KeyEvent.VK_W);
        KEY_MAP.put('X', KeyEvent.VK_X);
        KEY_MAP.put('Y', KeyEvent.VK_Y);
        KEY_MAP.put('Z', KeyEvent.VK_Z);
        KEY_MAP.put('-', KeyEvent.VK_SUBTRACT);
        KEY_MAP.put('=', KeyEvent.VK_EQUALS);
        KEY_MAP.put('/', KeyEvent.VK_SLASH);
        KEY_MAP.put('.', KeyEvent.VK_PERIOD);
        KEY_MAP.put(',', KeyEvent.VK_COMMA);
        KEY_MAP.put(';', KeyEvent.VK_SEMICOLON);
        KEY_MAP.put('\\', KeyEvent.VK_BACK_SLASH);
        KEY_MAP.put('[', KeyEvent.VK_OPEN_BRACKET);
        KEY_MAP.put(']', KeyEvent.VK_CLOSE_BRACKET);
    }

    public  int getKey(char c) {
        return KEY_MAP.get(c);
    }
}

KeyDictionary b = new KeyDictionary();

void click(char s) {
  if (s == 0) {
    robot.mousePress(InputEvent.BUTTON1_DOWN_MASK);
  }
  else if (s == 1) {
    robot.mousePress(InputEvent.BUTTON3_DOWN_MASK);
  }
  else {
    try {
      robot.keyPress(b.getKey(Character.toUpperCase(s)));
    }
    catch (Exception e) {
      robot.keyPress(s);      
    }
  }
}

void release(char s) {
  if (s == 0) {
    robot.mouseRelease(InputEvent.BUTTON1_DOWN_MASK);
  }
  else if (s == 1) {
    robot.mouseRelease(InputEvent.BUTTON3_DOWN_MASK);
  }
  else {
    try {
      robot.keyRelease(b.getKey(Character.toUpperCase(s)));
    }
    catch (Exception e) {
      robot.keyRelease(s);      
    }
  }
}

void setup(){
  size(300, 595);
  cp5 = new ControlP5(this);
  font = createFont("Yu Gothic Light", 30); 
  String portName = Serial.list()[0];
  port = new Serial(this, portName, 9600);

  try {
    robot = new Robot();
  } 
  catch (AWTException e) {
    e.printStackTrace();
  }

  cp5.addButton("button0")
     .setValue(0)
     .setPosition(25, 70)
     .setSize(255, 40)
     .setCaptionLabel("left-click")
     .setColorBackground(#448187)
     .setColorForeground(#448187)
     .setColorActive(#448187)
     .lock()
     .getCaptionLabel().setFont(new ControlFont(createFont("Yu Gothic Light", 16)))
     ;

  cp5.addButton("button1")
     .setValue(0)
     .setPosition(25, 120)
     .setSize(255, 40)
     .setCaptionLabel("right-click")
     .setColorBackground(#448187)
     .setColorForeground(#448187)
     .setColorActive(#448187)
     .lock()
     .getCaptionLabel().setFont(new ControlFont(createFont("Yu Gothic Light", 16)))
     ;

  for(int i=2; i<10; i++){
    cp5.addButton("button"+i)
       .setValue(0)
       .setPosition(25, 170+50*(i-2))
       .setSize(255, 40)
       .setCaptionLabel(buttonLabels[i])
       .setColorBackground(#2d5559)
       .setColorForeground(#448187)
       .setColorActive(#4f969e)
       .getCaptionLabel().setFont(new ControlFont(createFont("Yu Gothic Light", 16)))
       ;
  }

  keyNames.put(8, "backspace");
  keyNames.put(9, "tab");
  keyNames.put(10, "enter");
  keyNames.put(16, "shift");
  keyNames.put(17, "control");
  keyNames.put(18, "alt");
  keyNames.put(32, "space");
  keyNames.put(37, "left");
  keyNames.put(38, "up");
  keyNames.put(39, "right");
  keyNames.put(40, "down");
}

void draw(){
  background(#55A2AA);
  textSize(40);
  noStroke();
  textFont(font);
  text("K E Y S", 103, 50);

  if(port.available() > 0){
    String serialInput = port.readStringUntil('\n');
    String pre = "PRE:";
    String rel = "REL:";

    if(serialInput != null){
      if(serialInput.startsWith(pre)){
        serialInput.substring(4);
        
        if(serialInput.indexOf("Tch1") != -1) {
          click(button[0]);
        }
        if(serialInput.indexOf("Tch2") != -1) {
          click(button[1]);
        }
        if(serialInput.indexOf("Tch3") != -1) {
          click(button[2]);
        }
        if(serialInput.indexOf("Tch4") != -1) {
          click(button[3]);
        }
        if(serialInput.indexOf("Tch5") != -1) {
          click(button[4]);
        }
      }

      else if(serialInput.startsWith(rel)){
        serialInput.substring(4);

        if(serialInput.indexOf("Tch1") != -1) {
          release(button[0]);
        }
        if(serialInput.indexOf("Tch2") != -1) {
          release(button[1]);
        }
        if(serialInput.indexOf("Tch3") != -1) {
          release(button[2]);
        }
        if(serialInput.indexOf("Tch4") != -1) {
          release(button[3]);
        }
        if(serialInput.indexOf("Tch5") != -1) {
          release(button[4]);
        }
      }
    }
  }
}

void keyPressed() {
  for(int i=0; i<10; i++){
    if(waitingForKeyPress[i] && cp5.getController("button"+i).isMouseOver()){
      if(keyNames.containsKey(keyCode)){
        buttonLabels[i] = keyNames.get(keyCode);
        if(keyNames.get(keyCode).equals("left-click")) {
          button[i] = 0;
        } else if (keyNames.get(keyCode).equals("right-click")) {
          button[i] = 1;
        } else {
          button[i] = (char)keyCode;
        }
      } else {
        buttonLabels[i] = key+"";
        button[i] = key;
      }
      waitingForKeyPress[i] = false;
      cp5.getController("button"+i).setCaptionLabel(buttonLabels[i]);
      val = "";
    }
  }
}

void controlEvent(ControlEvent theEvent) {
  for(int i=2; i<10; i++){
    if (theEvent.isFrom("button"+i)) {
      waitingForKeyPress[i] = true;
      cp5.getController("button"+i).setCaptionLabel("Press any key");
    }
  }
}
