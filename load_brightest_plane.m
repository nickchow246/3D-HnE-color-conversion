function brightest_plane = load_brightest_plane(image, interval)
    % Get the number of Z-sections in the image stack
    num_z = size(image, 1);
    
    % Initialize variables to store max combined intensity and its index
    max_combined_intensity = -Inf;
    max_index = 0;
    
    for z = 1:interval:num_z
        % Get the two-channel image for the current Z-section
        two_channel_image = image{z};
        
        % Extract the individual channels
        channel_E = double(two_channel_image{1});
        channel_S = double(two_channel_image{2});
        
        % Perform 4-time downsampling of each channel in both X and Y directions
        downsampled_E = imresize(channel_E, 0.25);
        downsampled_S = imresize(channel_S, 0.25);
        
        % Calculate the combined intensity by summing downsampled E and S channels
        combined_intensity = sum(downsampled_E(:)) + sum(downsampled_S(:));
        
        % Update max combined intensity and index if necessary
        if combined_intensity > max_combined_intensity
            max_combined_intensity = combined_intensity;
            max_index = z;
        end
    end
    
    % Load the plane with maximum combined intensity
    brightest_plane = image{max_index};
    
    % Perform 4-time downsampling of each channel in both X and Y directions
    brightest_plane{1} = imresize(brightest_plane{1}, 0.25);
    brightest_plane{2} = imresize(brightest_plane{2}, 0.25);
end