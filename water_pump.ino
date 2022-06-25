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
const int inputcds = 0;      //포토레지스터와 연결된 핀 번호 저장하는 변수 선언
const int ledPin_b = 5;         //LED와 연결된 핀 번호 저장하는 변수 선언
const int ledPin_g = 6;         //LED와 연결된 핀 번호 저장하는 변수 선언
const int ledPin_r = 9;         //LED와 연결된 핀 번호 저장하는 변수 선언
const int analog_2=2;         //물수위센서 변수 선언
int level;

void setup()
{
Serial.begin(9600); //통신속도 9600으로 통신 시작
DigitShield.begin();
dht.begin();
Serial.begin(9600);
pinMode(motor,OUTPUT);
Serial.begin(9600);   //시리얼모니터
esp01.begin(9600); //와이파이 시리얼
pinMode(inputcds, INPUT);
pinMode(ledPin_r, OUTPUT);
pinMode(ledPin_g, OUTPUT);
pinMode(ledPin_b, OUTPUT);
}
//10
void loop() {
delay(500);
float h = dht.readHumidity(); //습도값을 h에 저장
float t = dht.readTemperature(); //온도값을 t에 저장
float f = dht.readTemperature(true);// 화씨 온도를 측정합니다.
float hif = dht.computeHeatIndex(f, h);
float hic = dht.computeHeatIndex(t, h, false);
int cds = map(analogRead(inputcds),0,1023,0,255); //조도센서

Serial.print("Humidity: "); //문자열 출력
Serial.print(h); //습도값 출력
Serial.print("% ");
DigitShield.setValue(h);
delay(500);
Serial.print("Temperature: ");
Serial.print(hic); //온도값 출력
Serial.println("C");
DigitShield.setValue(t);
delay(500);
water=analogRead(A3);             //토양 습도 센서 아날로그핀 A3 번 사용 , A3 값 읽어와 water에 저장
Serial.print("Soil humidity: ");  //토양 습도 체크
Serial.println(water);
DigitShield.setValue(water);

//조도센서
Serial.print("INPUT CDS= ");
Serial.println(cds);

//물수위센서
level=analogRead(analog_2);
Serial.println(level);


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

//와이파이모듈
 if (esp01.available()) {       
    Serial.write(esp01.read());  //블루투스측 내용을 시리얼모니터에 출력
  }  
  if (Serial.available()) {         
    esp01.write(Serial.read());  //시리얼 모니터 내용을 블루추스 측에 쓰기
  }
 

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
