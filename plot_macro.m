%% List of the reactions to study in the FVA

rxnsList_2 = {'R346'; 'R347'; 'R348'; 'R349'; 'R350'; 'R351'}; % Biomass equations
macro_list = {'Protein'; 'DNA'; 'RNA'; 'Carbohydrates'; 'Lipids'; 'Biomass'};

%% FVA (you can use different solvers like gurobi)

%changeCobraSolver('gurobi','QP');
%changeCobraSolver('gurobi','LP');

[minFluxlight_macro, maxFluxlight_macro, Vminlight_macro, Vmaxlight_macro] = fluxVariability(model_2_photo, 100, 'max', rxnsList_2);
[minFluxnolight_macro, maxFluxnolight_macro, Vminnolight_macro, Vmaxnolight_macro] = fluxVariability(model_2_no_photo, [], [], rxnsList_2);

%% Build FVA light/no light

ymaxlight_macro = maxFluxlight_macro; % light
yminlight_macro = minFluxlight_macro; % light 
ymaxnolight_macro = maxFluxnolight_macro; % no light
yminnolight_macro = minFluxnolight_macro; % no light

light_macro = table(yminlight_macro, ymaxlight_macro);          % table with light min/max
lightfxs_macro = table2cell(light_macro);                       % cells with ligh min/max
nolight_macro = table(yminnolight_macro, ymaxnolight_macro);    % table with no light min/max
nolightfxs_macro = table2cell(nolight_macro);                   % cells with no ligh min/max

%% Plot figure light
figure
plot = bar(cell2mat(lightfxs_macro));
xticklabels(macro_list)
yticks(0:2:20)
xlabel('Reactions of macromolecules production needed to make biomass')
ylabel('Fluxes values (in mmol.g^-^1.DW^-^1')
legend({'minimum flux', 'maximum flux'}, 'Location', 'northwest')
title('FVA analysis : Minimum and maximum fluxes values in the presence of light for optimized growth')

%% Plot figure nolight
figure
plot = bar(cell2mat(nolightfxs_macro));
plot(1).FaceColor = 'b';
plot(2).FaceColor = 'r';
xticklabels(macro_list)
yticks(-0:0.01:0.1)
xlabel('Reactions of macromolecules production needed to make biomass')
ylabel('Fluxes values (in mmol.g^-^1.DW^-^1')
legend({'minimum flux', 'maximum flux'}, 'Location', 'northwest')
title('FVA analysis : Minimum and maximum fluxes values in the absence of light for optimized growth')
