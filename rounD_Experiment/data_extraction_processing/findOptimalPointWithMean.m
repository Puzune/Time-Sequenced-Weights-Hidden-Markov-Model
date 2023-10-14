function [b, r_m] = findOptimalPointWithMean(A)
    % A is the 8x2 matrix containing the coordinates of the eight points

    % Define the objective function L to be minimized
    fun = @(b) objectiveFunction(b, A);

    % Initial guess for b (can be set to the centroid of the eight points for a good starting point)
    b0 = mean(A);

    % Use fminunc to find the optimal point b
    options = optimoptions('fminunc', 'Algorithm', 'quasi-newton');
    b = fminunc(fun, b0, options);

    % Calculate the mean distance r_m for the optimal point b
    r = sqrt(sum((A - b).^2, 2));
    r_m = mean(r);
end

function L = objectiveFunction(b, A)
    % Calculate the distances from the eight points to point b
    r = sqrt(sum((A - b).^2, 2));

    % Calculate the mean of the distances
    r_m = mean(r);

    % Calculate the objective function L
    L = sum((r - r_m).^2);
end
