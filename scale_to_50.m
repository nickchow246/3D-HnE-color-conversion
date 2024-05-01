function scaledImage = scale_to_50(image, interval, scale_target)
    % Get the number of planes in the image stack
    num_planes = size(image, 1);
    
    % Initialize variables to store mean values for each plane within the interval
    meanE = zeros(ceil(num_planes / interval), 1);
    meanS = zeros(ceil(num_planes / interval), 1);
    
    % Iterate over the planes with the specified interval
    plane_index = 1;
    for i = 1:interval:num_planes
        % Extract E and S channels for the current plane
        E = double(image{i, 1}{1, 1});
        S = double(image{i, 1}{1, 2});
        
        % Calculate the mean values for E and S channels
        E_nonzero = E(E > 0);
        S_nonzero = S(S > 0);
        meanE(plane_index) = mean(E_nonzero(:));
        meanS(plane_index) = mean(S_nonzero(:));
        
        plane_index = plane_index + 1;
    end
    
    % Find the maximum mean E value within the interval
    maxMeanE = max(meanE);
    
    % Find the maximum mean S value within the interval
    maxMeanS = max(meanS);
    
    % Calculate the scaling factors for E and S channels
    scalingFactorE = scale_target / maxMeanE;
    scalingFactorS = scale_target / maxMeanS;
    
    % Print out the values for debugging
    fprintf('Max Mean E: %.2f\n', maxMeanE);
    fprintf('Max Mean S: %.2f\n', maxMeanS);
    fprintf('Scaling Factor E: %.4f\n', scalingFactorE);
    fprintf('Scaling Factor S: %.4f\n', scalingFactorS);
    
    % Initialize the scaled image stack
    scaledImage = cell(size(image));
    
    % Iterate over each plane in the image stack
    for i = 1:num_planes
        % Extract E and S channels for the current plane
        E = double(image{i, 1}{1, 1});
        S = double(image{i, 1}{1, 2});
        
        % Scale the E channel
        scaledE = E * scalingFactorE;
        
        % Scale the S channel
        scaledS = S * scalingFactorS;
        
        % Store the scaled E and S channels in the scaled image stack
        scaledImage{i, 1} = {scaledE, scaledS};
    end
end