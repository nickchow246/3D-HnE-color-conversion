function s_image = subtract_background(g_image, background_level)
    % Get the number of z-slices in the stack
    num_slices = size(g_image, 1);
    
    % Get the number of channels
    num_channels = size(g_image{1, 1}, 2);
    
    % Initialize variables to store the sum of intensities for each channel
    sum_intensity = zeros(1, num_channels);
    total_pixels = zeros(1, num_channels);
    
    % Loop through each z-slice
    for i = 1:num_slices
        % Loop through each channel
        for j = 1:num_channels
            % Get the image data for the current channel
            img_data = g_image{i, 1}{1, j};
            
            % Update the sum of intensities and total number of pixels for the current channel
            sum_intensity(j) = sum_intensity(j) + sum(img_data(:));
            total_pixels(j) = total_pixels(j) + numel(img_data);
        end
    end
    
    % Calculate the mean intensity for each channel
    mean_intensity = sum_intensity ./ total_pixels;
    
    % Subtract the background value multiplied by the mean intensity from each z-slice and channel
    s_image = cell(size(g_image));
    for i = 1:num_slices
        for j = 1:num_channels
            img_data = g_image{i, 1}{1, j};
            s_image{i, 1}{1, j} = img_data - background_level * mean_intensity(j);
            s_image{i, 1}{1, j} = max(s_image{i, 1}{1, j}, 0);
        end
    end
end