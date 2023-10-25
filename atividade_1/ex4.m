% Alteração de temperatura: \Delta T = 40 Celsius

% Determinar: Deslocamentos nodais, tensões de cada material, forças de reação
% Método: direto
% Elemento 1/2: L = 300mm; A = 2400 m²; E = 70 10⁹ N/m²
% Elemento 3/4: L = 400mm; A = 600 m²; E = 200 10⁹ N/m²
clear all
clc

% NÚMERO DE ELEMENTOS
ne = 4;

% ELEMENTO 1
Ae(1) = 2.4E+08; % Área transversal do elemento 1 em mm^2
Ee(1) = 7.0E+04; % Módulo de elasticidade do elemento 1 em MPa
le(1) = 1.5E+02; % Comprimento do elemento 1 em mm
ae(1) = 2.3E-07; % Coeficiente de dilatação térmica do elemento 1 em 1/°C

% ELEMENTO 2
Ae(2) = 2.4E+08; % Área transversal do elemento 2 em mm^2
Ee(2) = 7.0E+04; % Módulo de elasticidade do elemento 2 em MPa
le(2) = 1.5E+02; % Comprimento do elemento 2 em mm
ae(2) = 2.3E-07; % Coeficiente de dilatação térmica do elemento 2 em 1/°C

% ELEMENTO 3
Ae(3) = 6.0E+07; % Área transversal do elemento 3 em mm^2
Ee(3) = 2.0E+05; % Módulo de elasticidade do elemento 3 em MPa
le(3) = 2.0E+02; % Comprimento do elemento 3 em mm
ae(3) = 11.7E-06; % Coeficiente de dilatação térmica do elemento 3 em 1/°C

% ELEMENTO 4
Ae(4) = 6.0E+07; % Área transversal do elemento 4 em mm^2
Ee(4) = 2.0E+05; % Módulo de elasticidade do elemento 4 em MPa
le(4) = 2.0E+02; % Comprimento do elemento 4 em mm
ae(4) = 11.7E-06; % Coeficiente de dilatação térmica do elemento 4 em 1/°C

% Variação de temperatura (em graus Celsius)
delta_T = 40;

% Coeficientes de dilatação térmica ajustados
ae(1) = ae(1) * (1 + ae(1) * delta_T);
ae(2) = ae(2) * (1 + ae(2) * delta_T);
ae(3) = ae(3) * (1 + ae(3) * delta_T);
ae(4) = ae(4) * (1 + ae(4) * delta_T);

% MATRIZES DE RIGIDEZ DO ELEMENTO E MATRIZ DE RIGIDEZ GLOBAL
KG = zeros(ne + 1, ne + 1);

for i = 1:ne
    % Calcula a matriz de rigidez do elemento i
    ke = zeros(2, 2);
    ke(1, 1) = 1.0 * Ae(i) * Ee(i) / le(i);
    ke(1, 2) = -1.0 * Ae(i) * Ee(i) / le(i);
    ke(2, 1) = -1.0 * Ae(i) * Ee(i) / le(i);
    ke(2, 2) = 1.0 * Ae(i) * Ee(i) / le(i);

    % Monta a matriz de rigidez global
    KG(i:i + 1, i:i + 1) = KG(i:i + 1, i:i + 1) + ke;
end

% CONDIÇÕES DE CONTORNO NATURAIS (FORÇAS E MOMENTOS)
F = zeros(ne + 1, 1);
F(3, 1) = 200.0E+03; % Aplicando uma força de 200 kN no terceiro nó

% SALVANDO O VETOR DE FORÇA ORIGINAL
F_ORIG = F;

% Aplicando condições de contorno essenciais (apoio)
KG(1, :) = 0.0;
KG(:, 1) = 0.0;
KG(1, 1) = 1.0;

KG(ne + 1, :) = 0.0;
KG(:, ne + 1) = 0.0;
KG(ne + 1, ne + 1) = 1.0;

% MODIFICANDO O VETOR DE FORÇA GLOBAL
F(1, 1) = 0.0; % Consequência da condição de contorno essencial
F(ne + 1, 1) = 0.0; % Consequência da condição de contorno essencial

% RESOLVENDO O PROBLEMA COM TODAS AS CONDIÇÕES DE CONTORNO
Q = inv(KG) * F; % Vetor de deslocamentos nodais globais

% Efeitos da variação de temperatura nos deslocamentos
for i = 1:ne
    delta_L = le(i) * ae(i) * delta_T;
    Q(i) = Q(i) + delta_L;
end

% CALCULANDO AS FORÇAS DE REAÇÃO
R = KG * Q - F;

% DETERMINAÇÃO DAS TENSÕES EM CADA MATERIAL

% TENSÕES NO ELEMENTO 1
S1 = zeros(ne + 1, 1);
for i = 1:size(S1)
    S1(i, 1) = F(i, 1) / Ae(1);
end

% TENSÕES NO ELEMENTO 2
S2 = zeros(ne + 1, 1);
for i = 1:size(S2)
    S2(i, 1) = F(i, 1) / Ae(2);
end

% TENSÕES NO ELEMENTO 3
S3 = zeros(ne + 1, 1);
for i = 1:size(S3)
    S3(i, 1) = F(i, 1) / Ae(3);
end

% TENSÕES NO ELEMENTO 4
S4 = zeros(ne + 1, 1);
for i = 1:size(S4)
    S4(i, 1) = F(i, 1) / Ae(4);
end

% Exibição dos resultados
Q % Deslocamentos nodais globais com efeitos da variação de temperatura
R % Forças de reação com efeitos da variação de temperatura
S1 % Tensões no Elemento 1 com efeitos da variação de temperatura
S2 % Tensões no Elemento 2 com efeitos da variação de temperatura
S3 % Tensões no Elemento 3 com efeitos da variação de temperatura
S4 % Tensões no Elemento 4 com efeitos da variação de temperatura
