function save_tiff(image, chunk_size, filepath)
    % Get the number of Z-sections in the stack
    numZ = size(image, 1);
    
    % Initialize the start index and file counter
    start_index = 1;
    file_counter = 1;
    
    while start_index <= numZ
        % Create a new TIFF file for each chunk of XY images
        end_index = min(start_index + chunk_size - 1, numZ);
        chunk_image = image(start_index:end_index);
        RGB_chunk = convert_RGB(chunk_image);
        
        % Generate the file path for the current chunk
        [filepath_prefix, filepath_ext] = split_path(filepath);
        chunk_filepath = sprintf('%s_%d%s', filepath_prefix, file_counter, filepath_ext);
        
        for i = 1:length(RGB_chunk)
            rgbImage = RGB_chunk{i};
            
            if ~isa(rgbImage, 'uint8')
                rgbImage = im2uint8(rgbImage);
            end
            
            if i == 1
                imwrite(rgbImage, chunk_filepath);
            else
                imwrite(rgbImage, chunk_filepath, 'WriteMode', 'append');
            end
        end
        
        start_index = end_index + 1;
        file_counter = file_counter + 1;
    end
end

function [filepath_prefix, filepath_ext] = split_path(filepath)
    [~, ~, filepath_ext] = fileparts(filepath);
    filepath_prefix = filepath(1:end-length(filepath_ext));
end

function RGB_image = convert_RGB(image)    
    % Get the number of Z-sections in the stack
    numZ = size(image, 1);
    
    % Initialize cell array to store the RGB images for each Z-section
    RGB_image = cell(numZ, 1);
    
    for z = 1:numZ
        % Get the two-channel image for the current Z-section
        twoChannelImage = image{z};
        
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
        
        % Create the RGB image for the current Z-section
        rgbImage = cat(3, R, G, B);
        
        % Store the RGB image in the rgbStack
        RGB_image{z} = rgbImage;
    end
end