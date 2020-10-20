function [ speakerEncodingMatrix ] = sample_spherical_harmonics( SA_x, SA_y, ...
    SA_z, ChannelStructure )
    %sample_spherical_harmonics samples the spherical harmonics at az, el
    %grid points
    %
    %ChannelStructure is structure containing channel information, either
    %                 SN3D or N3D normalisation can be set there
    
    [az, el] = cart2sph(SA_x, SA_y, SA_z);
    
    az_size = size(az);
    el_size = size(el);
    
    if ~all(az_size(:) == el_size(:))
        error('az and el arrays must be the same size')
    end
    
    az = az(:);
    z = sin(el(:));
    
    speakerEncodingMatrix = zeros(length(az),length(ChannelStructure.sh_l));
    
    for i = 1:length(ChannelStructure.sh_l)
        degree = ChannelStructure.sh_l(i);
        order  = ChannelStructure.sh_m(i);

        norm   = ChannelStructure.norm(i);
        cs_phase = ChannelStructure.sh_cs_phase(i);
        
        % Legendre 'sch' and 'norm' do not include C-S phase
        % (but unnormalized does)
        L = legendre(degree,z,'sch');
        
        if order >= 0
            speakerEncodingMatrix(:,i) =  cs_phase * norm ...
                .* L(order+1,:)' .* cos(order*az);
        else
            order = -order;
            speakerEncodingMatrix(:,i) =  cs_phase * norm ...
                .* L(order+1,:)' .* sin(order*az);
        end
    end
end
