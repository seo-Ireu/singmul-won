#include "WiFiEsp.h"

//먼저 myPlant 테이블에서 plantInfoId 가져오기
//그걸 변수에 저장해서 suitablePalntData에서 적정 온습도 가져오기
#include <SoftwareSerial.h> 

#define rxPin 3 
#define txPin 2 
SoftwareSerial esp01(txPin, rxPin); // SoftwareSerial NAME(TX, RX);

char ssid[] = "공유기 ID";   // 공유기 ID
char pass[] = "공유기 비밀번호";        // 공유기 비밀번호
int status = WL_IDLE_STATUS;       // the Wifi radio's status

const char* host = "ip";
const String url = "경로/파일.php?userid=test1&plantInfoId=1";

WiFiEspClient client; // WiFiEspClient 객체 선언

String line = "";   //적정 정보 저장 변수
bool flag = false;   //flag


unsigned long int count_time = 0;  //정보 수신에 소요되는 시간 확인용 변수
bool count_start = false;
int count_val = 0;

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
  if (client.connect(host, 80)) {
    Serial.println("Connected to server");
    client.print("GET ");    // Make a HTTP request
    client.print(url);
    client.print(" HTTP/1.1\r\n");
    client.print("Host: ");
    client.print(host);
    client.print("\r\n");
    client.print("Connection: close\r\n\r\n");
    flag = true;
    count_start = true;
  }
}

void setup() {
  Serial.begin(9600);                 //시리얼모니터
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
  get_data();
}

void check_client_available() {  // loop()함수 진입 및 스캔 테스트 코드
  if (count_start == true) {
    if (millis() - count_time >= 100) {
      count_time = millis();
      count_val++;
      Serial.print(".");
      if (count_val == 30) count_start = false;
    }
  }
}

bool receive_data = false;

void loop() {
  check_client_available();
  while (client.available()) {
    char c = client.read();
    if(c == '{') receive_data = true; // { 데이터 저장 시작, '{'는 저장 안함
    else if (receive_data == true) line += c;
  }
  if (flag == true){
    if (!client.connected()) {  //정보 수신 종료 되었으면 
      receive_data = false;
      Serial.println();
      Serial.println(F("Disconnecting from server..."));
      client.stop();
      Serial.println(line);
      Serial.println();
      String humidity = json_parser(line, "humidity");
      Serial.print(F("humidity: ")); Serial.println(humidity);
      String luminance = json_parser(line, "luminance");
      Serial.print(F("luminance: ")); Serial.println(luminance);
      line = "";
      flag = false;
    }
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
