/*
 * This macro demonstrates parameter use. Detailed info can be found here: 
 * https://imagej.net/Script_Parameters
 * Parameters are a great way to prompt the user for variables to be used 
 * in the script, such as file location, channel to ignore, whether or not 
 * to apply a certain filter
 * 
 * Parameters must be placed at the top of the script (comments can be before).
 * Here is a breakdown of components of parameter:
 * 
 *                               #@ == parameter start
 *                          Boolean == variable type
 * (label = "Example, value = true) == labels and default values
 *                      exampleBool == variable name
 * 
 * Click run to see what these examples look like
 */

//Simple boolean
#@ Boolean (label = "Simple checkbox boolean") exampleBool1

//Value is the default value, description displays a mouse over message
#@ Boolean (label = "Example checkbox boolean", value = true, description = "Mouse over this...") exampleBool2

//Use choices to add choices to a drop down menue
#@ String (label = "Example Choice", choices = {"Max Intensity", "Average Intensity"}) exampleChoice

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ File (label = "Individual File", style = "file") file


#@ String (label = "File suffix", value = ".tif") suffix
#@ String (label = "Large Box String", value = "enter message here", style = "text area") exampleString
#@ String (label = "Small Box String", value = "enter message here", style = "text field") exampleStringtwo

#@ Integer (label = "Example integer", value = 0) exampleInt

#@ ColorRGB (label = "example color") exampleColor

#@ Date (label = "example date") exampleDate



//Print out all of these variables
print(exampleBool1);
print(exampleBool2);
print(exampleChoice);
print(input);
print(output);
print(file);
print(suffix);
print(exampleString);
print(exampleStringtwo);
print(exampleInt);
print(exampleColor);
print(exampleDate);


