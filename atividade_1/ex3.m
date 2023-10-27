% Modifique o código do exercício 2 modificando o posicionamento da carga

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

% ELEMENTO 2
Ae(2) = 2.4E+08; % Área transversal do elemento 1 em mm^2
Ee(2) = 7.0E+04; % Módulo de elasticidade do elemento 1 em MPa
le(2) = 1.5E+02; % Comprimento do elemento 1 em mm

% ELEMENTO 3
Ae(3) = 6.0E+07; % Área transversal do elemento 2 em mm^2
Ee(3) = 2.0E+05; % Módulo de elasticidade do elemento 2 em MPa
le(3) = 2.0E+02; % Comprimento do elemento 2 em mm

% ELEMENTO 4
Ae(4) = 6.0E+07; % Área transversal do elemento 2 em mm^2
Ee(4) = 2.0E+05; % Módulo de elasticidade do elemento 2 em MPa
le(4) = 2.0E+02; % Comprimento do elemento 2 em mm


% MATRIZES DE RIGIDEZ DO ELEMENTO E MATRIZ DE RIGIDEZ GLOBAL
KG = zeros(ne+1,ne+1);

for i = 1:ne
    % Calcula a matriz de rigidez do elemento i
    ke = zeros(2, 2);
    ke(1, 1) =  1.0 * Ae(i) * Ee(i) / le(i);
    ke(1, 2) = -1.0 * Ae(i) * Ee(i) / le(i);
    ke(2, 1) = -1.0 * Ae(i) * Ee(i) / le(i);
    ke(2, 2) =  1.0 * Ae(i) * Ee(i) / le(i);

    % Monta a matriz de rigidez global
    KG(i:i+1, i:i+1) = KG(i:i+1, i:i+1) + ke;
end

% EXIBIÇÃO DAS MATRIZES DE RIGIDEZ DO ELEMENTO
ke % Matrizes de rigidez dos elementos

KG % Matriz de rigidez global

% SALVANDO A MATRIZ DE RIGIDEZ ORIGINAL
KG_ORIG = KG;

% CONDIÇÕES DE CONTORNO NATURAIS (FORÇAS E MOMENTOS)
F = zeros(ne+1,1);
F(2,1) = 200.0E+03; % Aplicando uma força de 200 kN no segundo nó

% SALVANDO O VETOR DE FORÇA ORIGINAL
F_ORIG = F;

% APLICANDO CONDIÇÕES DE CONTORNO ESSENCIAIS (DESLOCAMENTO)
% USANDO O MÉTODO DIRETO
% MODIFICANDO A MATRIZ DE RIGIDEZ GLOBAL
KG(1,:) = 0.0;
KG(:,1) = 0.0;
KG(1,1) = 1.0;

KG(ne+1,:)    = 0.0;
KG(:,ne+1)    = 0.0;
KG(ne+1,ne+1) = 1.0;

% EXIBIÇÃO DA MATRIZ COM CONDIÇÕES DE CONTORNO
KG % Matriz de rigidez global com condições de contorno

% MODIFICANDO O VETOR DE FORÇA GLOBAL
F(1,1) = 0.0; % Consequência da condição de contorno essencial
F(ne+1,1) = 0.0; % Consequência da condição de contorno essencial

% EXIBIÇÃO DO VETOR DE FORÇA GLOBAL (F)
F

% RESOLVENDO O PROBLEMA COM TODAS AS CONDIÇÕES DE CONTORNO
Q = inv(KG)*F; % Vetor de deslocamentos nodais globais

% EXIBIÇÃO DOS DESLOCAMENTOS NODAIS GLOBAIS (Q)
Q

% CALCULANDO AS FORÇAS DE REAÇÃO
R = KG_ORIG*Q - F;

% EXIBIÇÃO DAS FORÇAS DE REAÇÃO
R

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