% target parameters
targetexcentricity = 3*ppd; % target excentricity (in degrees of visual angle)
targetdiameter = 2*ppd; % target diameter
targetfwhm = 1*ppd; % target FWHM (in degrees of visual angle)
targetfrequency = 4/ppd; % target spatial frequency (in cycles per degree of visual angle)
targetdeclination = 30/180*pi; % in radians
targetx = targetexcentricity*cos(targetdeclination);
targety = targetexcentricity*sin(targetdeclination);
hor_vert_exclusion = 30; % in degrees : exclude +- hor_vert_exclusion around vert and hor axes from possible target orientation
