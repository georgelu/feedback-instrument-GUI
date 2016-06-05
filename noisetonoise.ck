//define GUI
MAUI_View control_view;
MAUI_Slider pitshift;
MAUI_Slider delay;
MAUI_Slider reverb;
control_view.size( 250, 250 );
control_view.name("NOISE");


//initialize preset values to tune our feedback instrument
pitshift.range(0,2);
pitshift.value(1);
pitshift.size(200,pitshift.height() );
pitshift.position(0,0);
pitshift.value(.8);
pitshift.name("pitch");
control_view.addElement(pitshift);


delay.range(0,1000);
delay.size(200,delay.height() );
delay.position(0,50);
delay.value(500);
delay.name("delay");
control_view.addElement(delay);

reverb.range(0,10);
reverb.size(200,reverb.height() );
reverb.position(0,100);
reverb.value(5);
reverb.name("reverb");
control_view.addElement(reverb);

//enable keyboard control
control_view.display();
Hid keyboard;
keyboard.openKeyboard(0);
HidMsg msg;

//some magic ascii values corresponding to keyboard controls
while(true)
{
   if(keyboard.recv(msg) && msg.type == Hid.BUTTON_DOWN) {
        if (msg.ascii==81) {
            pitshift.value(pitshift.value()-.05);
        }
        if (msg.ascii==87) {
            pitshift.value(pitshift.value()+.05);
        }
        if (msg.ascii==65) {
            delay.value(delay.value()-10);
        }
        if (msg.ascii==83) {
            delay.value(delay.value()+10);
        }
        if (msg.ascii==90) {
            reverb.value(reverb.value()-.5);
        }
        if (msg.ascii==88) {
            reverb.value(reverb.value()+.5);
        }
    }
    
    //feed our Mic input through filters (and back through the Mic)
    adc => PitShift p => Delay d => PRCRev r => dac;
    adc.gain(10); 
    1 => p.mix; 
    p.shift (pitshift.value()); 
    
    delay.value() => float DTime;
    DTime::samp => d.delay;
    
    reverb.value() => r.mix;
    minute => now;
    
}

