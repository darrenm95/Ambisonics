function [ChannelStructure] = apply_nfc_filter(ChannelStructure, ...
    k)
%apply_nfc_filter applies near-field compensation to 1st order ambisonic
%components
%
%   1st order ambisonic components represent the X,Y,Z particle velocity
%   channels which refer to acn channels 1-3

b0 = 1 / (k + 1);
b1 = -b0;
a0 = 1;
a1 = (k - 1) / b0;

b(1) = b0; b(2) = b1;
a(1) = a0; a(2) = a1;

acn_ordered_channels = ChannelStructure.channels;
acn_0_channel = acn_ordered_channels(1, :);
acn_1_channel = acn_ordered_channels(2, :);
acn_2_channel = acn_ordered_channels(3, :);
acn_3_channel = acn_ordered_channels(4, :);

nfc_acn_1_channel = filter(b, a, acn_1_channel);
nfc_acn_2_channel = filter(b, a, acn_2_channel);
nfc_acn_3_channel = filter(b, a, acn_3_channel);

nfc_acn_ordered_channels = [acn_0_channel; nfc_acn_1_channel; ...
    nfc_acn_2_channel; nfc_acn_3_channel];

ChannelStructure.nfc_channels = nfc_acn_ordered_channels;
end

