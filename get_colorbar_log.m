function [mycolorbar, colors_full] = get_colorbar_log(color_bar, width, height, max_ppl)
%     color_bar = 'jet';
%     height = 1000;
%     width = 50;
%     max_ppl = 9;

    max_ppl = max_ppl + 1;
    step = (max_ppl-1)/(height-1);
    a = 1:step:max_ppl;
    b = log(a);
    c = round(b*100000)+1;
    
    twidth = width;
    colors_full = feval(color_bar, max(c));
    colors = colors_full(c, :);
    if range(colors) <= 1
        colors = 255*colors;
    end
    
    colors = flipud(reshape(colors, height, 1, 3));
    mycolorbar = [uint8(repmat(colors, 1, width, 1)) ];
    
    text_region = uint8(255*(ones(height, twidth, 3)));
    step = round(height/9);
    for i=1:10
        text_region = insertText(text_region, [1 height-((i-1)*step)+round(0.4*width)], num2str(i-1), 'FontSize', round(0.8*width), 'AnchorPoint','LeftBottom', 'BoxOpacity', 0, 'TextColor', 'black');
    end
    
    mycolorbar = [mycolorbar text_region];
%     imshow(mycolorbar)
end