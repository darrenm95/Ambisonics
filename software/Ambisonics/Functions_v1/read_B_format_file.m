function [ ChannelStructure ] = read_B_format_file( B_format_file, ...
    encodingConvention, ChannelStructure)
%read_B_format_file reads B-Format channels in to vector according to 
%ACN ordering rule
%   
%   'FuMa' encoding convention is converted to 'Ambix' if required and
%   error is returned for unknown encoding conventions


switch lower(encodingConvention)
    case {'fuma'}
        [channels, samplingFrequency] = fuma2ambix(B_format_file);
    
    case {'ambix'}
        [channels, samplingFrequency] = audioread(B_format_file);
        channels = channels';
    
    otherwise
        error('unknown B-Format encoding convention')
end

ChannelStructure.channels = channels;
ChannelStructure.Fs = samplingFrequency;

end

