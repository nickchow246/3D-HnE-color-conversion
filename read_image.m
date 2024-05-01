function image = read_image(filename, image_index, E_S_channel, start_plane, end_plane, omit_last_plane)
    % Initialize Bio-Formats reader
    reader = bfGetReader(filename);
    
    % Set the series index
    reader.setSeries(image_index - 1);
    
    % Get the number of Z-sections in the series
    numZSections = reader.getSizeZ();
    
    % Get the number of channels in the series
    numChannels = length(E_S_channel);
    
    % Define the selected Z planes based on start_plane and end_plane
    if nargin < 4 || isempty(start_plane) || start_plane < 1
        start_plane = 1;
    end
    if nargin < 5 || isempty(end_plane) || end_plane > numZSections
        end_plane = numZSections;
    end
    selectedZPlanes = start_plane:end_plane;
    
    % Adjust the selected Z planes if omit_last_plane is true
    if nargin > 5 && omit_last_plane
        selectedZPlanes = selectedZPlanes(1:end-1);
    end
    
    % Initialize cell array to store the Z stack
    image = cell(length(selectedZPlanes), 1);
    
    % Display progress every 10%
    progressStep = ceil(length(selectedZPlanes) / 10);
    
    for i = 1:length(selectedZPlanes)
        z = selectedZPlanes(i);
        
        % Initialize cell array to store channels for the current Z-section
        channels = cell(1, numChannels);
        
        for c = 1:numChannels
            % Read the plane corresponding to the current Z-section and channel
            planeIndex = reader.getIndex(z - 1, E_S_channel(c) - 1, 0) + 1;
            img = bfGetPlane(reader, planeIndex);
            channels{c} = img;
        end
        
        % Store the channels for the current Z-section in the image stack
        image{i} = channels;
        
        % Display progress every 10%
        if mod(i, progressStep) == 0
            progress = i / length(selectedZPlanes) * 100;
            fprintf('Progress: %.0f%%\n', progress);
        end
    end
    
    % Display progress as 100% if the reader has finished
    if mod(length(selectedZPlanes), progressStep) ~= 0
        fprintf('Progress: 100%%\n');
    end
    
    % Close the reader
    reader.close();
end