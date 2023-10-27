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

% MATRIZES DE RIGIDEZ DO ELEMENTO E MATRIZ DE RIGIDEZ GLOBAL
KG = zeros(ne + 1, ne + 1);

for i = 1:ne
    % Calcula a matriz de rigidez do elemento i
    ke = zeros(2, 2);
    ke(1, 1) = 1.0 * Ae(i) * Ee(i) / le(i);
    ke(1, 2) = -1.0 * Ae(i) * Ee(i) / le(i);
    ke(2, 1) = -1.0 * Ae(i) * Ee(i) / le (i);
    ke(2, 2) = 1.0 * Ae(i) * Ee(i) / le(i);

    % Monta a matriz de rigidez global
    KG(i:i + 1, i:i + 1) = KG(i:i + 1, i:i + 1) + ke;
end

% Coeficientes de dilatação térmica ajustados
for i = 1:ne
    ae(i) = ae(i) * (1 + ae(i) * delta_T);
end

% Calcula as tensões térmicas devido à variação de temperatura
F_thermal = zeros(ne + 1, 1);

for i = 1:ne
    delta_L = le(i) * ae(i) * delta_T;
    F_thermal(i) = Ae(i) * Ee(i) * delta_L;
end

% CONDIÇÕES DE CONTORNO NATURAIS (FORÇAS E MOMENTOS)
F = zeros(ne + 1, 1);
F(3, 1) = 200.0E+03; % Aplicando uma força de 200 kN no terceiro nó

% Adiciona a força térmica à força aplicada
F = F + F_thermal;

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

% CALCULANDO AS FORÇAS DE REAÇÃO
R = KG * Q - F;

% DETERMINAÇÃO DAS TENSÕES EM CADA MATERIAL

% Inicialização das tensões em cada elemento
Stresses = zeros(ne, 1);

% Cálculo das tensões em cada elemento
for i = 1:ne
    % Vetor de deslocamentos nodais do elemento i
    u_i = Q(i);
    u_j = Q(i + 1);

    % Cálculo das tensões no elemento i
    stress_i = (Ee(i) / le(i)) * [-1 1] * [u_i; u_j];
    
    Stresses(i) = stress_i;
end

% Exibição das tensões em cada elemento
Stresses

% Exibição dos resultados
Q % Deslocamentos nodais globais com efeitos da variação de temperatura
R % Forças de reação com efeitos da variação de temperatura

