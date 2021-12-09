%clear all

initCobraToolbox 


%% Model import

model_2 = readCbModel('Supplemental_Data7.xml');
model_2 = changeObjective(model_2,'R351',1);        % Biomass equation


%% Biomass and other important equations %%

%R346 (protein/B1)
%R347 (DNA/B2)
%R348 (RNA/B3)
%R349 (Carbohydrates/B4)
%R350 (Lipids/B5)
%R351 (Biomass)
%R203 (Photon influx varies from 0 to 7 for non phototrophic growth to 1308.9 in max phototrophic growth)
%R344 (carbon source (hydrogenocarbonate) varies from 0 to 0.45)
%R205 (ATP consumption varies from 0 to 0.27 --- 50.49 in phototrophic growth)
%R372 (urea uptake goes to 0 if we only want one source of nitrogen that is nitrate)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Plot 3D (Figure 2 of the article)

model_plot = model_2;
v = [];

model_plot = changeRxnBounds(model_plot, 'R205',0.27,'b');
model_plot = changeRxnBounds(model_plot, 'R372',0,'b');

for i=0:0.2:7
    model_plot = changeRxnBounds(model_plot, 'R203',i,'b'); % Photon influx
    for j=0:0.45/35:0.45
        model_plot = changeRxnBounds(model_plot, 'R344',j,'b'); % Hydrogenocarbonate
        w = optimizeCbModel(model_plot,'max');
        v = [v; w.f];
    end
end

x=0:0.2:7;
y=0:0.45/35:0.45;
v(isnan(v))=0;
m=reshape(v,36,36);
colormap autumn;
surf(y,x,transpose(m))
xlabel('CO_2 uptake (in mmol gDW^-^1.h^-^1)'), ylabel('light (in mmol photons gDW^-^1.h^-^1)'), zlabel('growth rate (in h^-^1)')
title('Growth rate of Synechocystis sp. depending on CO2 and light conditions')

% Handle of the labels name position

xh = get(gca,'XLabel'); 
set(xh, 'Units', 'Normalized');
pos = get(xh, 'Position');
set(xh, 'Position',pos.*[1,-0.5,1],'Rotation',15);
yh = get(gca,'YLabel');
set(yh, 'Units', 'Normalized');
pos = get(yh, 'Position');
set(yh, 'Position',pos.*[0.9,-0.6,1],'Rotation',-26);


%% FBA %%

%%%%%% parameters (with photosynthesis/light)

model_2_photo = model_2;
model_2_photo = changeRxnBounds(model_2_photo, 'R203',1308.9,'b');  % Photon influx
model_2_photo = changeRxnBounds(model_2_photo, 'R205',50.49,'b');   % ATP consumption
model_2_photo = changeRxnBounds(model_2_photo, 'R372',0,'b');       % urea uptake

FBA_solution_photo = optimizeCbModel(model_2_photo,'max');

%%%%%% parameters (without photosynthesis/light)

model_2_no_photo = model_2;
model_2_no_photo = changeRxnBounds(model_2_no_photo, 'R203',7,'b');     % Photon influx
model_2_no_photo = changeRxnBounds(model_2_no_photo, 'R205',0.27,'b');  % ATP consumption
model_2_no_photo = changeRxnBounds(model_2_no_photo, 'R372',0,'b');     % urea uptake

FBA_solution_no_photo = optimizeCbModel(model_2_no_photo,'max');
