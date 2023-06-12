import processing.serial.*;
import java.io.FileWriter;
import java.io.IOException;

Serial myPort;
String val;
float diameter, targetDiameter;
color c, targetColor;
float lastValue;
String csvPath = "/Users/takahito/Develop/Kuchibashi_bent_share/Kuchibashi/Data/data.csv";
float circleScale = 2000; // 変化量の倍率
float baseScale = 0.1; // 初期値の円の大きさの倍率
float lerpSpeed = 0.1; // 補間速度

void setup() {
  size(600, 600);
  c = #0000FF;
  printArray(Serial.list());

  if (Serial.list().length > 0) {
    myPort = new Serial(this, Serial.list()[5], 115200);
    myPort.bufferUntil('\n'); // データ終端の改行を待つ
  } else {
    println("No available serial ports. Check the connection.");
  }
}

void draw() {
  if (lastValue == 0) return; // 初期値が設定されるまで描画しない

  background(0);
  fill(c);
  ellipse(width/2, height/2, diameter, diameter);

  // 現在の値を表示
  fill(255);
  textSize(24);
  text("Value: " + val, 10, 30);

  diameter = lerp(diameter, targetDiameter, lerpSpeed);
  c = lerpColor(c, targetColor, lerpSpeed);
}

void serialEvent(Serial p) {
  val = p.readString().trim();

  float value = float(val);
  if (lastValue == 0) {
    // 初期値を設定
    lastValue = value;
    diameter = targetDiameter = value * baseScale; // 初期値にbaseScaleを適用
    return;
  }
  saveToCSV(value);
  float diff = value - lastValue;

  targetDiameter += diff * circleScale; // 円の変化量を倍率で制御

  float hue = map(value % 255, 0, 256, 100, 150); //100 to 150 maps to blue to green.RGBをHSL変換して色を返す
  targetColor = color(hue, 200, 200);

  lastValue = value;
}

void saveToCSV(float value) {
  try {
    FileWriter writer = new FileWriter(csvPath, true); // true for "append" mode
    writer.append(str(value) + "\n");
    writer.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}
