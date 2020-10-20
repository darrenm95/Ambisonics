function [ SpeakerArray, speaker_feeds ] = calculate_speaker_feeds( ...
    SpeakerArray, B_Format_Channels_Struc, Decoder)
%calculate_speaker_feeds sends the LF and HF channels to their respective
%decoding matrix 
%
%   near-field compensated LF and HF channel sections are sent to their
%   respective LF and HF decoding matrix before differencing the outputs
%   to ensure that the HF filters phase matches that of the LF filter


lf_speaker_feeds = Decoder.D_lf * ...
    B_Format_Channels_Struc.b_format_channels_nfc_lf;

hf_speaker_feeds = Decoder.D_hf * ...
    B_Format_Channels_Struc.b_format_channels_nfc_hf;

speaker_feeds = lf_speaker_feeds - hf_speaker_feeds;

SpeakerArray.speaker_feeds = speaker_feeds;
end

