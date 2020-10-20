function [b_lowpass, b_highpass, a] = write_crossover_network_filters(k)
%write_crossover_network_filtes calculates the 2nd order lowpass and 
%highpass filter coefficients needed to implement the crossover network
%
%   Detailed explanation goes here

b_lowpass_0 = k^2 / (k^2 + 2*k + 1);
b_lowpass_1 = 2 * b_lowpass_0;
b_lowpass_2 = b_lowpass_0;

b_highpass_0 = 1 / (k^2 + 2*k + 1);
b_highpass_1 = -2 * b_highpass_0;
b_highpass_2 = b_highpass_0;

a_0 = 1;
a_1 = 2 * (k^2 - 1) / (k^2 + 2*k + 1);
a_2 = (k^2 - 2*k + 1) / (k^2 + 2*k + 1);

b_lowpass = [b_lowpass_0, b_lowpass_1, b_lowpass_2];
b_highpass = [b_highpass_0, b_highpass_1, b_highpass_2];

a = [a_0, a_1, a_2];
end

