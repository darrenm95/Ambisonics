function [ ambixChannelStructure ] = create_ambix_channel_structure( ...
    h_order, v_order, mixed_order_scheme, orderingRule, ...
    channelNormalization )
%create_ambix_channel_structure sets up ambix convention channel structure
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
        ambixChannelStructure.h_order = h_order;
        ambixChannelStructure.v_order = v_order;
        ambixChannelStructure.scheme = scheme;
        ambixChannelStructure.sh_l = sphericalHarmonic.degree;
        ambixChannelStructure.sh_m = sphericalHarmonic.order;
        ambixChannelStructure.sh_cs_phase = cs_phase;
        ambixChannelStructure.norm = norm;
        ambixChannelStructure.ordering_rule = orderingRule;
        ambixChannelStructure.channel_normalization = channelNormalization;
        ambixChannelStructure.index = sphericalHarmonic.index;
        
        ambixChannelStructure.names = channel_names(sphericalHarmonic);
        ambixChannelStructure.channels = find(channel_mask);
        ambixChannelStructure.channel_mask = channel_mask;
    
end

%% conversion factors

function f = SN3D_to_N3D(alpha)
    f = sqrt(2*alpha + 1);
end


