---------------------------------------------------------------------
#define USS_T_PIN 7      // 送信側センサー接続のピン番号(デジタル接続)
#define USS_R_PIN 0      // 受信側センサー接続のピン番号(アナログ接続)


//  電源起動時とリセットの時だけのみ処理される関数(初期化と設定処理)
void setup() {
  Serial.begin(9600);    // 9600bpsでシリアル通信のポートを開きます
}
//  繰り返し実行される処理の関数(メインの処理)
void loop() {
     int ans ;

     ans = UsonicMeasurRead(USS_T_PIN,USS_R_PIN,20,30) ;
     Serial.print(ans) ;                // 表示を行う
     Serial.println("mm") ;
     delay(500) ;                       // 500ms後に繰り返す
}
// 超音波センサーから距離を得る処理
// txpin=送信接続ピン  rxpin=受信接続ピン  temp=周辺温度  correction=距離補正
// 距離をｍｍで返す(検出できない場合は０を返す)
int UsonicMeasurRead(int txpin,int rxpin,int temp,int correction)
{
     unsigned long t , t2 ;
     int ans , val ;

     ans = 0 ;
     tone(txpin,40000) ;                // 送信センサーに40KHz信号を200us出力
     delayMicroseconds(200) ;
     noTone(txpin) ;                    // 40KHz信号停止
     t = micros() ;                     // 現在の時間を記憶する
     while(1) {
          val = analogRead(rxpin) ;     // 受信センサーの値を読む
          t2 = micros() - t ;           // 時間をカウントする
          if (val >= 410) break ;       // 受信値の電圧が2V以上なら反射信号とする
          if (t2 >= 30000) break ;      // 反射信号が返って来なかった場合の処理
     }
     if (t2 < 30000) {
          t = 331500 + (600 * temp) ;   // 音波の伝搬する速度を求める
          t = (t * t2) / 1000000 ;      // 距離の計算
          ans = t / 2 ;                 // 往復なので÷2
          ans = ans + correction ;      // 距離の補正値を加える
     }
     return ans ;
}
---------------------------------------------------------------------
