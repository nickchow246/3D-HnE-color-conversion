function correctedImage = attenuation_correction(image, exponential_E, exponential_S)
    % Get the number of planes in the image stack
    num_planes = size(image, 1);
    
    % Initialize the corrected image stack
    correctedImage = cell(num_planes, 1);
    
    % Apply the correction factor to each plane
    for i = 1:num_planes
        % Get the two-channel image for the current plane
        twoChannelImage = image{i};
        
        % Extract the individual channels
        E = double(twoChannelImage{1});
        S = double(twoChannelImage{2});
        
        % Calculate the correction factors for each channel
        correctionFactor_E = exp(-exponential_E * (i - 1));
        correctionFactor_S = exp(-exponential_S * (i - 1));
        
        % Apply the correction factors to each channel
        correctedE = E * correctionFactor_E;
        correctedS = S * correctionFactor_S;
        
        % Store the corrected two-channel image in the corrected stack
        correctedImage{i} = {correctedE, correctedS};
    end
end