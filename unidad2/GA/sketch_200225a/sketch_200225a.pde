PImage img;

int nIndividuos=500;
int nIteraciones=50;
int d=50;
float conv=175.78125;
int ratioSobrevivencia=80;
int ratioMutacion=20;

int nframe=0;
float bestX=0, bestY=0, bestVal=1000;

Individuo[] poblacion;

class Individuo{
  float x, y, rx,ry, val, xg, yg;
  String binX, binY;
  
  Individuo(){
    x=int(random(51200))-25600;
    y=int(random(51200))-25600;
    rx=x/10000;
    ry=y/10000;
    xg=(x+25600)*0.017578125;
    yg=(y+25600)*0.017578125;
    val = 20 + rx*rx-10*cos(2*PI*rx) + ry*ry-10*cos(2*PI*ry);
    binX=numABin(x);
    binY=numABin(y);
    if(val<bestVal){
      bestX=rx;
      bestY=ry;
      bestVal=val;
    }
  }
  
  void display(){
    fill(0, 255, 0);
    ellipse (xg,yg,10,10);
  }
}

String numABin(float num){
  String binario="", signo;
  if(num<0){
    signo="-";
  }else{
    signo="0";
  }
  while(num!=0){
    if(int(num%2)==0){
      binario="0"+binario;
    }else{
      binario="1"+binario;
    }
    num=int(num/2);
  }
  for(int i=binario.length(); i<16; i++){
    binario="0"+binario;
  }
  return signo+binario;
}

int binANum(String bin){
  char bit=' ';
  int val=2;
  int suma=0;
  int c=0;
  for(int i=1; i>0; i--){
    bit=bin.charAt(i);
    suma+=int(bit)*val*2^c;
    c++;
  }
  if (bin.charAt(0)=='-') suma=suma*-1;
  return 0;
}

void combinacion(){
  Individuo[] sobrevivientes=sobrevivencia(poblacion);
  int count=sobrevivientes.length;
  Individuo[] sobrevivientesFinal=new Individuo[count+(nIndividuos*(1-ratioSobrevivencia/100))];
  for(int i=0; i<count; i++){
    sobrevivientesFinal[i]=sobrevivientes[i];
  }
  int n1, n2;
  String xh="";
  String yh="";
  for(int i=0; i<nIndividuos*(1-ratioSobrevivencia/100); i++){
    n1=int(random(count));
    String xp1=sobrevivientes[n1].binX;
    String yp1=sobrevivientes[n1].binY;
    n2=int(random(count));
    String xp2=sobrevivientes[n2].binX;
    String yp2=sobrevivientes[n2].binY;
    for(int j=0; j<16; j++){
      if(random(100)<=ratioMutacion){
        if(j==0){
          if(int(random(2))==0){
            xh=xh+"0";
          }else{
            xh=xh+"-";
          }
          if(int(random(2))==0){
            yh=yh+"0";
          }else{
            yh=yh+"-";
          }
          
        }else{
          xh=xh+String.valueOf(int(random(2)));
          yh=yh+String.valueOf(int(random(2)));
        }
      }else{
        if(random(100)<50){
           xh=xh+xp1.charAt(j);
           yh=yh+yp1.charAt(j);
        }else{
          xh=xh+xp2.charAt(j);
          yh=yh+yp2.charAt(j);
        }
      }
    }
    Individuo ind=new Individuo();
    ind.x=binANum(xh);
    ind.y=binANum(yh);
    sobrevivientesFinal[count+i]=ind;
  }
  poblacion=new Individuo[sobrevivientesFinal.length];
  poblacion=sobrevivientesFinal;
}

Individuo[] sobrevivencia(Individuo[] poblacion){
  Individuo[] sobrevivientes=new Individuo[nIndividuos*ratioSobrevivencia/100];
  for(int i=0; i<nIndividuos*ratioSobrevivencia/100; i++){
    sobrevivientes[i]=poblacion[i];
  }
  return sobrevivientes;
}

void ordenar(){
  Individuo tmp;
  for (int x = 0; x < poblacion.length; x++) {
    for (int i = 0; i < poblacion.length-x-1; i++) {
      if(poblacion[i].val > poblacion[i+1].val){
        tmp = poblacion[i+1];
        poblacion[i+1] = poblacion[i];
        poblacion[i] = tmp;
      }
    }
  }
}

void despliegaBest(){
  PFont f = createFont("Arial",16,true);
  textFont(f,15);
  fill(#000000);
  text("Frame numero: " + nframe + "\nMejor Posicion X: " + bestX + "\nMejor Posicion Y: " + bestY + "\nMejor Valor: " + bestVal, 10, 20);
}

void setup(){
  size(900,900);
  img=loadImage("rastrigin.jpg");
  smooth();
  poblacion=new Individuo[nIndividuos];
  for (int i=0; i<nIndividuos; i++){
    poblacion[i]=new Individuo();
  }
}

void draw(){
  image(img, 0, 0, width, height);
  for(int i=0; i<nIndividuos; i++){
    poblacion[i].display();
  }
  sobrevivencia(poblacion);
  combinacion();
  ordenar();
  despliegaBest();
  nframe+=1;
  
  //noStroke();
}
