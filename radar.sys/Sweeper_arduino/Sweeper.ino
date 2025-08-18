#include <Servo.h>

// Ultrasound sensor
long duration;  // variable for the duration
long distance;

const int trigPin = 10;
const int echoPin = 11;

// Servo motor
Servo myservo;       
int pos = 0;
int time = 50;

void setup() {
  // Ultrasound
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin(115200);

  // Servo
  myservo.attach(6);
}

void loop() {
  // Sweep from 0 to 180
  for (pos = 0; pos <= 180; pos++) {
    myservo.write(pos);
    delay(time);

    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);

    duration = pulseIn(echoPin, HIGH);
    distance = duration * 0.034 / 2;

    Serial.print(pos);
    Serial.print(",");
    Serial.println(distance);

    delay(10);
  }

  delay(1000);  // Optional pause at 180

  // Sweep from 180 to 0
  for (pos = 180; pos >= 0; pos--) {
    myservo.write(pos);
    delay(time);

    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);

    duration = pulseIn(echoPin, HIGH);
    distance = duration * 0.034 / 2;

    Serial.print(pos);
    Serial.print(",");
    Serial.println(distance);

    delay(10);
  }

  delay(500);  // Optional pause at 0
}
