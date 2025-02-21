
const int PIN_SENSOR=A2;

const int distanciaFinBuzon = 550;
const int umbralDistancia = 0;

const long CARTA_RECIBIDA_MAX_MILLIS = 3000;
const long BUZON_LLENO_MILIS = 20000;

int BUZON_LLENO_NOTIFICADO = 0;
int CARTA_RECIBIDA = 0;
long CARTA_RECIBIDA_MILLIS =0;

int ADC0_promedio(int n)
{
  long suma=0;
  for(int i=0;i<n;i++)
  {
    suma=suma+analogRead(PIN_SENSOR);
  }  
  return(suma/n);
}

void comprobarCartaRecibida(){
  int distancia = ADC0_promedio(100);
    //Serial.println(distancia);
    if(distancia > distanciaFinBuzon + umbralDistancia && !CARTA_RECIBIDA){
      CARTA_RECIBIDA = 1;
      CARTA_RECIBIDA_MILLIS = millis();
      Serial3.println("NOTIF_LETTER");
      delay(300);
      Serial.println("NUEVA CARTA");
    }
    if(CARTA_RECIBIDA && distancia <= distanciaFinBuzon + umbralDistancia && (millis()-CARTA_RECIBIDA_MILLIS)> CARTA_RECIBIDA_MAX_MILLIS){
      CARTA_RECIBIDA =0;
      BUZON_LLENO_NOTIFICADO = 0;
      CARTA_RECIBIDA_MILLIS = 0;
      //Serial.println("BUZON RESET");
    }

    if(CARTA_RECIBIDA && !BUZON_LLENO_NOTIFICADO && (millis()-CARTA_RECIBIDA_MILLIS)> BUZON_LLENO_MILIS){
      BUZON_LLENO_NOTIFICADO = 1;
      Serial3.println("NOTIF_FULL");
      delay(300);
      //Serial.println("BUZON LLENO");
    }
}

