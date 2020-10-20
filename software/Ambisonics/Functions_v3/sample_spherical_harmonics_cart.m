function [ speakerEncodingMatrix ] = sample_spherical_harmonics_cart( ...
    Vx, Vy, Vz, ambixChannels_Structure)
%sample_spherical_harmonics_sph samples the spherical harmonics at Vxyz
%grid points by conversion to spherical harmonics and a call to
%sample_spherical_harmonics_sph
%
%  ambixChannels_Structure is structure containing channel information, either
%    SN3D or N3D normalisation can be set there


%%    
  [az, el] = cart2sph(Vx, Vy, Vz);

  speakerEncodingMatrix = sample_spherical_harmonics_sph(az, el, ...
      ambixChannels_Structure);

