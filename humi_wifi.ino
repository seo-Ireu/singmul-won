#include <DHT.h>
#include <DHT_U.h>

/*
온습도 센서 예제
온도와 습도를 출력
라이브러리 매니저에서
DHT sensor library by Adafruit
https://github.com/adafruit/DHT-sensor-library
Adafruit Unified Sensor by Adafruit
https://github.com/pkourany/Adafruit_Unified_Sensor_Library
7-세그먼트 라이브러리 다운로드 주소
https://github.com/nootropicdesign/digit-shield
설치 해야함
http://www.devicemart.co.kr/
*/

#include "DHT.h" //DHT 라이브러리 호출
#include <DigitShield.h> //DigitShield.h 라이브러리 호출
#include <SoftwareSerial.h>
#define DHTPIN 12     // 온습도 센서가 12번에 연결
#define DHTTYPE DHT11   // DHT11 온습도 센서 사용
#define rxPin 3  //와이파이 모듈 recei
#define txPin 2 // 와이파이 모듈 trans
DHT dht(DHTPIN, DHTTYPE); //DHT 설정(12,DHT11)
SoftwareSerial esp01(txPin, rxPin); // SoftwareSerial NAME(TX, RX);

int motor = 10; //모터 릴레이 핀
int water = 0 ; // water 변수 선언
const int inputcds = A0;      //포토레지스터와 연결된 핀 번호 저장하는 변수 선언
const int ledPin_b = 5;         //LED와 연결된 핀 번호 저장하는 변수 선언
const int ledPin_g = 6;         //LED와 연결된 핀 번호 저장하는 변수 선언
const int ledPin_r = 9;         //LED와 연결된 핀 번호 저장하는 변수 선언
const int analog_2=A2;         //물수위센서 변수 선언
int level;

/* 추가
----------------------------------
String ssid = "WIFI ID"
String PASSWORD = "비밀번호"
String host = "내 컴퓨터 아이피"

void connectWifi(){

  String join ="AT+CWJAP=\""+ssid+"\",\""+PASSWORD+"\"";
      
  Serial.println("Connect Wifi...");
  mySerial.println(join);
  delay(10000);
  if(esp01.find("OK"))
  {
    Serial.print("WIFI connect\n");
  }else
  {
   Serial.println("connect timeout\n");
  }
  delay(1000);
  }

  
  void httpclient(String char_input){
  delay(100);
  Serial.println("connect TCP...");
  esp01.println("AT+CIPSTART=\"TCP\",\""+host+"\",8787");
  delay(500);
  if(Serial.find("ERROR")) return;
  
  Serial.println("Send data...");
  String url=char_input;
  String cmd="GET /process.php?"+url+" HTTP/1.0\r\n\r\n"; <- php파일 경로 수정
  esp01.print("AT+CIPSEND=");
  esp01.println(cmd.length());
  Serial.print("AT+CIPSEND=");
  Serial.println(cmd.length());
  if(esp01.find(">"))
  {
    Serial.print(">");
  }else
  {
    esp01.println("AT+CIPCLOSE");
    Serial.println("connect timeout");
    delay(1000);
    return;
  }
  delay(500);
       
  esp01.println(cmd);
  Serial.println(cmd);
  delay(100);
  if(Serial.find("ERROR")) return;
  esp01.println("AT+CIPCLOSE");
  delay(100);
  }  

*/

void setup()
{
Serial.begin(9600); //통신속도 9600으로 통신 시작
DigitShield.begin();
dht.begin();
pinMode(motor,OUTPUT);
esp01.begin(9600); //와이파이 시리얼
//connectWifi();
pinMode(inputcds, INPUT);
pinMode(ledPin_r, OUTPUT);
pinMode(ledPin_g, OUTPUT);
pinMode(ledPin_b, OUTPUT);
}

void loop() {
delay(1000);
float h = dht.readHumidity(); //습도값을 h에 저장
float t = dht.readTemperature(); //온도값을 t에 저장
float f = dht.readTemperature(true);// 화씨 온도를 측정합니다.
float hif = dht.computeHeatIndex(f, h);
float hic = dht.computeHeatIndex(t, h, false);
int cds = map(analogRead(inputcds),0,1023,0,255); //조도센서

//Serial.print("Humidity: "); //문자열 출력
//Serial.print(h); //습도값 출력
//Serial.print("% ");
//DigitShield.setValue(h);
//delay(1000);
//Serial.print("Temperature: ");
//Serial.print(hic); //온도값 출력
//Serial.println("C");
//DigitShield.setValue(t);
delay(1000);
water=analogRead(A3);             //토양 습도 센서 아날로그핀 A3 번 사용 , A3 값 읽어와 water에 저장
Serial.print("Soil humidity: ");  //토양 습도 체크
Serial.println(water);
DigitShield.setValue(water);

//조도센서
delay(500);
Serial.print("INPUT CDS= ");
Serial.println(cds);

//물수위센서
delay(500);
level=analogRead(analog_2);
Serial.println(level);
DigitShield.setValue(level);

//php전달 변수
String str_output = "&cds="+String(cds)+"&humi="+String(humi);
delay(1000);
httpclient(str_output);
delay(1000);

/* 추가
//Serial.find("+IPD");
 while (esp01.available())
 {
  char response = esp01.read();
  Serial.write(response);
  if(response=='\r') Serial.print('\n');
  }
 Serial.println("\n==================================\n");
 delay(2000);
*/

//온습도 및 모터조절
 if ( water < 800)   // 토양 습도 체크 800보다 낮으면 모터 동작 시켜 물공급 아니면 정지
   {
   digitalWrite(motor,HIGH);
   Serial.println("motor on");
 }
 else   {
   digitalWrite(motor,LOW);
   Serial.println("motor off");
 } 
 
/* 제거
//와이파이모듈
 if (esp01.available()) {       
    Serial.write(esp01.read());  //블루투스측 내용을 시리얼모니터에 출력
  }  
  if (Serial.available()) {         
    esp01.write(Serial.read());  //시리얼 모니터 내용을 블루추스 측에 쓰기
  }
 
*/

//조도 조절
 if (cds >40) {
  digitalWrite(ledPin_r, HIGH);
  digitalWrite(ledPin_g, HIGH);
  digitalWrite(ledPin_b, HIGH);
 }
 else {
  digitalWrite(ledPin_r, LOW);
  digitalWrite(ledPin_g, LOW);
  digitalWrite(ledPin_b, LOW);
 }

//물수위 조절
 if(level<500){ 
  digitalWrite(ledPin_r, HIGH);
  digitalWrite(ledPin_g, LOW);
  digitalWrite(ledPin_b, LOW);
 }
 
}
