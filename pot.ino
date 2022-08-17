
#include <DHT.h>
#include <DHT_U.h>

#include "WiFiEsp.h" 
// 블루투스 모듈로 와이파이 입력 및 plantid, plantInfoId, userid 입력

//suitablePalntData에서 적정 온습도 가져오기
#include <SoftwareSerial.h> 

#define rxPin 3 
#define txPin 2 

SoftwareSerial esp01(txPin, rxPin); // SoftwareSerial NAME(TX, RX); 
SoftwareSerial bluetooth(8, 9);  //블루투스 통신

char ssid[] = "Inha_Dormitory1";   // 공유기 ID 
char pass[] = "inha2000";        // 공유기 비밀번호 
int status = WL_IDLE_STATUS;       // the Wifi radio's status 

/* 
 *  String userid =
 * String plantid = 
 * String plantInfoId =
 * char ssid[] = 
 * char pass[] = 
  */
const char* host = "54.177.126.159"; 
const String tx_url = "/ubuntu/arduino/sensorData.php?lumi=40&humi=40&sort=2&plantid=2"; 
const String rx_url = "/ubuntu/arduino/suitablePlantData.php?userid=test1&plantInfoId=1";  


WiFiEspClient client_rx; // WiFiEspClient 객체  
WiFiEspClient client_tx; // WiFiEspClient 객체  

const int ledPin_b = 5;         //LED와 연결된 핀 번호 저장하는 변수 선언
const int ledPin_g = 6;         //LED와 연결된 핀 번호 저장하는 변수 선언
const int ledPin_r = 11;         //LED와 연결된 핀 번호 저장하는 변수 선언
const int analog_2=A2;         //물수위센서 변수 선언
int level;
int motor = 10; //모터 릴레이 핀
int water = 0 ; // water 변수 선언
const int inputcds = A0;      //포토레지스터와 연결된 핀 번호 저장하는 변수 선언

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

// ************새로 작성***************************
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
// **********************************************

void setup() { 
  Serial.begin(9600);                 //시리얼모니터 
  
  bluetooth.begin(9600);
  esp01.begin(9600);                  //와이파이 시리얼 
  WiFi.init(&esp01);                  // initialize ESP module 
  while ( status != WL_CONNECTED) {   // attempt to connect to WiFi network 
    Serial.print("Attempting to connect to WPA SSID: "); 
    Serial.println(ssid); 
    status = WiFi.begin(ssid, pass);  // Connect to WPA/WPA2 network 
  } 
  Serial.println("You're connected to the network"); 
  printWifiStatus();                  // wifi 상태표시 
  Serial.println(); 
  Serial.println("Starting connection to server..."); 
  delay(1000); 
  pinMode(motor,OUTPUT);
  pinMode(ledPin_r, OUTPUT);
pinMode(ledPin_g, OUTPUT);
pinMode(ledPin_b, OUTPUT);
pinMode(inputcds, INPUT);
  
} 

bool receive_data = false; 
int cnt =1; //데이터 입력 1시간 변수

String line_blue = "";
bool receive_data_blue = false; 

void loop() { 
  
  while (bluetooth.available()){
    char c = bluetooth.read();
    if (c=='{') {
      receive_data_blue = true;    
    }
    else if (receive_data_blue == true) line_blue += c; 
    
  }
  //여기서 블루투스 통신 강제 종료해야함.
    if (line_blue != ""){
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
  /*
   get_data(); 
  if (cnt % 61 ==0){   //추가
    put_data(); 
    cnt =0;
    }
    */
    get_data(); 
  while (client_rx.available()) { 
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
  //delay(60000); //1분 추가
  cnt +=1; //추가
  put_data();
  
delay(1000);
  water=analogRead(A3);             //토양 습도 센서 아날로그핀 A3 번 사용 , A3 값 읽어와 water에 저장
Serial.print("Soil humidity: ");  //토양 습도 체크
Serial.println(water);
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



  //물수위센서
delay(500);
level=analogRead(analog_2);
Serial.println(level);
if(level<500){ 
  Serial.print("low");
  
  digitalWrite(ledPin_r, HIGH);
  digitalWrite(ledPin_g, LOW);
  digitalWrite(ledPin_b, LOW);
  
 }
 int cds = analogRead(inputcds);
 //조도센서
delay(500);
Serial.print("INPUT CDS= ");
Serial.println(cds);

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



/* 조도 lumi 받아서 led(-,-,-)
 * lumi 받으면 값에 round(255*lumi / 100) 이거에 맞춤.
 * 습도 humi 받아서 값에 1023 - (humi * 1023 / 100) 이거 보다 크면 모터 동작
 * 
 */