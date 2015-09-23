%{
Assumptions:
1. Only one psi value is given (same psi for all sensors)
2. Assume all sensors are on the bottom plane (theta = 90, phi = 270)
3. Sensors are located on a flat plane
4. xNum and zNum are integer values greater than 0

This function outputs a cell array of information containing a list of
sensors and their [name, x, y, z, theta, phi, psi] information (in that 
particular order).
 
Parameters: 
dx - distance between each sensor in the x direction of the plane (m)
dz - distance between each sensor in the z direction of the plane (m)
xNum - integer representing the number of sensors in the x direction
zNum - integer representing the number of sensors in the z direction
psi - the sensor's pitch angle (degrees)

Written by: Angela Cheng
%}
   
function [m] = sensorInfo(dx, dz, xNum, zNum, psi)
% middle is the value on the x-axis that represents the Antenna Reference
% Point position 0 
middle = (dx*(xNum-1))/2.0;
d = 1; % a counter for total number of sensors

sensorNum = xNum*zNum; % total number of sensors

m = cell(sensorNum, 7); % create a cell of the appropriate size
m(:,3) = {0}; % known, constant value [y]
m(:,5) = {90}; % known, constant value [theta]
m(:,6) = {270}; % known, constant value [phi]
m(:,7) = {psi}; % known, constant value [psi]

for c = 0:zNum-1
    for b = 0:xNum-1
        m(d, 2) =  {b*dx - middle};
        m(d, 4) = {-c*dz};
        m(d, 1) = {strcat('SEN_', num2str(c,'%02d'), num2str(b,'%02d'))};
        d = d + 1;
    end
end

%Write cell to .txt file
FolderPath='T:\SubProjects\SummerStudent\Angela';
FileName='AntPos.txt';
FilePath= [FolderPath '\' FileName];
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