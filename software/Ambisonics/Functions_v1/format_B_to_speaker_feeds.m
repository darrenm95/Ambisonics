function [SpeakerArray, ambixChannelStructure, Decoder] = ... 
    format_B_to_speaker_feeds(B_format_file, encodingConvention, binaural)
%format_B_to_speaker_feeds takes B-Format audio file of encoding convention
%FuMa or AmbiX and outputs speaker feeds
%
%binaural is boolean that returns binaural .wav file of decoded B-Format

   
number_of_speakers = 8; % need check for allowed number of speakers, remember, have to be equal distance apart
speaker_array_radius = 2;
speaker_array_name = 'Octagon_2m_radius_start_angle_0_degrees';
speaker_ids = [];
start_angle_degrees = 0;
do_plots = true;  % take default

% create speaker array
SpeakerArray  = create_2D_polygon_speaker_array( ...
    number_of_speakers, speaker_array_radius, speaker_array_name, ...
    speaker_ids, start_angle_degrees );

% set up ambix channel structure
ambixChannelStructure  = create_ambix_channel_structure();

% read ambisonics B-Format file
ambixChannelStructure = read_B_format_file(B_format_file, ...
    encodingConvention, ambixChannelStructure);

% create decoder
[Decoder, SpeakerArray, ...
ambixChannelStructure] = create_decoder_using_pseudoinverse(SpeakerArray, ...
    ambixChannelStructure, do_plots);

% apply filters
crossover_frequency_hz = 380; %hz
sampling_frequency_hz = ambixChannelStructure.Fs;
k = tan(pi*crossover_frequency_hz / sampling_frequency_hz);

% apply near-field compensation
ambixChannelStructure = apply_nfc_filter(ambixChannelStructure, k);

% apply crossover network filters
ambixChannelStructure = implement_crossover_network(ambixChannelStructure, ...
    k);

% calculate speaker feeds
SpeakerArray.sampling_rate = sampling_frequency_hz;
SpeakerArray = calculate_speaker_feeds(SpeakerArray, ambixChannelStructure, ...
    Decoder);

if binaural
    speaker_feeds_to_binaural(SpeakerArray, B_format_file);
end

   


