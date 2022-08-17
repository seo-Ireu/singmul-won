#include <DHT.h>
#include <DHT_U.h>

#include "WiFiEsp.h"
#include "DHT.h" //DHT 라이브러리 호출
#include <DigitShield.h> //DigitShield.h 라이브러리 호출
#include <SoftwareSerial.h>

#define DHTPIN 12     // 온습도 센서가 12번에 연결
#define DHTTYPE DHT11   // DHT11 온습도 센서 사용
#define rxPin 3  //와이파이 모듈 recei
#define txPin 2 // 와이파이 모듈 trans

DHT dht(DHTPIN, DHTTYPE); //DHT 설정(12,DHT11)
SoftwareSerial esp01(txPin, rxPin); // SoftwareSerial NAME(TX, RX);
SoftwareSerial bluetooth(8, 9);  //블루투스 통신

char ssid[] = "Inha_Dormitory1";   // 공유기 ID
char pass[] = "inha2000";        // 공유기 비밀번호
int status = WL_IDLE_STATUS;       // the Wifi radio's status

const char* host = "54.177.126.159";
const String tx_url = "/ubuntu/arduino/sensorData.php?lumi=40&humi=40&sort=2&plantid=2"; 
const String rx_url = "/ubuntu/arduino/suitablePlantData.php?userid=test1&plantInfoId=1"; 

WiFiEspClient client_rx; // WiFiEspClient 객체  
WiFiEspClient client_tx; // WiFiEspClient 객체 

int motor = 10; //모터 릴레이 핀
int water = 0 ; // water 변수 선언
const int inputcds = A0;      //포토레지스터와 연결된 핀 번호 저장하는 변수 선언
const int ledPin_b = 5;         //LED와 연결된 핀 번호 저장하는 변수 선언
const int ledPin_g = 6;         //LED와 연결된 핀 번호 저장하는 변수 선언
const int ledPin_r = 11;         //LED와 연결된 핀 번호 저장하는 변수 선언
const int analog_2=A2;         //물수위센서 변수 선언
int level;

String line = "";   //적정 정보 저장 변수 
bool flag = false;   //flag 

void printWifiStatus() {         // wifi 상태 표시 코드  
  Serial.print("SSID: ");        // print the SSID of the network you're attached to 
  Serial.println(WiFi.SSID()); 
  IPAddress ip = WiFi.localIP(); // print your WiFi shield's IP address 
  Serial.print("IP Address: "); 
  Serial.println(ip); 
  long rssi = WiFi.RSSI();       // wifi 신호 세기 
  Serial.print("Signal strength (RSSI):"); 
  Serial.print(rssi); 
  Serial.println(" dBm"); 
} 

void get_data() { 
  if (client_rx.connect(host, 80)) { 
    Serial.println("Connected to server"); 
    client_rx.print("GET ");    // Make a HTTP request 
    client_rx.print(rx_url);  
    client_rx.print(" HTTP/1.1\r\n"); 
    client_rx.print("Host: "); 
    client_rx.print(host); 
    client_rx.print("\r\n"); 
    client_rx.print("Connection: close\r\n\r\n"); 
    flag = true; 
  } 
} 

void put_data() { 
  if (client_tx.connect(host, 80)) { 
    Serial.println("Connected to server"); 
    client_tx.print("GET ");    // Make a HTTP request 
    client_tx.print(tx_url);  
    client_tx.print(" HTTP/1.1\r\n"); 
    client_tx.print("Host: "); 
    client_tx.print(host); 
    client_tx.print("\r\n"); 
    client_tx.print("Connection: close\r\n\r\n"); 
    flag = true; 
  } 
} 


void setup()
{
Serial.begin(9600); //통신속도 9600으로 통신 시작
DigitShield.begin();
dht.begin();
bluetooth.begin(9600);
pinMode(motor,OUTPUT);
esp01.begin(9600); //와이파이 시리얼

WiFi.init(&esp01);                  // initialize ESP module
if ( status != WL_CONNECTED) {   // attempt to connect to WiFi network
    Serial.print("Attempting to connect to WPA SSID: ");
    Serial.println(ssid);
    status = WiFi.begin(ssid, pass);  // Connect to WPA/WPA2 network
  }
Serial.println("You're connected to the network");
printWifiStatus();                  // wifi 상태표시
Serial.println();
Serial.println("Starting connection to server...");
delay(1000);

pinMode(inputcds, INPUT);
pinMode(ledPin_r, OUTPUT);
pinMode(ledPin_g, OUTPUT);
pinMode(ledPin_b, OUTPUT);
}

String line_blue = "";
bool receive_data_blue = false; 


bool receive_data = false;
int cnt =1; //데이터 입력 1시간 변수

void loop() {

  while (bluetooth.available()){
    char c = bluetooth.read();
    if (c=='{') {
      receive_data_blue = true;    
    }
    else if (receive_data_blue == true) line_blue += c; 
    Serial.print(line_blue);
    Serial.println(); 
    String wifi_id = json_parser(line_blue, "wifi_id"); 
    Serial.print(F("wifi_id: ")); Serial.println(wifi_id); 
    String wifi_pw = json_parser(line_blue, "wifi_pw"); 
    Serial.print(F("wifi_pw: ")); Serial.println(wifi_pw); 
    String userid = json_parser(line_blue, "userid"); 
    Serial.print(F("userid: ")); Serial.println(userid); 
    String plantInfoId = json_parser(line_blue, "plantInfoId"); 
    Serial.print(F("plantInfoId: ")); Serial.println(plantInfoId); 
    String plantid = json_parser(line_blue, "plantid"); 
    Serial.print(F("plantid: ")); Serial.println(plantid); 
    line_blue="";
    delay(2000);
  }
  //여기서 블루투스 통신 강제 종료해야함.
    
  /*
  get_data();
     if (cnt % 61 ==0){   //추가
    put_data(); 
    cnt =0;
    }
    


  while(client_rx.available()) { 
    char c = client_rx.read(); 
    if(c == '{') receive_data = true; // { 데이터 저장 시작, '{'는 저장 안함 
    else if (receive_data == true) line += c; 
  } 
  if (flag == true){  
    if (!client_rx.connected()) {  //정보 수신 종료 되었으면  
      receive_data = false; 
      Serial.println(); 
      Serial.println(F("Disconnecting from server...")); 
      client_rx.stop();
      client_tx.stop(); 
      Serial.println(line); 
      Serial.println(); 
      String humidity = json_parser(line, "humidity"); 
      Serial.print(F("humidity: ")); Serial.println(humidity); 
      String luminance = json_parser(line, "luminance"); 
      Serial.print(F("luminance: ")); Serial.println(luminance); 
      line = ""; 
    } 
  }
delay(1000);
cnt +=1; //추가
put_data();  //임시
*/
float h = dht.readHumidity(); //습도값을 h에 저장
float t = dht.readTemperature(); //온도값을 t에 저장
float f = dht.readTemperature(true);// 화씨 온도를 측정합니다.
float hif = dht.computeHeatIndex(f, h);
float hic = dht.computeHeatIndex(t, h, false);
//int cds = map(analogRead(inputcds),0,1023,0,255); //조도센서
int cds = analogRead(inputcds);

//Serial.print("Humidity: "); //문자열 출력
//Serial.print(h); //습도값 출력
//Serial.print("% ");
//DigitShield.setValue(h);
//delay(1000);

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

//온습도 및 모터조절
 if ( water > 800)   // 토양 습도 체크 적정습도 보다 낮으면 모터 동작 시켜 물공급 아니면 정지
   {
   digitalWrite(motor,HIGH);
   Serial.println("motor on");
 }
 else   {
   digitalWrite(motor,LOW);
   Serial.println("motor off");
 } 


//조도 조절 -> rgb를 어떤 값으로 나눠서 조도 조절해야 될 듯
 if (cds < 70) {  //조도 센서 체크 적정 조도보다 낮으면 led 켜짐
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


String json_parser(String s, String a) { 
  String val;
    int st_index = s.indexOf(a);
    int val_index = s.indexOf(':', st_index);
    if (s.charAt(val_index + 1) == '"') {
      int ed_index = s.indexOf('"', val_index + 2);
      val = s.substring(val_index + 2, ed_index);
    }
    else {
      int ed_index = s.indexOf(',', val_index + 1);
      val = s.substring(val_index + 1, ed_index);
    }
  return val;
}
