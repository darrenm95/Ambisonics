function [Decoder, SpeakerArray, ...
    ChannelStructure] = create_decoder_using_pseudoinverse( SpeakerArray, ...
    ChannelStructure, do_plots) 
    %create_decoder_using_pseudoinverse() ambisonic decoder using 
    %pseudoinverse (aka mode matching).
    %
    %  top-level function to design a decoder using inversion 
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
    
    if ~exist('ChannelStructure','var') || isempty(ChannelStructure)
        ChannelStructure = create_ambix_channel_structure( 1, ...
        'acn', 'SN3D' );
    end
    
    if ~exist('do_plots','var') || isempty(do_plots)
        do_plots = true;
    end
    
    %% build up description and filename in 'name'
    name = SpeakerArray.name;
    
    %% shelf filter gains
    % per-order gains for max_rE decoder
    gains = dual_band_gains(ChannelStructure, SpeakerArray, ...
        'energy');   % 'amp','rms'
    gains_type = 'max_rE';

    %% conventional mode matching
    speakerEncodingMatrix = sample_spherical_harmonics(SpeakerArray.x, ...
        SpeakerArray.y, SpeakerArray.z, ChannelStructure);
    
   % straight up mode matching
    basicSolutionMatrix = pinv(speakerEncodingMatrix)'; %(aka. low frequency decoding matrix)

    name = [name, '_pinv_match_rV_', gains_type];

   % LF and HF decoding matrices from basic solution and gains
   [decodingMatrix_hf, ...
       decodingMatrix_lf] = apply_dual_band_gains(basicSolutionMatrix, ...
       gains, ChannelStructure);
   
   %% set up decoder struct
   Decoder.name = name;
   Decoder.D_hf = decodingMatrix_hf;
   Decoder.D_lf = decodingMatrix_lf;
   
   %% do plots %%Fix Me

   %calc rVrE
   
   %     if do_plots
   %         plot_rVrE(SpeakerArray, rVrE, decodingMatrix_lf, decodingMatrix_hf, ChannelStructure, name);
   %     else
   %         save_rVrE_plot_data(SpeakerArray, rVrE, decodingMatrix_lf, decodingMatrix_hf, ChannelStructure, name);
   %     end
   
end
