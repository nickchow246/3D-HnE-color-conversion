function analyze_image(image, interval)
    % Get the number of planes in the image stack
    num_planes = size(image, 1);
    
    % Initialize variables to store min, max, and average values
    minE = zeros(ceil(num_planes / interval), 1);
    maxE = zeros(ceil(num_planes / interval), 1);
    avgE = zeros(ceil(num_planes / interval), 1);
    minS = zeros(ceil(num_planes / interval), 1);
    maxS = zeros(ceil(num_planes / interval), 1);
    avgS = zeros(ceil(num_planes / interval), 1);
    
    % Iterate over the planes with the specified interval
    plane_index = 1;
    for i = 1:interval:num_planes
        % Extract E and S channels for the current plane
        E = image{i, 1}{1, 1};
        S = image{i, 1}{1, 2};
        
        % Calculate min, max, and average values for E channel
        minE(plane_index) = min(E(:));
        maxE(plane_index) = max(E(:));
        E_nonzero = E(E > 0);
        avgE(plane_index) = mean(E_nonzero(:));
        
        % Calculate min, max, and average values for S channel
        minS(plane_index) = min(S(:));
        maxS(plane_index) = max(S(:));
        S_nonzero = S(S > 0);
        avgS(plane_index) = mean(S_nonzero(:));
        
        plane_index = plane_index + 1;
    end
    
    % Print out the min, max, and average values for each analyzed plane
    fprintf('Plane\tMin E\tMax E\tAvg E\tMin S\tMax S\tAvg S\n');
    for i = 1:length(minE)
        plane_number = (i - 1) * interval + 1;
        fprintf('%d\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n', plane_number, minE(i), maxE(i), avgE(i), minS(i), maxS(i), avgS(i));
    end
end