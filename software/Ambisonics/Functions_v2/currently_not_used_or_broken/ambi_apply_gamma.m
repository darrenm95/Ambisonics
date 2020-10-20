function [M_hf, M_lf] = ambi_apply_gamma( M, Gamma, C )
 M_hf = M * diag(Gamma(C.sh_l+1));
    M_lf = M;
end