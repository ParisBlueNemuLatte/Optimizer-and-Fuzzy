clc
clear
close all
% Define benchmark functions

% Sphere Function (F1)
sphere = @(x) sum(x.^2);

% Rosenbrock Function (F2)
rosenbrock = @(x) sum(100*(x(2:end)-(x(1:end-1).^2)).^2 + (x(1:end-1)-1).^2);

% Rastrigin Function (F3)
rastrigin = @(x) sum(x.^2 - 10*cos(2*pi*x) + 10);

% Define optimization parameters
numRuns = 15;
dimensions = [2, 10]; % Dimensions to test

% Initialize results storage
results = struct();

% Functions to test
funcs = {sphere, rosenbrock, rastrigin};
funcNames = {'Sphere', 'Rosenbrock', 'Rastrigin'};

% Optimization algorithms
algos = {'ga', 'pso', 'sa'};
algoNames = {'GA', 'PSO', 'SA'};

% Run optimization
for d = dimensions
    for i = 1:length(funcs)
        func = funcs{i};
        fName = funcNames{i};
        
        for j = 1:length(algos)
            algo = algos{j};
            aName = algoNames{j};
            
            bestResults = zeros(1, numRuns);
            for run = 1:numRuns
                switch algo
                    case 'ga'
                        % Genetic Algorithm
                        options = optimoptions('ga', 'Display', 'off');
                        [~, fval] = ga(func, d, [], [], [], [], -5*ones(1, d), 5*ones(1, d), [], options);
                    case 'pso'
                        % Particle Swarm Optimization
                        options = optimoptions('particleswarm', 'Display', 'off');
                        [~, fval] = particleswarm(func, d, -5*ones(1, d), 5*ones(1, d), options);
                    case 'sa'
                        % Simulated Annealing
                        options = optimoptions('simulannealbnd', 'Display', 'off');
                        [~, fval] = simulannealbnd(func, rand(1, d)*10 - 5, -5*ones(1, d), 5*ones(1, d), options);
                end
                bestResults(run) = fval;
            end
            
            % Store results
            results.(fName).(aName).(['D', num2str(d)]) = struct(...
                'Best', min(bestResults), ...
                'Worst', max(bestResults), ...
                'Mean', mean(bestResults), ...
                'StdDev', std(bestResults) ...
            );
        end
    end
end

% Display results
disp(results);

% Plot convergence for one example
d = 2; % Example dimension
for i = 1:length(funcs)
    func = funcs{i};
    fName = funcNames{i};
    
    figure('Name', [fName ' Convergence']);
    for j = 1:length(algos)
        algo = algos{j};
        aName = algoNames{j};
        
        bestResults = zeros(1, numRuns);
        for run = 1:numRuns
            switch algo
                case 'ga'
                    [~, fval] = ga(func, d, [], [], [], [], -5*ones(1, d), 5*ones(1, d));
                case 'pso'
                    [~, fval] = particleswarm(func, d, -5*ones(1, d), 5*ones(1, d));
                case 'sa'
                    [~, fval] = simulannealbnd(func, rand(1, d)*10 - 5, -5*ones(1, d), 5*ones(1, d));
            end
            bestResults(run) = fval;
        end
        
        subplot(3,1,j);
        plot(1:numRuns, bestResults, 'o-');
        title([fName ' using ' aName]);
        xlabel('Run');
        ylabel('Best Result');
    end
end
