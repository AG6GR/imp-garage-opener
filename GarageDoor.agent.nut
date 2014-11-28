//---Definitions---
local lastToggleTime;

//---Functions---
// Generates HTML response message
    // String time : tells time elapsed since last toggle
function generateHTML(time)
{
    return @"<!DOCTYPE html>
    <html lang = ""en"">
	<head>
		
		<meta name=""apple-mobile-web-app-capable"" content=""yes"">
		
		<title>Garage Door Opener</title>
	</head>
	<body>
		<center>
			<h2>Garage Door Opener</h2>
			<img src=""http://icons.iconarchive.com/icons/oxygen-icons.org/oxygen/128/Actions-go-home-icon.png"">
			</br>" 
			+ "Door last switched: " + time + @"
			</br>
			<a href=" + http.agenturl()+ "?toggle" + @">Switch Door</a>
		</center>
	</body>
</html>";
}
// Calculates and formats the time elapsed from startTime to the present.
    // int startTime : Epoch time representation of starting time
function calcTimeElapsed(startTime)
{
    returnString = "";
    secondsElapsed = time() - startTime;
    // Minutes
    if(secondsElapsed > 60)
    {
        // Hours
        if(secondsElapsed > 3600)
        {
            // Days
            if(secondsElapsed > 86400)
            {
                returnString += secondsElapsed / 86400 + " Days, ";
                secondsElapsed %= 86400;
            }
            returnString += secondsElapsed / 3600 + " Hours, ";
            secondsElapsed %= 3600;
        }
        returnString += secondsElapsed / 60 + " Minutes, ";
        secondsElapsed %= 60;
    }
    // Seconds
    returnString += secondsElapsed + " Seconds";
}
// Handler for HTTP requests
    // request : request object
    // response : response object
function handlerHttpRequest(request, response)
{
    try
    {
        if ("toggle" in request.query)
        {
            device.send("toggle",null);
            lastToggleTime = time();
            server.log("Activating relay");
        }
         respsonse.send(200, generateHTML(calcTimeElapsed(lastToggleTime)));
            //Display status
    }
    catch (error)
    {
        // Something went wrong; inform the source of the request
        // '500' is HTTP status code for 'Internal Server Error'
        
        response.send(500, error)
    }
}
// Handler for reseting the time count when the device detects the external
//  button has been pushed.
    // data : data from the device, not used
function handlerToggleReset(data)
{
    lastToggleTime = time();
}
//---Main---
server.log("URL: " + http.agenturl());

//Register handlers
http.onRequest(handlerHttpRequest);
agent.on("toggle", handlerToggleReset);

//Initialize timer
lastToggleTime = time();