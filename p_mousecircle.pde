//javaを勉強したら分かります。
import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;

Ripple rip;
List<Ripple> ripList = new  ArrayList<Ripple>();

void setup()
{
    size(700,700);
    colorMode(HSB, 360,255,255);
    background(0, 0, 0);
}

void draw()
{
    fade();
    Iterator<Ripple> iter = ripList.iterator();
    while(iter.hasNext())
    {
        Ripple rip = iter.next();
        rip.update();
        rip.display();
        if(rip.getDiameter() > width)
        {
            iter.remove();
        }
    }
}

//クリックされたときに実行される
void mousePressed()
{
   ripList.add(new Ripple(mouseX, mouseY)); //波紋を追加する
}

void fade()
{
  noStroke();
  fill(0,0,0,50);
  rect(0,0,width, height);
}

class Ripple 
{
    private float x, y;
    private float d;
    private color c;
    
    public Ripple(float x, float y)
    {
        this.x = x;
        this.y = y;
        this.d = 1;
        this.c = color(random(360), 200, 200);
    }
    
    public float getDiameter()
    {
        return d;
    }
    
    public void setDiameter(float d)
    {
        this.d = d;
    }
    
    public void update()
    {
        d += 5.0;
    }
    
    public void display()
    {
        noFill();
        stroke(c);
        strokeWeight(5);
        ellipse(x, y, d, d);
    }
}
