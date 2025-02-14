int buzzer = 32;

void emitSound(int sound, int time){
    tone(buzzer, sound);
    delay(time);
    noTone(buzzer);
}

void keySound() {
  tone(buzzer, 1000);
  delay(300);
  noTone(buzzer);
}

void keySoundWrong() {
  tone(buzzer, 1000);
  delay(300);
  noTone(buzzer);
  delay(100);
  tone(buzzer, 1000);
  delay(300);
  noTone(buzzer);
  delay(100);
  tone(buzzer, 1000);
  delay(300);
  noTone(buzzer);
}