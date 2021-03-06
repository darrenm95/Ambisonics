function [ ambixChannels_Structure ] = create_ambix_channels_structure( ...
    h_order, v_order, mixed_order_scheme, orderingRule, ...
    channelNormalization )
%create_ambix_channels_structure sets up ambix encoded channels structure
%
%  h_order is horizontal order (highest zonal degree in use)
%  v_order is vertical order (highest tesseral degree in use)
%  mixed_order_scheme controls which sectoral harmonics are
%    included in mixed-order
%  orderingRule       = 'acn'|'ambix'
%  encodingConvention = 'sn3d'
%
%  l is used for degree and m for order.


    %% defaults
    if ~exist('h_order', 'var') || isempty(h_order)
        h_order = 1;
    end
    
    if ~exist('v_order', 'var') || isempty(v_order)
        v_order = 0;
    end
    
    if ~exist('mixed_order_scheme', 'var') || isempty(mixed_order_scheme)
        mixed_order_scheme = 'HV';
    end
    
    if ~exist('orderingRule','var') || isempty(orderingRule)
            orderingRule = 'AmbiX';
    end
    
    if ~exist('channelNormalization','var') || isempty(channelNormalization)
            channelNormalization = 'AmbiX';
    end
    
    max_order = max(h_order, v_order);
    
    sphericalHarmonic.index = 0:((max_order+1)^2-1);
    sphericalHarmonic.degree = zeros(size(sphericalHarmonic.index));
    sphericalHarmonic.order = zeros(size(sphericalHarmonic.index));
    
    orderingRule = lower(orderingRule);
    channelNormalization = upper(channelNormalization);
        
        %% fill in channel index, degree, order
        switch lower(orderingRule)
            
            case {'acn', 'ambix'}
                orderingRule = 'acn';
                sphericalHarmonic.degree = floor(sqrt(sphericalHarmonic.index));
                sphericalHarmonic.order = sphericalHarmonic.index ...
                    - sphericalHarmonic.degree.^2 - sphericalHarmonic.degree;
                
            otherwise
                error('Unknown ordering_rule: %s', orderingRule);
        end
        
        %% fill in normalization
        switch upper(channelNormalization)
            case {'SN3D', 'AMBIX', 'AMBIX2011'}
                % SN3d is native normalization for this program
                norm = ones(size(sphericalHarmonic.degree)); 
                channelNormalization = 'SN3D';
                
            case {'N3D', 'AMBIX2009'}
                % conversion factor for SN3D to N3D normalization
                norm = SN3D_to_N3D(sphericalHarmonics.degree);
                channelNormalization = 'N3D';
        end
        
         %% mixed order calculation
        [channel_mask, scheme] = mixed_order_channels(sphericalHarmonic, ...
            h_order, v_order, mixed_order_scheme);

        sphericalHarmonic.degree = sphericalHarmonic.degree(channel_mask);
        sphericalHarmonic.order = sphericalHarmonic.order(channel_mask);
        
        
        %% Condon-Shortly Phase
        %    no ambisonic conventions use CS phase
        switch false
            case false
                cs_phase = ones(size(sphericalHarmonic.order));
            case true
                cs_phase = (-1)^abs(sphericalHarmonic.order);
        end
        
        %% set up struct amxixChannelSturcture for channels in use
        ambixChannels_Structure.h_order = h_order;
        ambixChannels_Structure.v_order = v_order;
        ambixChannels_Structure.scheme = scheme;
        ambixChannels_Structure.sh_l = sphericalHarmonic.degree;
        ambixChannels_Structure.sh_m = sphericalHarmonic.order;
        ambixChannels_Structure.sh_cs_phase = cs_phase;
        ambixChannels_Structure.norm = norm;
        ambixChannels_Structure.ordering_rule = orderingRule;
        ambixChannels_Structure.channel_normalization = channelNormalization;
        ambixChannels_Structure.index = sphericalHarmonic.index;
        
        ambixChannels_Structure.names = channel_names(sphericalHarmonic);
        ambixChannels_Structure.channels = find(channel_mask);
        ambixChannels_Structure.channel_mask = channel_mask;
    
end

%% conversion factors

function f = SN3D_to_N3D(alpha)
    f = sqrt(2*alpha + 1);
end


