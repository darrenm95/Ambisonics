function [gains, g0, type] = dual_band_gains( ambixChannelStructure, ...
    SpeakerArray, type )
    %dual_band_gains  computes dual-band gains for decoding matrix of 
    %type max_rE
    %
    %   Gains used to alter velocity-to-pressure ratio to maximise energy
    %   vector rE for high-frequencies. Gains must be distributed in 
    %   such a way as to maintain loudness when moving from low-frequencies
    %   to high frequencies.
    %
    %   ambixChannelStructure is channel definition struct
    %   SpeakerArray is speaker array definition struct
    %   type is one of:
    %      'energy' for 'conservation of total energy'
    %      'amp' for 'preservation of amplitude'
    %      'rms' for 'preservation of root-mean-square'

    %% defaults
    
    if ~exist('type','var') || isempty(type)
        type = 'energy';
    end
    %%

    chebyPoly = @(n)ChebyshevPoly(n);
    
    M = max(ambixChannelStructure.h_order, ambixChannelStructure.v_order);
    m = 0:M;
    
    max_rE = max(roots(chebyPoly(M+1)));
    gains_max_rE = arrayfun(@(n)polyval(chebyPoly(n),max_rE), m);
    
    channel_gains = gains_max_rE(ambixChannelStructure.sh_l+1);
    E_max_rE = channel_gains * channel_gains';
    
    switch lower(type)
        case {'energy', 1}
            N = length(SpeakerArray.x);
            g0_max_rE = sqrt( N / E_max_rE );
        case {'rms', 2}
            N = length(ambixChannelStructure.channels);
            g0_max_rE = sqrt( N / E_max_rE );
        case {'amp', 3}
            g0_max_rE = 1;
        otherwise
            disp(type);
            error('type should be 1, 2, 3, ''energy'', ''rms'', or ''amp''');
    end
    
    gains = gains_max_rE * g0_max_rE;
    
    if nargout > 1
        g0 = g0_max_rE;
    end
    
end
