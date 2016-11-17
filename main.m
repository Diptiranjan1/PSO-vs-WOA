
% You can simply define your cost in a seperate file and load its handle to fobj 
% The initial parameters that you need are:
%__________________________________________
% fobj = @YourCostFunction
% dim = number of your variables
% Max_iteration = maximum number of generations
% SearchAgents_no = number of search agents
% lb=[lb1,lb2,...,lbn] where lbn is the lower bound of variable n
% ub=[ub1,ub2,...,ubn] where ubn is the upper bound of variable n
% If all the variables have equal lower bound you can just
% define lb and ub as two single number numbers

% To run WOA: [Best_score,Best_pos,WOA_cg_curve]=WOA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj)
%__________________________________________

clear all 
clc

SearchAgents_no=50; % Number of search agents

Function_name='F1'; % Name of the test function that can be from F1 to F23 (Table 1,2,3 in the paper)

Max_iteration=300;  % Maximum numbef of iterations

% Load details of the selected benchmark function
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);

[Best_score,Best_pos,WOA_cg_curve]=WOA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);

figure('Position',[269   240   660   290])
%Draw search space
%subplot(1,2,1);
func_plot(Function_name);
title('Parameter space')
xlabel('x_1');
ylabel('x_2');
zlabel([Function_name,'( x_1 , x_2 )'])

%Draw objective space
%subplot(1,2,2);
%semilogy(WOA_cg_curve,'Color','r')
%title('Objective space')
%xlabel('Iteration');
%ylabel('Best score obtained so far');
plot(WOA_cg_curve,'LineWidth',2,'Color','r')
title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');

axis tight
grid on
box on
hold on;
%------------------------------------------------------------------------------------------------------------------


%% Problem Definiton
CostFunction = @(x) Spherefun(x);  % Cost Function
nVar = 30;                       % Number of Decision Variables
VarSize = [1 nVar];             % Matrix Size of Decision Variables
VarMin =  -100;                  % Lower Bound of Decision Variables
VarMax =  100;                   % Upper Bound of Decision Variables

%% Parameters of PSO

MaxIt = 300;         % Maximum Number of Iterations
nPop = 50;           % Swarm Size
w = 1;               % Intertia Coefficient
wdamp = 0.99;        % Damping Ratio of Inertia Coefficient
c1 = 2;              % Personal Acceleration Coefficient
c2 = 2;              % Social Acceleration Coefficient


%% Initialisation
empty_particle.Position = [];
empty_particle.Velocity = [];
empty_particle.Cost = [];
empty_particle.Best.Position = [];
empty_particle.Best.Cost = [];


GlobalBest.Cost = inf;      %initialize global best
particle = repmat(empty_particle, nPop, 1); % create population array

% Initialize Population Members
for i=1:nPop

        % Generate Random Solution
        particle(i).Position = unifrnd(VarMin, VarMax, VarSize);

        % Initialize Velocity
        particle(i).Velocity = zeros(VarSize);

        % Evaluation
        particle(i).Cost = CostFunction(particle(i).Position);

        % Update the Personal Best
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Cost = particle(i).Cost;

        % Update Global Best
        if particle(i).Best.Cost < GlobalBest.Cost
            GlobalBest = particle(i).Best;
        end
end

% Array to Hold Best Cost Value on Each Iteration
BestCosts = zeros(MaxIt, 1);

%% Main Loop of PSO

for it=1:MaxIt

        for i=1:nPop

            % Update Velocity
            particle(i).Velocity = w*particle(i).Velocity ...
                + c1*rand(VarSize).*(particle(i).Best.Position - particle(i).Position) ...
                + c2*rand(VarSize).*(GlobalBest.Position - particle(i).Position);

            
            % Update Position
            particle(i).Position = particle(i).Position + particle(i).Velocity;
            
            %Apply Lower bound and Upper Bound
            particle(i).Position=max(particle(i).Position, VarMin);
            particle(i).Position=min(particle(i).Position, VarMax);
            
            % Evaluation
            particle(i).Cost = CostFunction(particle(i).Position);

            % Update Personal Best
            if particle(i).Cost < particle(i).Best.Cost

                particle(i).Best.Position = particle(i).Position;
                particle(i).Best.Cost = particle(i).Cost;

                % Update Global Best
                if particle(i).Best.Cost < GlobalBest.Cost
                    GlobalBest = particle(i).Best;
                end            

            end

        end
        % Store the Best Cost Value
        BestCosts(it) = GlobalBest.Cost;

        % Display Iteration Information
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
        

        % Damping Inertia Coefficient
        w = w * wdamp;

end
    disp ("The Best Solution obtained in PSO is :"), disp (GlobalBest)
    disp ("The Best Cost obtained in PSO is :"), disp (BestCosts(it))
    
    
    
    
%% Results

%figure;
plot(BestCosts, 'LineWidth', 2);
legend('WOA','PSO')
%xlabel('Iteration');
%ylabel('Best Cost');
%grid on;

%figure;
%semilogx(BestCosts, 'LineWidth', 2);
%xlabel('Iteration');
%ylabel('Best Cost');






%------------------------------------------------------------------------------------------------------------------
%mine




display(['The best solution obtained by WOA is : ', num2str(Best_pos)]);
display(['The best optimal value of the objective funciton found by WOA is : ', num2str(Best_score)]);





