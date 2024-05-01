function downsampled_image = downsample_image(image, downsample_factor)
    % Get the number of Z-sections in the image stack
    num_z = length(image);
    
    % Get the number of channels in the image stack
    num_channels = length(image{1});
    
    % Get the dimensions of the first channel in the first Z-section
    [height, width] = size(image{1}{1});
    
    % Calculate the new dimensions after downsampling
    new_height = floor(height / downsample_factor);
    new_width = floor(width / downsample_factor);
    
    % Initialize cell array to store the downsampled image stack
    downsampled_image = cell(size(image)); 
    
    for z = 1:num_z
        % Initialize cell array to store channels for the current Z-section
        downsampled_channels = cell(1, num_channels);
        
        for c = 1:num_channels
            % Downsample the current channel using averaging
            channel = image{z}{c};
            downsampled_channel = imresize(channel, [new_height, new_width], 'method', 'box');
            downsampled_channels{c} = downsampled_channel;
        end
        
        % Store the downsampled channels for the current Z-section
        downsampled_image{z} = downsampled_channels;
    end
end