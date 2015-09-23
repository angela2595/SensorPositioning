%{
Assumptions:
1. Only one psi value is given (same psi for all sensors)
2. Assume all sensors are on the bottom plane (theta = 90, phi = 270)
3. The plane the sensors sit on follow the curvature of a circle with
   radius r
4. xNum and zNum are integer values greater than 0

This function outputs a cell array of information containing a list of
sensors and their [name, x, y, z, theta, phi, psi] information (in that 
particular order).
 
Parameters: 
dx - distance between each sensor in the x direction of the curved plane (m)
dz - distance between each sensor in the z direction of the curved plane (m)
dzInitial - distance between 0 on the plane and the first sensor in the z
direction (m)
r - the radius of the circle that the curved plane follows
xNum - integer representing the number of sensors in the x direction
zNum - integer representing the number of sensors in the z direction
psi - the sensor's pitch angle (degrees)
folderPath - folder path of the resulting text file
fileName - name of the resulting text file

Outputs:
name - the name of the sensor following the format SEN_####, where the
first two digits represent the position on the (curved) x-axis, and the last 
two digits represent the position on the z-axis
x - position in the x direction (m)
y - position in the y direction (m)
z - position in the z direction (m)
theta - angle theta defined by the TSAR definitions document (degrees)
phi - angle phi defined by the TSAR definitions document (degrees)
psi - angle psi defined by the TSAR definitions document (degrees)

Written by: Angela Cheng
%}

function [m] = sensorInfoCurved(param)

% Sample set of data and it's input format:
% param.curve.dx = 0.1;
% param.curve.dz = 0.1;
% param.curve.dzInitial = 0.1;
% param.curve.r = 0.5;
% param.grid.xNum = 5;
% param.grid.zNum = 5;
% param.grid.psi = 0;
% param.file.folderPath = 'T:\SubProjects\SummerStudent\Angela';
% param.file.fileName = 'AntPosCurved.txt';

% middle is the value on the x-axis that represents the Antenna Reference
% Point position 0 
middle = (param.curve.dx*(param.grid.xNum-1))/2.0;
angleSub = param.curve.dx/param.curve.r; % subtended angle = arc/radius
angle = middle/param.curve.r;
d = 1; % a counter for total number of sensors

sensorNum = param.grid.xNum*param.grid.zNum; % total number of sensors

m = cell(sensorNum, 7); % create a cell of the appropriate size

m(:,5) = {90}; %Known, constant value [theta]
m(:,7) = {param.grid.psi}; %Known, constant value from input parameters [psi]

%Flat surface
if param.curve.r == inf
    m(:,3) = {0}; % known, constant value [y]
    m(:,6) = {270}; % known, constant value [phi]
    for b = 0:param.grid.xNum-1
        for c = 0:param.grid.zNum-1
            m(d, 2) =  {b*param.curve.dx - middle};
            m(d, 4) = {-c*param.curve.dz - param.curve.dzInitial};
            m(d, 1) = {strcat('SEN_', num2str(b,'%02d'), num2str(c,'%02d'))};
            d = d + 1;
        end
    end
%Curved surface
else
    for b = 0:param.grid.xNum-1
        for c = 0:param.grid.zNum-1
            %Calculate x and y from parametrization of circle [cos(angleSub),
            %r+sin(angleSub)]
            m(d,2) = {param.curve.r*cos(-(pi/2)-angle+b*angleSub)};
            m(d,3) = {param.curve.r + param.curve.r*sin(-(pi/2)-angle+b*angleSub)};
            x = cell2mat(m(d,2)); %Convert cell to array
            y = cell2mat(m(d,3)); %Convert cell to array
        
            %Compute angle phi using equation of tangent line
            m(d,6) = {270 + (atan(-x/(y-param.curve.r))*(180/pi))}; 
            m(d,4) = {-c*param.curve.dz - param.curve.dzInitial}; %Compute z value
            m(d,1) = {strcat('SEN_', num2str(b,'%02d'), num2str(c,'%02d'))};
            d = d + 1; %Increment d
        end
    end   
end

%Write cell to .txt file
FilePath= [param.file.folderPath '\' param.file.fileName];
fid = fopen(FilePath, 'wt');

nameCell = m(:,1);

for a = 1:sensorNum
    name = nameCell{a};
    x = cell2mat(m(a,2));
    y = cell2mat(m(a,3));
    z = cell2mat(m(a,4));
    theta = cell2mat(m(a,5));
    phi = cell2mat(m(a,6));
    psi = cell2mat(m(a,7));
    fprintf(fid, '%s ', name);
    fprintf(fid, '%-1.4f %-1.4f %-1.4f %-1.1f %-1.1f %-1.1f\n', [x;y;z;theta;phi;psi]);   
end
fclose(fid);
end