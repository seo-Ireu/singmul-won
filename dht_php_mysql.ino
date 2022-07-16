#include <dht.h>
#include <SoftwareSerial.h>

dht DHT;

#define DHT11_PIN 4

float humi;  //Stores humidity value
float temp; //Stores temperature value

SoftwareSerial mySerial(2,3); //RX,TX

String ssid = "WIFI 아이디";
String PASSWORD = "비밀번호";
String host = "내 컴퓨터 아이피";

void connectWifi(){

  String join ="AT+CWJAP=\""+ssid+"\",\""+PASSWORD+"\"";
      
  Serial.println("Connect Wifi...");
  mySerial.println(join);
  delay(10000);
  if(mySerial.find("OK"))
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
  mySerial.println("AT+CIPSTART=\"TCP\",\""+host+"\",8787");
  delay(500);
  if(Serial.find("ERROR")) return;
  
  Serial.println("Send data...");
  String url=char_input;
  String cmd="GET /process.php?temp="+url+" HTTP/1.0\r\n\r\n";
  mySerial.print("AT+CIPSEND=");
  mySerial.println(cmd.length());
  Serial.print("AT+CIPSEND=");
  Serial.println(cmd.length());
  if(mySerial.find(">"))
  {
    Serial.print(">");
  }else
  {
    mySerial.println("AT+CIPCLOSE");
    Serial.println("connect timeout");
    delay(1000);
    return;
  }
  delay(500);
       
  mySerial.println(cmd);
  Serial.println(cmd);
  delay(100);
  if(Serial.find("ERROR")) return;
  mySerial.println("AT+CIPCLOSE");
  delay(100);
  }  


void setup() {

  Serial.begin(9600);
  mySerial.begin(9600);

  connectWifi();
  delay(500);
}

void loop() {
  DHT.read11(DHT11_PIN);
  
  humi = DHT.humidity;
  temp = DHT.temperature; 
  String str_output = String(temp)+"&humi="+String(humi);
  delay(1000);
  httpclient(str_output);
  delay(1000);
   
   //Serial.find("+IPD");
   while (mySerial.available())
   {
    char response = mySerial.read();
    Serial.write(response);
    if(response=='\r') Serial.print('\n');
    }
   Serial.println("\n==================================\n");
   delay(2000);
}
