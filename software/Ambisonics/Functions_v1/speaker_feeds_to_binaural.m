function speaker_feeds_to_binaural(SpeakerArray, B_format_file)
%speaker_feeds_to_binaural converts speaker feed matrix in to binaural .wav


% convert speaker array anglular positions from radians to degrees
az_deg = rad2deg(SpeakerArray.az_rad);
el_deg = rad2deg(SpeakerArray.el_rad);

% read hrir signals 
[head_related_impulse_responses, HRIR_sampling_rate_array] = read_HRIR(az_deg, el_deg);

HRIR_sampling_rate = unique(HRIR_sampling_rate_array);
speaker_feed_sampling_rate = SpeakerArray.sampling_rate;

if ~isequal(speaker_feed_sampling_rate, HRIR_sampling_rate)
    left_ear_HR_impulse_responses = head_related_impulse_responses(:, :, 1);
    right_ear_HR_impulse_responses = head_related_impulse_responses(:, :, 2);
    
    head_related_impulse_responses = resample(left_ear_HR_impulse_responses, ... 
        speaker_feed_sampling_rate, HRIR_sampling_rate);
    

    head_related_impulse_responses(:, :, 2) = resample(right_ear_HR_impulse_responses, ...
        speaker_feed_sampling_rate, HRIR_sampling_rate);
end

number_of_HRIRs = size(head_related_impulse_responses, 2);
number_of_speaker_feeds = size(SpeakerArray.speaker_feeds, 1);
number_of_speaker_feed_samples = size(SpeakerArray.speaker_feeds, 2);

if ~isequal(number_of_HRIRs, number_of_speaker_feeds)
    error(['Number of head-related-impulse-responses should match number of', ...
        ' speaker feeds']);
end
% allocate memory for filtered speaker feeds
filtered_speaker_feeds = zeros(number_of_speaker_feeds, ... 
    number_of_speaker_feed_samples, 2);

% filter speaker feeds with head-related-impulse-responses
for i = 1 : number_of_speaker_feeds
    
    % left ear binaural signals
    filtered_speaker_feeds(i, :, 1) = ...
        filter(head_related_impulse_responses(:, i, 1), 1, ...
        SpeakerArray.speaker_feeds(i, :));
    
    % right ear binaural signals
        filtered_speaker_feeds(i, :, 2) = ...
        filter(head_related_impulse_responses(:, i, 2), 1, ...
        SpeakerArray.speaker_feeds(i, :));
   
end


left_ear_binaural_signal = sum(filtered_speaker_feeds(:, :, 1));
right_ear_binaural_signal = sum(filtered_speaker_feeds(:, :, 2));


binaural_signal = [left_ear_binaural_signal; right_ear_binaural_signal];
binaural_signal = binaural_signal';
[filepath, filename, ~] = fileparts(B_format_file);
audiowrite(sprintf('%s\\binaural_converted_recordings\\binaural_%s.wav', ...
    filepath, filename), binaural_signal, speaker_feed_sampling_rate, ...
    'BitsPerSample', 32); 

