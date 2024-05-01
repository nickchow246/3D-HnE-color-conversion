function blurred_image = gaussian_blur_3d(image, sigma_xy, sigma_z)
    % Get the number of Z-sections in the image stack
    num_z = length(image);
    
    % Get the number of channels in the image stack
    num_channels = length(image{1});
    
    % Initialize cell array to store the blurred image stack
    blurred_image = cell(num_z, 1);
    
    for c = 1:num_channels
        % Extract the current channel from all Z-sections
        channel_stack = zeros(size(image{1}{1}, 1), size(image{1}{1}, 2), num_z);
        for z = 1:num_z
            channel_stack(:, :, z) = image{z}{c};
        end
        
        % Perform 3D Gaussian blur using imgaussfilt3
        blurred_channel_stack = imgaussfilt3(channel_stack, [sigma_xy, sigma_xy, sigma_z]);
        
        % Store the blurred channel stack back into the blurred_image cell array
        for z = 1:num_z
            if c == 1
                blurred_image{z} = cell(1, num_channels);
            end
            blurred_image{z}{c} = blurred_channel_stack(:, :, z);
        end
    end
end