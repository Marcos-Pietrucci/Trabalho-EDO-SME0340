
%Variáveis de uso global
global h g t0 tf;
h = 0.0001;
g = 9.8;
t0 = 0.0;
tf = 3.0;

preditor_corretor_y();

%Método de Euler como preditor

%PARA A POSIÇÃO y

function preditor_corretor_y
   
    global h g t0 tf;
    % y_n+1 = yn + h*f(t_n, y_n)
   
    % ----- PREDITOR ----- %
    pred_u = zeros(1, (tf/h));
    pred_v = zeros(1, (tf/h));
    pred_T = zeros(1, (tf/h));
    corret_u = zeros(1, (tf/h));
    corret_v = zeros(1, (tf/h));
    corret_x = zeros(1, (tf/h));
    corret_y = zeros(1, (tf/h));
    corret_T = zeros(1, (tf/h));
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
    
    while(temp <= tf)
        
        pred_T(n+1) = pred_T(n) +h*(-3*g*corret_v(n));
        pred_v(n+1) = pred_v(n) + h*((-pred_T(n)) * corret_y(n) - g);
        
        corret_T(n+1) = corret_T(n) + (h/2)*(-3*g*corret_v(n) - 3*g*pred_v(n+1));
        corret_y(n+1) = corret_y(n) + (pred_v(n+1) * h);
        corret_v(n+1) = corret_v(n) + (h/2)*((-corret_T(n)*corret_y(n)) - g - pred_T(n+1)*corret_y(n+1) - g);
        
        
        pred_u(n+1) = pred_u(n) + h*((-pred_T(n)) * corret_x(n));
        corret_u(n+1) = corret_u(n) + (h/2)*((-pred_T(n)*corret_x(n)) + (-corret_T(n+1)*corret_x(n)));
        corret_x(n+1) = corret_x(n) + (h)*(corret_u(n+1));
        
        pred_T(n+1) = corret_T(n+1);
        pred_v(n+1) = corret_v(n+1);
        pred_u(n+1) = corret_u(n+1);
        
        temp = temp + h;
        
        n = n + 1;
    end  
    
    title('Posição X(t) do pêndulo')
    plot(corret_x,corret_y);
end

