function [ az_deg ] = ambisonic_az_to_binaural_az( azimuth_angle )
%ambisonic_az_to_binaural_az converts ambisonic defined azimuth angle to
%binaurally defined azimuth angle
%
%   Ambisonics defines 0 to be straight on and 90 degrees to be left whilst
%   binaural hrtf kemer filters define azimuth equals 0 to be straight on
%   but 90 degrees to be to the right

az_deg = [0; flip(azimuth_angle(2:end))]; %this won't work if start_angle is non-zero

end

