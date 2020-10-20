function [ geo_grid ] = AzElGrid( az_range, el_range )
%AzElGrid( az_range, el_range ) produces a grid with uniform latitude and
%longitude sampling
%   az_range and el_range are in degrees
%   output structure is grid with fields az, el, x, y, z, w

%{
This file is part of the Ambisonic Decoder Toolbox (ADT).
Copyright (C) 2013 Aaron J. Heller

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
%}

% Author: Aaron J. Heller <heller@ai.sri.com>
% $Id$

%% defaults
    if nargin < 2
        az_range = -180:4:180-4;
        el_range =  -88:4:88;
    end

    %%
    geo_grid.az_range = az_range*pi/180;
    geo_grid.el_range = el_range*pi/180;

    [geo_grid.az, geo_grid.el] = meshgrid(geo_grid.az_range, geo_grid.el_range);

    [geo_grid.x, geo_grid.y, geo_grid.z] = ...
        sph2cart(geo_grid.az, geo_grid.el, 1);

    geo_grid.w = cos(geo_grid.el);

end
