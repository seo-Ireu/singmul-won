#include <SoftwareSerial.h>
/*
 * 블루투스 통신은 따로 했을 경우 잘 됨.
 * 
 */
SoftwareSerial bluetooth(8, 9);

void setup() {
  Serial.begin(9600);
  bluetooth.begin(9600);

}
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
