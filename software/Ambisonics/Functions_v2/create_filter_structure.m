function [Filters] = create_filter_structure( ...
crossover_frequency, sampling_frequency, source_distance)
%create_filter_structure calculates the numerator (b) and denominator (a)
%coefficients of the rational transfer function for each filter and 
%assigns them to a filter structure
%
%  Filters:
%          - crossover network filters include a 2nd order low-pass and
%            high-pass filter
%          - finite distance of the speakers to the listener at the centre
%            of reproduction system is compensated with a near-field 
%            correction filter
%          - finite distance of a synthetic source to virtual microphone
%            is corrected with a finite source-distance filter
%
%  crossover_frequency and sampling_frequnecy are used to calculate the 
%  pre-warped constant (k) used to move from the s-domain (analog) to the 
%  z-domain (digital)
%
%  source_distance is used to provide a finite source distance correction
%  upon encoding synthetic sources

speed_of_sound = 343; %metres per second

k = tan(2*pi * crossover_frequency / sampling_frequency);

T = source_distance / speed_of_sound;

% calculate_crossover_filter_coefficients
[Filters.b_lowpass_crossover, Filters.b_highpass_crossover, ...
    Filters.a_crossover] = write_crossover_network_filters(k);

% near-field correction coefficients
[Filters.b_nfc, Filters.a_nfc] = write_nfc_filter(k);

% finite source-distance filter
[Filters.b_finite_source_distance, Filters.a_finite_source_distance] = ...
    write_finite_source_distance_filter(k, T);

Filters.crossover_frequency = crossover_frequency;
Filters.sampling_frequency = sampling_frequency;
Filters.source_distance = source_distance;

end

