function [ChannelStructure] = implement_crossover_network( ...
    ChannelStructure, k)
%implement_crossover_network uses crossover network to separate channels in
%to LF and HF sections

%   filters are used to separate ambisonic channels in to a low-frequency
%   and high-frequency sections which are used for feeding in to the 
%   respective LF and HF decoding matrices

b_lowpass_0 = k^2 / (k^2 + 2*k + 1);
b_lowpass_1 = 2 * b_lowpass_0;
b_lowpass_2 = b_lowpass_0;

b_highpass_0 = 1 / (k^2 + 2*k + 1);
b_highpass_1 = -2 * b_lowpass_0;
b_highpass_2 = b_lowpass_0;

a_0 = 1;
a_1 = 2 * (k^2 - 1) / (k^2 + 2*k + 1);
a_2 = (k^2 - 2*k + 1) / (k^2 + 2*k + 1);

b_lowpass(1) = b_lowpass_0;
b_lowpass(2) = b_lowpass_1;
b_lowpass(3) = b_lowpass_2;

b_highpass(1) = b_highpass_0;
b_highpass(2) = b_highpass_1;
b_highpass(3) = b_highpass_2;

a(1) = a_0;
a(2) = a_1;
a(3) = a_2;

lf_channels = filter(b_lowpass, a, ChannelStructure.nfc_channels);
hf_channels = filter(b_highpass, a, ChannelStructure.nfc_channels);

ChannelStructure.lf_nfc_channels = lf_channels;
ChannelStructure.hf_nfc_channels = hf_channels;
end

