function [b_nfc, a_nfc] = write_nfc_filter(k)
%write_nfc_filter calculates the coefficients needed to apply the
%near-field correction filter
%
%   Detailed explanation goes here

b0 = 1 / (k + 1);
b1 = -b0;

a0 = 1;
a1 = (k - 1) / b0;

b_nfc = [b0, b1];
a_nfc = [a0, a1];

end

