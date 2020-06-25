% SME0340
% Marcos Vinícius Firmino Pietrucci 10770072

%Basta mudar os valores e reexecutar o programa para testar novos parâmetros
%Gráficos são feitos automaticamente
global h g t0 tf;
h = 0.0001;
g = 9.8;
t0 = 0.0;
tf = 3.0;

preditor_corretor();

%Função que utiliza o método preditor corretor para determinar a posição do
%pêndulo numéricamente
function preditor_corretor
   
    global h g t0 tf
   
    % Salvará os intervalos de tempo para plotar os gráficos
    interval = zeros(1, (tf/h));
    interval(1) = h;
    
    % ----- Definindo vetores ----- %
    pred_x = zeros(1, (tf/h));
    pred_y = zeros(1, (tf/h));
    pred_u = zeros(1, (tf/h));
    pred_v = zeros(1, (tf/h));
    pred_T = zeros(1, (tf/h));
    corret_u = zeros(1, (tf/h));
    corret_v = zeros(1, (tf/h));
    corret_x = zeros(1, (tf/h));
    corret_y = zeros(1, (tf/h));
    corret_T = zeros(1, (tf/h));
    
    % ----- Condições iniciais ----- %
    pred_x(1) = 1;
    pred_y(1) = 0;
    pred_u(1) = 0;
    pred_v(1) = 0;
    pred_T(1) = 0;
    corret_x(1) = 1;
    corret_y(1) = 0;
    corret_u(1) = 0;
    corret_v(1) = 0;
    corret_T(1) = 0;
    n = 1;
    temp = t0;    
    
    % ----- Aplicação do método ----- %
    
    %Para proceder com o método precisamos calcular todos os
    %preditores e corretores ao mesmo tempo. Isso por que as equações do
    %sistema possuem mais de uma variável dependente.
    
    while(temp <= tf)

        %Equação dos preditores
        pred_T(n+1) = pred_T(n) + h*(3*g*pred_v(n));
        pred_u(n+1) = pred_u(n) + h*(pred_T(n) * pred_x(n));
        pred_v(n+1) = pred_v(n) + h*(pred_T(n) * pred_y(n) - g);
        pred_x(n+1) = pred_u(n+1);
        pred_y(n+1) = pred_v(n+1);
        
        %Nota-se que os preditores de X e Y são as suas respectivas
        %velocididades instanâneas no momento (n+1)
        
        %Equações dos corretores
        corret_x(n+1) = corret_x(n) + (h/2)*(pred_x(n) + pred_x(n+1));
        corret_y(n+1) = corret_y(n) + (h/2)*(pred_y(n) + pred_y(n+1));  
        corret_T(n+1) = corret_T(n) + (h/2)*(3*g*pred_v(n) + 3*g*pred_v(n+1));
        corret_u(n+1) = corret_u(n) + (h/2)*((pred_T(n)*corret_x(n)) + (pred_T(n+1)*corret_x(n+1)));
        corret_v(n+1) = corret_v(n) + (h/2)*((pred_T(n)*corret_y(n)) + pred_T(n+1)*corret_y(n+1) - 2*g);        
        
        % Adicionar os valores dos corretores como os oficiais
        pred_T(n+1) = corret_T(n+1);
        pred_v(n+1) = corret_v(n+1);
        pred_u(n+1) = corret_u(n+1);
        pred_x(n+1) = corret_u(n+1);
        pred_y(n+1) = corret_v(n+1);
        
        % Incrementos da iteração
        interval(n+1) = temp; % Incrementa o intervalo de tempo que será usado para plot
        temp = temp + h;      % Incrementa o tempo
        n = n + 1;            
        
    end  
    
    %Finalmente, de posse de todos os valores calculados, plotamos os gráficos
 
    % --- Posição do pêndulo --- %
    figure
    plot(corret_y);
    title('Posição Y do pêndulo')
    xlabel('t')
    ylabel('posição y')
    
    figure
    plot(corret_x, 'r');
    title('Posição X do pêndulo')
    xlabel('t')
    ylabel('posição x')
    
    figure
    plot(corret_x, corret_y, 'b');
    title('Posição do pêndulo no plano XY')
    xlabel('X(t)')
    ylabel('Y(t)')
    
    % --- Tração --- %
    figure
    plot(corret_T, 'k');
    title('Tensão na haste')
    xlabel('t')
    ylabel('Tensão')
    
    % --- Velocidades e posições --- %
    figure
    plot(interval, corret_x, interval, corret_y, interval, corret_u, interval, corret_v);
    title('Posição e velocidade')
    xlabel('t')
    legend({'X(t)','Y(t)','Vx(t)','Vy(t)'},'Location','south','NumColumns',2)
    
end  
    