int num = 80;

float[] x  =new float[num];
float[] y  =new float[num];
float[] r  =new float[num];
float[] dx  =new float[num];
float[] dy  =new float[num];

float[] ctrDirX =new float[num];    
float[] ctrDirY =new float[num];    
float[] vel =new float[num];
float[] velAngle =new float[num];
float[] contX =new float[num];    
float[] contY =new float[num];    
float[] kX =new float[num];    
float[] kY =new float[num];    

float aveX, aveY, aveAngle, aveVel;
float velX, velY;

void setup() {
  for (int i=0; i<num; i++) {
    r[i]     = 10;
    x[i]     = 250+80*cos(radians((360/num)*i));
    y[i]     = 250+80*sin(radians((360/num)*i));
    velAngle[i] = (360/num)*i;
    vel[i]   = random(0, 5.5);
    dx[i]    = vel[i]*cos(radians(velAngle[i]));
    dy[i]    = vel[i]*sin(radians(velAngle[i]));
  }

  size(500, 500);
  background(240);
  smooth();
}

void draw() {
  background(240);
  stroke(100);
  strokeWeight(1);
  noFill();
  for (int i=0; i<num; i++) {
    ellipse(x[i], y[i], 10, 10);
    line(x[i], y[i], x[i]+10*dx[i], y[i]+10*dy[i]);
  }

//群の中心に向かう部分
  aveX = 0;
  aveY = 0;
  for (int i=0; i<num; i++) {
    aveX += x[i];
    aveY += y[i];
  }
  aveX /= num;
  aveY /= num;
  if (mousePressed == true) {
    aveX = mouseX;
    aveY = mouseY;
    stroke(0, 0, 255);
    fill(0, 0, 255);
    ellipse(aveX, aveY, 10, 10);
  } 

  for (int i=0; i<num; i++) {
    ctrDirX[i] = aveX - x[i];
    ctrDirY[i] = aveY - y[i];
    //stroke(0, 0, 255);
    //line(x[i], y[i], x[i]+0.1*ctrDirX[i], y[i]+0.1*ctrDirY[i]);
  }
  //stroke(0, 0, 255);
  //fill(0, 0, 255);
  //ellipse(aveX, aveY, 10, 10);

//周りと同じ方向速度になるように動く部分
  aveVel   = 0;
  aveAngle = 0;
  for (int i=0; i<num; i++) {
    aveVel   += sqrt(dx[i]*dx[i]+dy[i]*dy[i]);
    aveAngle += degrees(atan2(dy[i], dx[i]));
  }
  aveVel   /= num;
  aveAngle /= num;

  velX = aveVel*cos(radians(aveAngle));
  velY = aveVel*sin(radians(aveAngle));

  //stroke(0, 255,0);
  //for (int i=0; i<num; i++) {
  //line(x[i], y[i], x[i]+60*velX, y[i]+60*velY);
  //}

//互いに近づきすぎたら離れる
  for (int i=0; i<num; i++) {
    contX[i]=0;
    contY[i]=0;
    for (int j=0; j<num; j++) {
      if (i!=j) {
        float dist=sqrt((x[j]-x[i])*(x[j]-x[i])+(y[j]-y[i])*(y[j]-y[i]));
        if (0<dist&&dist<15) {
          contX[i] = -1*(x[j]-x[i]);
          contY[i] = -1*(y[j]-y[i]);
          float temp = sqrt(contX[i]*contX[i]+contY[i]*contY[i]);
          contX[i]/=temp;
          contY[i]/=temp;
        }
      }
    }
  }
  //for (int i=0; i<num; i++) {
  //stroke(255, 0, 0);
  //line(x[i], y[i], x[i]+contX[i], y[i]+contY[i]);
  //}

//各個体の動く方向と速度
  for (int i=0; i<num; i++) {
    kX[i] = 0.03*ctrDirX[i]+4.0*velX+5.0*contX[i];
    kY[i] = 0.03*ctrDirY[i]+4.0*velY+5.0*contY[i];

    float tempVel = sqrt(kX[i]*kX[i]+kY[i]*kY[i]);
    if (tempVel>2) {
      kX[i]=2*kX[i]/tempVel;
      kY[i]=2*kY[i]/tempVel;
    }

    dx[i] += (kX[i]-dx[i])*0.02;
    dy[i] += (kY[i]-dy[i])*0.02;

    x[i] += dx[i];
    y[i] += dy[i];

    if (x[i]>500)x[i]=0;
    if (x[i]<0)x[i]=500;
    if (y[i]>500)y[i]=0;
    if (y[i]<0)y[i]=500;
  }
}
