function [B_Format_Channels_Struc] = apply_nfc_filter( ...
    B_Format_Channels_Struc, Filters)
%apply_nfc_filter applies near-field compensation to 
%
%   1st order ambisonic components represent the X,Y,Z particle velocity
%   channels which refer to acn channels 1-3, these channels are filtered
%   with a near-field correction %% more work needs to be done to ensure
%   that nfc correction can be extended to higher order ambisonics

B_Format_Channels_Struc.b_format_channels_nfc(1,:) = ...
    B_Format_Channels_Struc.b_format_channels(1,:);

for i = 2 : size(B_Format_Channels_Struc.b_format_channels, 1)
    B_Format_Channels_Struc.b_format_channels_nfc(i,:) = ...
        filter(Filters.b_nfc, Filters.a_nfc, ...
        B_Format_Channels_Struc.b_format_channels(i,:));
end

end

