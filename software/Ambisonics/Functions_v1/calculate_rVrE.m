function [ rV, rE, pressure, energy ] = calculate_rVrE( decodingMatrix, ...
    SpeakerArray_unit_vectors, test_directions )
%calculate_rVrE computes rV and rE from decoder matrix, speaker
%array, and test directions projected onto the spherical
%harmonic basis



    gains = decodingMatrix * test_directions;
    
    gains_squared = gains.*conj(gains);

    pressure = sum(gains, 1);
    
    rV.xyz = real((SpeakerArray_unit_vectors * gains)  ./ pressure([1 1 1], :));

    rV.r = sqrt( dot(rV.xyz, rV.xyz ));
    rV.u = rV.xyz ./ rV.r([1 1 1], :);

    energy = sum(gains_squared, 1);
    rE.xyz = (SpeakerArray_unit_vectors * gains_squared) ./ energy([1 1 1], :);

    rE.r = sqrt( dot(rE.xyz, rE.xyz) );
    rE.u = rE.xyz ./ rE.r([1 1 1], :);

end