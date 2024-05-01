function display_image(image, z_index)
    % Create a figure with subplots
    figure;
    
    for i = 1:length(z_index)
        % Get the two-channel image for the selected Z plane
        twoChannelImage = image{z_index(i)};
        
        % Convert the selected image to RGB
        rgbImage = convert_RGB_single(twoChannelImage);
        
        % Display the RGB image in a subplot
        subplot(1, length(z_index), i);
        imshow(rgbImage);
        title(sprintf('Z Plane %d', z_index(i)));
    end
end

function rgbImage = convert_RGB_single(twoChannelImage)
    % Extract the individual channels
    E = double(twoChannelImage{1});
    S = double(twoChannelImage{2});
    
    % Divide E and S channels by 255
    E = E / 255;
    S = S / 255;
    
    % Apply the conversion formula using vectorization
    R = 10.^(-0.644 * S - 0.093 * E);
    G = 10.^(-0.717 * S - 0.954 * E);
    B = 10.^(-0.267 * S - 0.283 * E);
    
    % Create the RGB image
    rgbImage = cat(3, R, G, B);
end