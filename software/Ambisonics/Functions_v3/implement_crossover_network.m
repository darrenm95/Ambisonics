function [B_Format_Channels_Struc] = implement_crossover_network( ...
    B_Format_Channels_Struc, Filters)
%implement_crossover_network uses crossover network to separate channels in
%to LF and HF sections

%   filters are used to separate ambisonic channels in to a low-frequency
%   and high-frequency sections which are used for feeding in to the 
%   respective LF and HF decoding matrices



B_Format_Channels_Struc.b_format_channels_nfc_lf = filter( ...
    Filters.b_lowpass_crossover, Filters.a_crossover, ...
    B_Format_Channels_Struc.b_format_channels_nfc);

B_Format_Channels_Struc.b_format_channels_nfc_hf = filter( ...
    Filters.b_highpass_crossover, Filters.a_crossover, ...
    B_Format_Channels_Struc.b_format_channels_nfc);

end

