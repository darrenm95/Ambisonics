function [ ambixChannelStructure ] = create_ambix_channel_structure( ambisonicOrder, ...
        orderingRule, channelNormalization )
%ambix_channel_definitions sets up channel definition structure
%
%  ambisonicOrder = 1 by default
%  orderingRule       = 'acn'|'ambix'
%  encodingConvention = 'sn3d'
%
%  l is used for degree and m for order.


    %% defaults
    if ~exist('ambisonicOrder', 'var') || isempty(ambisonicOrder)
        ambisonicOrder = 1;
    end
    
    if ~exist('orderingRule','var') || isempty(orderingRule)
            orderingRule = 'Ambix';
    end
    
    if ~exist('encodingConvention','var') || isempty(channelNormalization)
            channelNormalization = 'Ambix';
    end
    
    sphericalHarmonic.index = 0:((ambisonicOrder+1)^2-1);
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
                error('Unknown ordering_rule: %s', ordering_rule);
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
        
        %% Condon-Shortly Phase
        %    no ambisonic conventions use CS phase
        switch false
            case false
                cs_phase = ones(size(sphericalHarmonic.order));
            case true
                cs_phase = (-1)^abs(sphericalHarmonic.order);
        end
        
        %% set up struct amxixChannelSturcture for channels in use
        ambixChannelStructure.a_order = ambisonicOrder;
        ambixChannelStructure.sh_l = sphericalHarmonic.degree;
        ambixChannelStructure.sh_m = sphericalHarmonic.order;
        ambixChannelStructure.sh_cs_phase = cs_phase;
        ambixChannelStructure.norm = norm;
        ambixChannelStructure.ordering_rule = orderingRule;
        ambixChannelStructure.channel_normalization = channelNormalization;
        ambixChannelStructure.index = sphericalHarmonic.index;
    
end

%% conversion factors

function f = SN3D_to_N3D(alpha)
    f = sqrt(2*alpha + 1);
end


