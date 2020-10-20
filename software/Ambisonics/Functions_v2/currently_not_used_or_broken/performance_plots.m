function [gca1e, gca2] = performance_plots( S, D, C, fig_title)
    %performance_plots() produces plots of rE and rV vs stimulus direction
    %   S is real speaker array structure
    %   D is decoder matrix
    %   C is the channel structure

   
    %% defaults
    if ~exist('fig_title', 'var') || isempty(fig_title)
        fig_title = strrep(S.name,'_',' ');
    end

    fig_title_sanitized = strrep(fig_title, '_', ' ');
    
    %% grid
    geo_grid = AzElGrid(-180:4:180-4, ele_min:4:ele_max);
 
    %%  compute rE and rV
    geo_grid.a = sample_spherical_harmonics_sph(geo_grid.az(:), ...
        geo_grid.el(:), C)';
    
    [rV_hf, rE_hf, P_hf, E_hf] = calculate_rVrE(D.D_hf, [S.x, S.y, S.z]', ...
        geo_grid.a);
    
    [rV_lf, rE_lf, P_lf, E_hf] = calculate_rVrE(D.D_lf, [S.x, S.y, S.z]', ...
        geo_grid.a);
    
    %% rV rE direction difference plot
    if true
        gca_direction_difference = figure('visible', 'on'));
        set(gca_direction_difference,'numbertitle','on','name', ...
            'rV rE Direction Difference');
        
        sp121 = subplot(1, 2, 1);
        imagesc( geo_grid.az(1,:)*180/pi, geo_grid.el(:,1)*180/pi,...
            reshape(calculate_direction_difference(rV_hf.u,rE_hf.u) .* 180/pi, ...
            size(geo_grid.x)));
        axis('xy');
        xlabel('right<--- azimuth (deg) --->left');
        ylabel('elevation (deg)');
        caxis([0,10]);
        figtitle(sprintf('%s\nrV rE Direction Difference (high frequencies)', ...
            fig_title_sanitized));
        colorbar
        
        sp122 = subplot(1, 2, 2);
        imagesc( geo_grid.az(1,:)*180/pi, geo_grid.el(:,1)*180/pi,...
            reshape(calculate_direction_difference(rV_lf.u,rE_lf.u) .* 180/pi, ...
            size(geo_grid.x)));
        axis('xy');
        xlabel('right<--- azimuth (deg) --->left');
        ylabel('elevation (deg)');
        caxis([0,10]);
        figtitle(sprintf('%s\nrV rE Direction Difference (low frequencies)', ...
            fig_title_sanitized));
        colorbar

    end
    
    %% magnitude vs direction
     if true
        
        gca_magnitude_vs_direction = figure('visible', 'on');
        
        title(fig_title_sanitized, ...
            'fontsize', 16, 'fontweight', 'bold');
        
        set(gca_magnitude_vs_direction,'units','normalized','outerposition',[0 0 1 1]);
        set(gca_magnitude_vs_direction,'numbertitle','on','name',fig_title);
        set(gca_magnitude_vs_direction, 'PaperPositionMode', 'auto');
       
        
        rV_hf.xx = reshape(rV_hf.xyz(1,:), size(geo_grid.x));
        rV_hf.yy = reshape(rV_hf.xyz(2,:), size(geo_grid.y));
        rV_hf.zz = reshape(rV_hf.xyz(3,:), size(geo_grid.z));
        rV_hf.rr  = reshape(rV_hf.r, size(geo_grid.x));

        rE_hf.xx = reshape(rE_hf.xyz(1,:), size(geo_grid.x));
        rE_hf.yy = reshape(rE_hf.xyz(2,:), size(geo_grid.y));
        rE_hf.zz = reshape(rE_hf.xyz(3,:), size(geo_grid.z));
        rE_hf.rr  = reshape(rE_hf.r, size(geo_grid.x));
        
        rV_lf.xx = reshape(rV_lf.xyz(1,:), size(geo_grid.x));
        rV_lf.yy = reshape(rV_lf.xyz(2,:), size(geo_grid.y));
        rV_lf.zz = reshape(rV_lf.xyz(3,:), size(geo_grid.z));
        rV_lf.rr  = reshape(rV_lf.r, size(geo_grid.x));
        
        rE_lf.xx = reshape(rE_lf.xyz(1,:), size(geo_grid.x));
        rE_lf.yy = reshape(rE_lf.xyz(2,:), size(geo_grid.y));
        rE_lf.zz = reshape(rE_lf.xyz(3,:), size(geo_grid.z));
        rE_lf.rr  = reshape(rE_lf.r, size(geo_grid.x));
        
        

        if all(all(rV_hf.zz)) == 0 && all(all(rV_hf.zz))
            [rV_hf_directions, rV_hf_magnitude] = cart2pol(rV.xx
  