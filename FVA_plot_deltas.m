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

cell_delta_light = table2cell(table(delta_light));
cell_delta_nolight = table2cell(table(delta_nolight));
cell_delta = table2cell(table(delta_delta));

figure
plot = bar(cell2mat(cell_delta));
set(gca, 'XTickLabelRotation', -80);
yticks(-200:20:100)
xlabel('Reactions from the models')
ylabel('Difference of fluxes')
legend('Flux difference', 'Location', 'southwest')
title('Variations in reactions fluxes in the presence or absence of light')
