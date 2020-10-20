function [SpeakerArray] = calculate_speaker_feeds( ...
    SpeakerArray, ChannelStructure, Decoder)
%calculate_speaker_feeds sends the LF and HF channels to their respective
%decoding matrix 
%
%   near-field compensated LF and HF channel sections are sent to their
%   respective LF and HF decoding matrix before differencing the outputs
%   to ensure that the HF filters phase matches that of the LF filter

lf_decoding_matrix = Decoder.D_lf;
hf_decoding_matrix = Decoder.D_hf;

lf_channel_signals = ChannelStructure.lf_nfc_channels;
hf_channel_signals = ChannelStructure.hf_nfc_channels;

lf_speaker_feeds = lf_decoding_matrix * lf_channel_signals;
hf_speaker_feeds = hf_decoding_matrix * hf_channel_signals;

speaker_feeds = lf_speaker_feeds - hf_speaker_feeds;

SpeakerArray.speaker_feeds = speaker_feeds;
end

