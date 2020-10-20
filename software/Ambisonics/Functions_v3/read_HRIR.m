function [HRIR_signals, sampling_frequency] = read_HRIR(az_deg, el_deg)
%read_HRIR  reads HRIR related to HRTF from kemar database
%   Usage:  HRIR_signals = read_HRIR(azimuth_angle_degrees, ... 
%                                    elevation_angle_degrees);
%  
%   Input parameters:
%
%     azim : (-360 -> +360) azimuth of source with respect to head in degrees
%
%     elev : (-90 -> +90) elevation of source with respect to head in degrees
%            Both databases have a range of elevations, but more limited in 
%            the Oldenburg case.
%
%   Output parameters:
%     hrir : the requested head-related-impulse-response
%36
%   read_HRIR(az_deg, el_deg) retrieves the HRIR closest to the
%   specified azimuth and elevation from the MIT Kemar (Gardner and Martin,
%   1995).


  % root directory
  root = ['C:\Users\Darren Moore\The University of Nottingham\', ...
      'O365-MRCprogramme-MR-S002898-1 - 98_Darren_temp\', ...
      'head_related_impulse_responses'];

  number_of_elements = numel(el_deg);
 
    HRIR_signals = zeros(512,number_of_elements,2);
    sampling_frequency = zeros(2, number_of_elements);
    for i=1:number_of_elements
      azim = az_deg(i);
      elev = el_deg(i);
      
      % fix out of range cases
      if azim < 0
        azim = 360 + azim;
      elseif azim >= 360 
        azim = azim-360;
      end
      
      % prefix zeros for KEMAR databases
      if azim < 10           
        azim_str = sprintf('00%d',azim);
      elseif azim < 100
        azim_str = sprintf('0%d',azim);  
      else
        azim_str = sprintf('%d',azim);
      end  

      [HRIR_signals(:,i,1), sampling_frequency(1,i)] = ...
          audioread(sprintf('%s\\elev%d\\L%de%sa.wav',root,elev,elev,azim_str));


      [HRIR_signals(:,i,2), sampling_frequency(2,i)] = ...
          audioread(sprintf('%s\\elev%d\\R%de%sa.wav',root,elev,elev,azim_str));
    end
  end
