function read_image_titles(filename, omit_suffix)
    % Initialize Bio-Formats reader
    reader = bfGetReader(filename);
    
    % Get the total number of series in the LIF file
    numSeries = reader.getSeriesCount();
    
    % Print the image titles
    fprintf('Image titles in %s:\n', filename);
    for i = 1:numSeries
        reader.setSeries(i - 1);
        imageTitle = char(reader.getMetadataStore().getImageName(i - 1));
        
        % Check if the image title ends with the specified suffix
        if nargin > 1 && endsWith(imageTitle, omit_suffix)
            continue; % Skip printing if the suffix matches
        end
        
        fprintf('%d. %s\n', i, imageTitle);
    end
    
    % Close the reader
    reader.close();
end