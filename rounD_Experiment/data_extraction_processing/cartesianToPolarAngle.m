function theta = cartesianToPolarAngle(x, y)
    % Calculate the angle in radians using the atan2 function
    angle_rad = atan2(y, x);
    
    % Convert the angle to the range [0, 2π]
    angle_rad(angle_rad<0) = angle_rad(angle_rad<0)+2*pi;
    
    % Convert the angle from radians to degrees
    theta = rad2deg(angle_rad);
end
