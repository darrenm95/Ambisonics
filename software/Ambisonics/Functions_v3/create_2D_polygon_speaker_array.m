function [ SpeakerArray ] = create_2D_polygon_speaker_array( ...
    number_of_speakers, speaker_array_radius, speaker_array_name, ...
    speaker_ids, start_angle_degrees )
    %create_2D_polygon_speaker_array creates horizontal polygon  speaker 
    %array structure
    
    
    
    %% defaults
    
    % radius in meters
    if ~exist('speaker_array_radius', 'var') || isempty(speaker_array_radius)
        speaker_array_radius = 5 / 3;
    end
    
    % start angle in degrees
    if ~exist('start_angle_degrees', 'var') || isempty(start_angle_degrees)
        start_angle_degrees = 0;
    end
    
    % speaker array name
    if ~exist('speaker_array_name', 'var') || isempty(speaker_array_name)
        SpeakerArray.name = sprintf('sa_%d_gon_%d', number_of_speakers, ...
            start_angle_degrees);
    else
        SpeakerArray.name = speaker_array_name;
    end
    
    % speaker ids
    if ~exist('speaker_ids', 'var') || isempty(speaker_ids)
        SpeakerArray.id = arrayfun(@(n) num2str(n,'S%02d'), 1:number_of_speakers,...
            'UniformOutput', false);
    else
        SpeakerArray.id = speaker_ids;
    end
    
    %%
    thetas_degrees = linspace(0, 360, number_of_speakers +1);
    thetas_degrees = thetas_degrees + start_angle_degrees;
    thetas_degrees = thetas_degrees(1:end-1);
    
    SpeakerArray.az_rad = thetas_degrees(:)*pi/180;
    SpeakerArray.el_rad = zeros(size(SpeakerArray.az_rad));
    
    % to unit vectors
    [SpeakerArray.x, SpeakerArray.y, SpeakerArray.z] = sph2cart( ...
        SpeakerArray.az_rad, SpeakerArray.el_rad, 1);
    % and back to spherical with az in range -pi to +pi
    [SpeakerArray.az_rad, SpeakerArray.el_rad, SpeakerArray.r] = cart2sph( ...
        speaker_array_radius*SpeakerArray.x, ...
        speaker_array_radius*SpeakerArray.y, ...
        speaker_array_radius*SpeakerArray.z);

end
