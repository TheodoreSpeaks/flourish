#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <sstream>
#include <vector>

#ifndef STASSID
#define STASSID "Example123" // YOUR WIFI NAME
#define STAPSK  "password" // YOUR WIFI PASSWORD
#endif

const char* ssid = STASSID;
const char* password = STAPSK;

ESP8266WebServer server(80);

const int led = 13;
/*
 * GET("/") - recieves string of sensor values from Arduino Nano Serial.print()
 * GET("/inline") - test the server should responsd with "test"
 * 
 * Board used "Generic ESP8266 Module"
 */
void handleRoot() {
  digitalWrite(led, 1);
  String s = Serial.readString(); // read the serial print from the arduino nano
  String payload ="";
  bool newline = false;
  for(int i = 0; i<s.length();i++){ // only get last line (most recent from buffer) 
      if(newline){
          payload = "";
          newline = false;
      }
      char c = s.charAt(i);
      payload += c;
      if(c == '\n'){
          newline = true;
      }
  }
  
  server.send(200, "text/plain", payload); // send the sensor values
  digitalWrite(led, 0);
}

void handleNotFound() {
  digitalWrite(led, 1);
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server.uri();
  message += "\nMethod: ";
  message += (server.method() == HTTP_GET) ? "GET" : "POST";
  message += "\nArguments: ";
  message += server.args();
  message += "\n";
  for (uint8_t i = 0; i < server.args(); i++) {
    message += " " + server.argName(i) + ": " + server.arg(i) + "\n";
  }
  server.send(404, "text/plain", message);
  digitalWrite(led, 0);
}

void setup(void) {
  pinMode(led, OUTPUT);
  digitalWrite(led, 0);
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("");

  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  if (MDNS.begin("esp8266")) {
    Serial.println("MDNS responder started");
  }

  server.on("/", handleRoot);

  server.on("/inline", []() {
    server.send(200, "text/plain", "test");
  });

  server.onNotFound(handleNotFound);

  server.begin();
  Serial.println("HTTP server started");
}

void loop(void) {
  server.handleClient();
  MDNS.update();
}
