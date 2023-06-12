#define SENSORPIN  (0)

void setup() {
  Serial.begin(115200);             // シリアル通信の準備をする
  while (!Serial);                  // 準備が終わるのを待つ
  Serial.println("プログラム開始");    // シリアル通信でメッセージをPCに送信
}

void loop() {
  float bent = analogRead( SENSORPIN );
  bent = (bent * 5)/1023;
  Serial.println(bent);         // シリアル通信でカウンターの値をPCに送信
  delay(10);                     // 1000ミリ秒(1秒)待機
}
