#include "DHT.h"
#include <SoftwareSerial.h>
#define DHTPIN 4  
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);
SoftwareSerial BTserial(2, 3); // RX | TX


const int AirValue = 625;   //you need to replace this value with Value_1 
const int WaterValue = 340;  //you need to replace this value with Value_2 
int intervals = (AirValue - WaterValue)/3;    
int soilMoistureValue = 0; 

void setup() {
  Serial.begin(9600); // open serial port, set the baud rate as 9600 bps 
  dht.begin();
  // HC-06 default serial speed is 9600
  BTserial.begin(9600);  
}

void loop() {
     // Keep reading from HC-06 and send to Arduino Serial Monitor
    if (BTserial.available())
    {  
        Serial.write(BTserial.read());
        printData();
    }
 
    // Keep reading from Arduino Serial Monitor and send to HC-06
    if (Serial.available())
    {
        BTserial.write(Serial.read());
    }
 
  
}

void printData() {
  float moisture; 
  float light;
  float humidity = dht.readHumidity();
  float temp = dht.readTemperature(true); // In Fahrenheit

  if (isnan(humidity) || isnan(temp)) {
//    Serial.println(F("Failed to read from DHT sensor!"));
//    return;
  }
  moisture = analogRead(0); //connect sensor to Analog 0
  light = digitalRead(5);

  moisture = 1 - (moisture - WaterValue) / (AirValue - WaterValue); 
  BTserial.print(moisture); //print the value to serial port   
  BTserial.print(" ");
  BTserial.print(humidity);
  BTserial.print(" ");
  BTserial.print(temp);
  BTserial.print(" ");
  BTserial.print(light);
  BTserial.println();
  delay(100);

}
