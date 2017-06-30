function [out_color, mycolorbar] = get_colors(color_bar, vec, width, height, max_ppl)

    [mycolorbar, colors_full] = get_colorbar_log(color_bar, width, height, max_ppl);
    
    log_vec = log(vec+1);
    idx = round(log_vec*100000)+1;
    out_color = colors_full(idx, :);
    
end