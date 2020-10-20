function [ B_Format_Channels_Struc, sampling_frequency ] = ...
    read_B_format_file( ...
    B_format_file, encodingConvention, ambixChannels_Structure)
%read_B_format_file reads B-Format channels in to vector according to 
%ACN ordering rule
%   
%   'FuMa' encoding convention is converted to 'Ambix' if required and
%   error is returned for unknown encoding conventions


switch lower(encodingConvention)
    case {'fuma'}
        [b_format_channels, sampling_frequency] = fuma2ambix(B_format_file);
    
    case {'ambix'}
        [b_format_channels, sampling_frequency] = audioread(B_format_file);
        b_format_channels = b_format_channels';
    
    otherwise
        error('unknown B-Format encoding convention')
end

channel_mask = ambixChannels_Structure.channel_mask';
B_Format_Channels_Struc = ambixChannels_Structure;
B_Format_Channels_Struc.Fs = sampling_frequency;

B_Format_Channels_Struc.b_format_channels = ...
    b_format_channels(channel_mask, :);
end

