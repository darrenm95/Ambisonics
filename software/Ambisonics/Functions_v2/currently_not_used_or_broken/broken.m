function [gca1e, gca2] = performance_plots( S, D, ChannelStructure, fig_title, ...
    number_of_src_directions)
    %performance_plots() produces plots of rE and rV vs stimulus direction
    %   S is real speaker array structure
    %   D is decoder matrix
    %   C is the channel structure
    
    %% defaults
    if ~exist('number_of_src_directions', 'var') || isempty(number_of_source_directions)
        number_of_src_directions = 360;
    end
    
    %% test signal
    unit_impulse = [1, zeros(2^16 - 1)];
    test_signal = repmat(unit_impulse, 1, number_of_src_directions);
    
    %% encoding matrix
    thetas = linspace(0, 360, number_of_src_directions + 1);
    thetas = thetas(1:end-1);
    
    az = thetas;
    el = zeros(1, length(thetas));
    
    encoding_matrix = sample_spherical_harmonics_sph(az, el, ...
        ChannelStructure);
    
    b_format_signals = repelem(encoding_matrix', 1, number_of_src_directions) .* test_signal;
    
    %% compensate for finite source distance
    crossover_frequency_hz = 380; %hz
    sampling_frequency_hz = ChannelStructure.Fs;
    k = tan(pi*crossover_frequency_hz / sampling_frequency_hz);

    source_distance = 5/3;
    speed_of_sound = 343; %metres per second
    
    T = source_distance/speed_of_sound;
    
    a0 = 1;
    a1 = (k - T)/(k + T);
    
    b0 = T/(k + T);
    b1 = -b0;
    
    a = [a0, a1];
    b = [b0, b1];
    
    for i = 2 : size(b_format_signals, 1) 
        b_format_signals(i, :) = filter(b, a, b_format_signals(i,:));
    end
    
    %% apply nfc filter and implement crossover network
    ChannelStrucutre = apply_nfc_filter(ChannelStructure, K);

    ChannelStructure = implement_crossover_network( ChannelStructure, K);
    
    %% calculate speaker feeds
    SpeakerArray = calculate_speaker_feeds(SpeakerArray, ChannelStructure, ...
        Decoder)
    
    %% create impulse response speaker feed array
    
end

