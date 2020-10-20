function [ AmbiX_channels, samplingFrequency ] = fuma2ambix( FuMa_B_format_file )
%fuma2ambix converts 'FuMa' encoded B-Format file to 'AmbiX' encoded 
%B-Format file
%
%   uses 1st order 4 channel conversion matrix to convert FuMa ordering
%   rule and normalization to AmbiX ordering rule and normalization

[FuMa_channels, samplingFrequency] = audioread(FuMa_B_format_file);
FuMa_channels = FuMa_channels';
fuma2ambix_4_channel_1st_order_conversion_matrix = [1.414213562, 0, 0, ...
    0; 0, 0, 1, 0; 0, 0, 0, 1; 0, 1, 0, 0];
AmbiX_channels = fuma2ambix_4_channel_1st_order_conversion_matrix * FuMa_channels;

end

