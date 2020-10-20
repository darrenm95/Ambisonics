function [ Decoder, SpeakerArray ] = create_decoder_using_pseudoinverse( ...
    SpeakerArray, ambixChannels_Structure, do_plots ) 
    %create_decoder_using_pseudoinverse() creates ambisonic decoder using 
    %pseudoinverse (aka mode matching).
    %
    %  top-level function to design a decoder using singular-value
    %  decomposition (SVD) and pseudoinverse
    %
    %  SpeakerArray is speaker array structure
    %  ChannelStructure is structure containing channel information 
    %  do_plots is a boolen that controls the performance plots, default is
    %     to produce plots

    %% fill in defaults
    if ~exist('SpeakerArray','var')
        SpeakerArray = create_2D_polygon_speaker_array(8, 2, ...
            'Octagon_2m_radius_start_angle_0_degrees', [], 0);
    end
    
    if ~exist('ambixChannels_Structure','var') || isempty(ambixChannels_Structure)
        ambixChannels_Structure = create_ambix_channels_structure( 1, ...
        0, 'HP', 'acn', 'SN3D' );
    end
    
    if ~exist('do_plots','var') || isempty(do_plots)
        do_plots = true;
    end
    
    %% build up description and filename in 'name'
    name = SpeakerArray.name;
    
    %% shelf filter gains
    % per-order gains for max_rE decoder
    gains = dual_band_gains(ambixChannels_Structure, SpeakerArray, ...
        'energy');   % 'amp','rms'
    gains_type = 'max_rE';

    %% mode matching
    encodingMatrix = sample_spherical_harmonics_cart(SpeakerArray.x, ...
        SpeakerArray.y, SpeakerArray.z, ambixChannels_Structure);
  
   % mode matching using singular-value decomposition
    [encodingMatrix_U, encodingMatrix_S, encodingMatrix_V] = ...
        svd(encodingMatrix); 
    
    pinv_encodingMatrix_S = pinv(encodingMatrix_S);

    exact_solution_decoder_matrix = (encodingMatrix_V * ...
        pinv_encodingMatrix_S * encodingMatrix_U')';
    
    name = [name, '_pinv_match_rV_', gains_type];

   % LF and HF decoding matrices from exact solution and gains
   [decodingMatrix_hf, ...
       decodingMatrix_lf] = apply_dual_band_gains( ...
       exact_solution_decoder_matrix, gains, ambixChannels_Structure);
   
   %% set up decoder structure
   Decoder.name = name;
   Decoder.D_hf = decodingMatrix_hf;
   Decoder.D_lf = decodingMatrix_lf;
   Decoder.encodingMatrix = encodingMatrix;
   
   %% do plots 

   %calc rVrE
   
   %     if do_plots
   %         plot_rVrE(SpeakerArray, rVrE, decodingMatrix_lf, decodingMatrix_hf, ambixChannelStructure, name);
   %     else
   %         save_rVrE_plot_data(SpeakerArray, rVrE, decodingMatrix_lf, decodingMatrix_hf, ChannelStructure, name);
   %     end
   
end
