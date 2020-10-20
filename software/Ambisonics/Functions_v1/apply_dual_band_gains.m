function [decodingMatrix_hf, ...
    decodingMatrix_lf] = apply_dual_band_gains( basicSolutionMatrix, ...
    gains, ChannelStructure )
    %apply_dual_band_gains() LF and HF decoding matrices from basic 
    %solution and gains
    %
    %  basicSolutionMatrix is low-frequency (LF) decoding matrix
    %  gains is vector of per-degree gains
    %  ChannelStructure is structure that defines the ambisonic channels.
    
    decodingMatrix_lf = basicSolutionMatrix;
    decodingMatrix_hf = basicSolutionMatrix * ...
        diag(gains(ChannelStructure.sh_l+1));
    
end
