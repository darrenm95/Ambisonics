function [ channel_mask, scheme ] = mixed_order_channels( ...
    sphericalHarmonic, h_order, v_order, scheme)
    %mixed_order_channels() returns channel mask for mixed order schemes
    %
    % [ channel_mask, scheme ] = mixed_order_channels(sphericalHarmonic,
    % h_order, v_order, scheme) creates the channel mask for the horizontal
    % and vertical order according to the specified mixed-order scheme.
    
 
    
    %% defaults
    if ~exist('v_order','var') || isempty(v_order)
        v_order = 0; 
    end 
    
    if ~exist('scheme','var') || isempty(scheme)
        scheme = 'AMB'; 
    end
    
    %%
    switch upper(scheme)
        case {'HP', 'AMB'}
            % used in AMB files, h and v orders independant
            %  this is what .AMB files use
            sh_zonal_p    = sphericalHarmonic.order == 0;
            sh_tesseral_p = sphericalHarmonic.degree == ... 
                abs(sphericalHarmonic.order);
            sh_sectoral_p = ~sh_zonal_p & ~sh_tesseral_p;

            channel_mask = ...
               (  sh_tesseral_p & (sphericalHarmonic.degree <= h_order) ) | ...
               ( ~sh_tesseral_p & (sphericalHarmonic.degree <= v_order) );

           scheme = 'HP';
            
        case {'HV', 'TRAVIS'}
            % Travis HV scheme, see [1]
            channel_mask = sphericalHarmonic.degree - ...
                abs(sphericalHarmonic.order) <= v_order & ...
                (sphericalHarmonic.degree<=max(h_order, v_order));
            
            scheme = 'HV';
            
        otherwise
            error('unknown mixed-order scheme: "%s" ', scheme);
    end
end

