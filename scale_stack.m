function image = scale_stack(image, parameters_optimized)
    % Unpack the parameters
    E_to_S = parameters_optimized(1);
    S_to_E = parameters_optimized(2);
    scale_E = parameters_optimized(3);
    scale_S = parameters_optimized(4);

    % Get the number of planes in the image stack
    num_planes = size(image, 1);
    
    % Iterate over each plane in the image stack
    for i = 1:num_planes
        % Extract E and S channels for the current plane
        E = image{i, 1}{1, 1};
        S = image{i, 1}{1, 2};
        
        % Resolve crosstalk
        E_crosstalk = E * E_to_S;
        S_crosstalk = S * S_to_E;
        E = E - S_crosstalk;
        S = S - E_crosstalk;
        E = max(E, 0);
        S = max(S, 0);
    
        % Scale the channels
        E = E * scale_E;
        S = S * scale_S;
        
        % Store the scaled E and S channels in the image stack
        image{i, 1} = {E, S};
    end
end