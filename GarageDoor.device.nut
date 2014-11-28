//---Definitions---
PIN_RELAY <- hardware.pin8;
PIN_BUTTON <- hardware.pin9;

//---Functions---
// Toggles the relay
    // data : data from message handler, not used
function toggleRelay(data)
{
    PIN_RELAY.write(1);
    imp.wakeup(0.5, relayOff);
}
// Turns the relay off
function relayOff()
{
    PIN_RELAY.write(0);
}
// Tells agent the external button has been pushed
function sendButtonPushed()
{
    agent.send("toggle", null);
}

//---Main---
//Configure Pins
PIN_RELAY.configure(DIGITAL_OUT, 0);
PIN_BUTTON.configure(DIGITAL_IN_PULLDOWN, sendButtonPushed);

//Register Handlers
device.on("toggle", toggleRelay);