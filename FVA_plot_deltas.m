%% List of the reactions to study in the FVA

full_rxnsList = model_2.rxnNames;


%% FVA (you can use different solvers like gurobi)

%changeCobraSolver('gurobi','QP');
%changeCobraSolver('gurobi','LP');

[minFlux1_2, maxFlux1_2, Vmin1_2, Vmax1_2] = fluxVariability(model_2_photo, 100, 'max', full_rxnsList, 0, true, 'FBA');
[minFlux2_2, maxFlux2_2, Vmin2_2, Vmax2_2] = fluxVariability(model_2_no_photo, [], [], full_rxnsList, 0, true, 'FBA'); 


%% plot FVA light/no light

ymax1 = maxFlux1_2; % light
ymin1 = minFlux1_2; % light 
ymax2 = maxFlux2_2; % no light
ymin2 = minFlux2_2; % no light

delta_light = ymax1-ymin1;      % delta between max and min value for light condition
delta_nolight = ymax2-ymin2;    % delta between max and min value for no light condition
delta_delta = delta_light-delta_nolight;     % delta between deltas (so difference of flux between conditions)

delta_max = ymax2-ymax1;    % delta between no light and light maximum flux of each reaction
delta_min = ymin2-ymin1;    % delta between no light and light maximum flux of each reaction

cell_delta_light = table2cell(table(delta_light));
cell_delta_nolight = table2cell(table(delta_nolight));
cell_delta = table2cell(table(delta_delta));

cell_max = table2cell(table(delta_max));
cell_min = table2cell(table(delta_min));

figure
cell_max(264)={[0]};        % The reaction at index 264 is the uptake of photon hich we defined ourselves so we don't take it into account
plot = bar(cell2mat(cell_max));
yticks(-200:100:200)
xlabel('Reactions from the models')
ylabel('Fluxes max')
legend('Flux difference', 'Location', 'southwest')
title('Differences in variations of reactions fluxes')
