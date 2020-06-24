
%Variáveis de uso global
global h g t0 tf;
h = 0.0001;
g = 9.8;
t0 = 0.0;
tf = 3.0;

preditor_corretor();


%Função que utiliza o método preditor corretor para determinar a posição do
%pêndulo numéricamente
function preditor_corretor
   
    global h g t0 tf;
    % y_n+1 = yn + h*f(t_n, y_n)
   
    % ----- Definindo vetores ----- %
    pred_u = zeros(1, (tf/h));
    pred_v = zeros(1, (tf/h));
    pred_T = zeros(1, (tf/h));
    corret_u = zeros(1, (tf/h));
    corret_v = zeros(1, (tf/h));
    corret_x = zeros(1, (tf/h));
    corret_y = zeros(1, (tf/h));
    corret_T = zeros(1, (tf/h));
    
    % ----- Condições iniciais ----- %
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
    
    %Infelizmente, por limitações do método, preciso calcular todos os
    %preditores e corretores ao mesmo tempo. Isso por que as equações do
    %sistema possuem mais de uma variável dependente.
    
   
    while(temp <= tf)
        
        %Eu não consegui separar as equações do preditor e do corretor,
        %isso por que algumas delas requerem valores calculados durante a
        %própria iteração:
        %Exemplo:
        %       Preditor de v requer o cálculo anterior do preditor de T,
        %       pois v depende de Y e de T
        %       Só que, ao mesmo tempo, o corretor de T requer o preditor
        %       de V também. Então eu tive que embaralhar os preditores e os
        %       corretores de modo que cada valor tenha sido calculado
        %       imediatamente antes do seu uso ser necessário.
        
        %Não fui capaz de separar as equações do preditor e do corretor
        
        pred_T(n+1) = pred_T(n) + h*(3*g*corret_v(n));
        pred_v(n+1) = pred_v(n) + h*((pred_T(n)) * corret_y(n) - g);
        corret_T(n+1) = corret_T(n) + (h/2)*(3*g*corret_v(n) + 3*g*pred_v(n+1));
        corret_y(n+1) = corret_y(n) + (pred_v(n+1) * h);
        corret_v(n+1) = corret_v(n) + (h/2)*((corret_T(n)*corret_y(n)) - g + pred_T(n+1)*corret_y(n+1) - g);
        pred_u(n+1) = pred_u(n) + h*(pred_T(n) * corret_x(n));
        corret_u(n+1) = corret_u(n) + (h/2)*((pred_T(n)*corret_x(n)) + (corret_T(n+1)*corret_x(n)));
        corret_x(n+1) = corret_x(n) + h*(corret_u(n+1));
        
        % Adicionar os valores dos corretores como os oficiais
        pred_T(n+1) = corret_T(n+1);
        pred_v(n+1) = corret_v(n+1);
        pred_u(n+1) = corret_u(n+1);
        
        temp = temp + h;
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
    plot(corret_x, corret_y, 'g');
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
    interval = 0:h:tf;
    figure
    plot(interval, corret_x, interval, corret_y, interval, corret_u, interval, corret_v);
    title('Posição e velocidade')
    xlabel('t')
    legend({'X(t)','Y(t)','Vx(t)','Vy(t)'},'Location','south','NumColumns',2)
end  
    