function mycolorbar = get_colorbar(color_bar, width, height)
    color_bar = 'jet';
    height = 500;
    width = 50;

    twidth = width;
    colors = feval(color_bar, height);
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
    imshow(mycolorbar)
end