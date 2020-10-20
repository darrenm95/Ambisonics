function [b_fsd, a_fsd] = ...
    write_finite_source_distance_filter(k, T)
%write_finite_source_distance_filter calculates the coefficients needed to
%apply correction for the finite distance of synthetically encoded sources
%   Detailed explanation goes here

b0 = T / (k + T);
b1 = -b0;

a0 = 1;
a1 = (k - T) / (k + T);

b_fsd = [b0, b1];
a_fsd = [a0, a1];

end

