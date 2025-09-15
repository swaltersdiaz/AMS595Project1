%% Part 1 - Using a for-loop

% Since I've done a couple variations of this code, let's start fresh
% (implementing ideas from the last slide of lecture 1)
clc; %clears the command window
clear; %removes all pre-existing variables 

% Let's first establish some values
max_points = 1e5;
step = 5000; %how many points generated in each iteration
trials = max_points/step; %total # of loop iterations

% We now need to create arrays to store our values
calculated_pi = zeros(trials,1); %stores our estimated pi value at each step
error = zeros(trials,1); %stores the deviation of our estimated pi from the true pi
length = zeros(trials,1); %stores the execution time of each step
point_counter = (step:step:max_points); %vector of the dif. point counts at each step (inc. w/ each iter.)

% Estimating pi using Monte Carlo algorithm
for k = 1:trials
    N = point_counter(k);

    tic; %had to look this up, but this starts the timer

    inside_circle = 0;     %initializing the point count for inside the quarter circle

    for i = 1:N
        x = rand();        
        y = rand();        
        if x^2 + y^2 <= 1  %check if (x, y) lies inside the quarter circle
            inside_circle = inside_circle + 1;  %if the point lies within the quarter circle, we count it
        end
    end

    % Calculate the estimated value of pi
    calculated_pi(k) = (inside_circle / N) * 4; 

    % Calculate the deviation of our estimated pi from the true pi
    error(k) = abs(calculated_pi(k) - pi); 

    % Record execution time for this iteration
    length(k) = toc; 
end

% First Plot - Estimated Pi vs Total Number of Points
figure;
plot(point_counter, calculated_pi, 'b-', 'LineWidth', 2);
xlabel('Total Points');
ylabel('Estimated \pi'); %use of \pi will produce the actual greek symbol in the plot label
title('Estimation of \pi using Monte Carlo Method');
grid on;

% Second Plot - Error vs Total Number of Points
figure;
plot(point_counter, error, 'r-', 'LineWidth', 2);
xlabel('Total Points');
ylabel('Error');
title('Error in \pi Estimation using Monte Carlo Method');
grid on;

% Third Plot - Execution Time vs Total Number of Points
figure;
plot(point_counter, length, 'g-', 'LineWidth', 2);
xlabel('Total Points');
ylabel('Execution Time (seconds)');
title('Execution Time for \pi Estimation using Monte Carlo Method');
grid on;

% Fourth Plot - Precision vs Execution Time
figure;
scatter(length, calculated_pi, 'filled');
xlabel('Execution Time (seconds)');
ylabel('Estimated \pi');
title('Precision vs Execution Time');
grid on;


%% Part 2 - Using a while loop

% We again want to start with a clean slate
clc; 
clear;

% First let's establish some values
sigfigs = 3; %our chosed level of precision
min_points = 100; %the min number of points we will require before checking convergence
required_stable_est = 50; %we will require 50 consecutive stable rounded estimates
pi_estimate = 0;

% We intialize our various counters
stable_est_counter = 0;
points_inside_circle = 0;
total_points  = 0;

% We will store history for plotting
pi_history = [];

while true
    % Let's generate a random point
    x = rand;
    y = rand;
    total_points = total_points + 1;

    % Then we must check if the point falls inside the quarter circle
    if x^2 + y^2 <= 1
        points_inside_circle = points_inside_circle + 1;
    end

    % We update the pi estimate
    pi_estimate = 4 * (points_inside_circle / total_points);
    pi_history(end+1) = pi_estimate;

    % Only after we've generated enough points do we check convergence
    if total_points > min_points
        % Round to our desired sig figs value (i.e. 3)
        pi_str = sprintf(['%0.', num2str(sigfigs), 'g'], pi_estimate);
        pi_num = str2double(pi_str);

        % We will now check stability
        if exist('last_pi_num', 'var') && pi_num == last_pi_num
            stable_est_counter = stable_est_counter + 1;
        else
            stable_est_counter = 0;
        end
        last_pi_num = pi_num;

        % Stop if our number of consecutive stable estimates is long enough
        if stable_est_counter >= required_stable_est
            break;
        end
    end
end

% We can display results using the following code
fprintf('Monte Carlo estimate of pi (to %d sig figs): %s\n', sigfigs, pi_str);
fprintf('Number of iterations: %d\n', total_points);

% A visual representation of how our estimate converges to the true value
% of pi
figure;
plot(1:total_points, pi_history, 'b-', 'LineWidth', 1.2); hold on;
yline(pi, 'r--', 'LineWidth', 1.5);
xlabel('Iterations'); 
ylabel('Estimated \pi');
title(sprintf('Convergence of Monte Carlo \n (%d sig figs)', sigfigs));
legend('Estimate', 'True \pi');
grid on;


%% Part 3 - Part 2 turned into a function

function pi_estimate = monteCarloPi(sigfigs)

    % This all the same from part 2
    min_points = 100;        
    pi_estimate = 0;

    stable_est_counter = 0;
    points_inside_circle = 0;
    total_points  = 0;

    % We shall set a min requirement of stable iterations based on sigfig
    if sigfigs == 2
        required_stable_est = 20;
    elseif sigfigs == 3
        required_stable_est = 30;
    else
        required_stable_est = 50;
    end

    pi_history = [];

    % We will use 2 subplots in our figure
    figure;
    subplot(1,2,1); 
    hold on; 
    axis square;
    xlabel('x'); 
    ylabel('y');
    title('Monte Carlo Scatter Plot');

    subplot(1,2,2); 
    hold on;
    xlabel('Iterations'); 
    ylabel('Estimated \pi');
    title('Convergence of \pi');
    yline(pi, 'r--', 'LineWidth', 1.5);


    % Now we run our while loop
    % Again this all the same as in part 2
    while true
        x = rand;
        y = rand;
        total_points = total_points + 1;
        
        if x^2 + y^2 <= 1
            points_inside_circle = points_inside_circle + 1;
            subplot(1,2,1);
            plot(x, y, 'b.'); % inside = blue
        else
            subplot(1,2,1);
            plot(x, y, 'r.'); % outside = red
        end

        pi_estimate = 4 * (points_inside_circle / total_points);
        pi_history(end+1) = pi_estimate;
        
        % We will update our convergence curve every 100 points
        if mod(total_points, 100) == 0
            subplot(1,2,2);
            plot(1:total_points, pi_history, 'b-');
            drawnow;
        end
        
        % Only after enough points do we check convergence
        if total_points > min_points
            % Round to our desired sig figs value (what the user decides)
            pi_str = sprintf(['%0.', num2str(sigfigs), 'g'], pi_estimate);
            pi_num = str2double(pi_str);

            % Here, we are checking stability
            if exist('last_pi_num', 'var') && pi_num == last_pi_num
                stable_est_counter = stable_est_counter + 1;
            else
                stable_est_counter = 0;
            end
            last_pi_num = pi_num;

            % Stop if our number of consecutive stable estimates is long enough
            if stable_est_counter >= required_stable_est
                break;
            end
        end
    end

    % We update our final convergence plot
    subplot(1,2,2);
    plot(1:total_points, pi_history, 'b-', 'LineWidth', 1.2);
    yline(pi, 'r--', 'True \pi', 'LineWidth', 1.5);
    
    % Formatting
    pi_str = sprintf(['%0.', num2str(sigfigs), 'g'], pi_estimate);
    
    % We can display our results using the following code
    fprintf('Monte Carlo estimate of pi (to %d sig figs): %s\n', sigfigs, pi_str);
    fprintf('Total iterations: %d\n', total_points);

    % We will print on a scatter plot
    subplot(1,2,1);
    text(0.5, 0.5, ['\pi \approx ', pi_str], 'FontSize', 12, 'Color', 'k', ...
         'HorizontalAlignment', 'center');

end

% We shall test our function
monteCarloPi(4)
