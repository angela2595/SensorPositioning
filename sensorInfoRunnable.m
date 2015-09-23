%{
Parameters
Curve:
dx - distance between each sensor in the x direction of the curved plane. 
Distance is measured from the center of one sensor to the center of the next 
sensor (m)
dz - distance between each sensor in the z direction of the curved plane. 
Distance is measured from the center of one sensor to the center of the next 
sensor (m)
r - the radius of the circle that the curved plane follows; r = inf if the
plane has no curve (m)

Grid:
dzInitial - distance between 0 on the plane and the first sensor in the z
direction. Distance is measured from the center of the sensor (m)
dyInitial - translation above or below the x-axis (along the y-axis) (m)
xNum - integer representing the number of sensors in the x direction
zNum - integer representing the number of sensors in the z direction
stagger - if grid should be staggered or not; integer value 1, 2 or 3. 
Value of 1 represents no staggering, value of 2 represents staggering each
row by 1/2 and value of 3 represents staggering each row by 1/3.

Angle:
psi - the sensor's pitch angle (degrees)

File:
folderPath - folder path of the resulting text file
fileName - name of the resulting text file

Outputs:
name - the name of the sensor following the format SEN_####, where the
first two digits represent the position on the (curved) x-axis, and the last 
two digits represent the position on the z-axis. Starts at SEN_0000 (bottom 
left) and ends at the sensor at the top right, up to a maximum of SEN_9999 
(10,000 sensors)
x - position in the x direction (m)
y - position in the y direction (m)
z - position in the z direction (m)
theta - angle theta defined by the TSAR definitions document (degrees)
phi - angle phi defined by the TSAR definitions document (degrees)
psi - angle psi defined by the TSAR definitions document (degrees)

Written by: Angela Cheng
%}

%Random parameters; change to fit the curve that is being used
%Descriptions of parameters are in the comments above
param.curve.dx = 0.013;
param.curve.dz = 0.013;
param.curve.r = 2;
param.grid.dzInitial = 0.00893;
param.grid.dyInitial = 0;
param.grid.xNum = 10;
param.grid.zNum = 5;
param.grid.stagger = 3;
param.angle.psi = 0;
param.file.folderPath = 'C:\Users\angela\Desktop';
param.file.fileName = 'SampleSensorPos.txt';

%Make sure to check that your folder path/fileName is correct before this 
%is run! 
%If the function is called on different parameters with the same
%folderPath and fileName, the original file will be overwritten.

%Call the function using the parameters
sensorPositionStagger(param);