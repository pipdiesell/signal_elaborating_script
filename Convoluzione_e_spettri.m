function Convoluzione_e_spettri(T, tempoMinRect, tempoMaxRect, tempoMinExp, tempoMaxExp, numeroCampioni)

if nargin<6 % il numero degli input � insufficiente
    sprintf('Sintassi: Convoluzione_e_spettri(T, tempoMinRect, tempoMaxRect, tempoMinExp, tempoMaxExp, numeroCampioni)\n')
    return;
end

%%%
%%% IL PROGRAMMA ESEGUE LA CONVOLUZIONE TRA DUE SEGNALI DI DURATA FINITA
%%%


deltaT=T/numeroCampioni; % intervallo tra i campioni
                         % numeroCampioni � il numero di campioni in un intervallo di durata T

tRect=tempoMinRect:deltaT:tempoMaxRect; % vettore dei valori di t per l'impulso rettangolare
sgnRect=0.5*(sign(tRect)-sign(tRect-T)); % vettore dei valori dell'impulso rettangolare

tExp=tempoMinExp:deltaT:tempoMaxExp; % vettore dei valori di t per l'esponenziale monolatero
sgnExp=exp(-tExp/T).*(0.5*(1+sign(tExp))); % vattore dei valori dell'esponenziale monolatero

tConvoluzione=tempoMinRect+tempoMinExp:deltaT:tempoMaxRect+tempoMaxExp; % vettore dei valori di t per il risultato della convoluzione


% convoluzione approssimata (con i campioni)
z=deltaT*conv(sgnRect,sgnExp);

% convoluzione ideale 
intervallo=(tConvoluzione<0); % primo dominio: t<0
zTeorica(intervallo)=0;        % z(t)=0
intervallo=and(tConvoluzione>=0,tConvoluzione<=T); % secondo dominio: 0<=t<=+T
zTeorica(intervallo)=T*(1-exp(-tConvoluzione(intervallo)/T)); % z(t)=T*(1-exp(-t/T))
intervallo=(tConvoluzione>T); % terzo dominio: t>+T
zTeorica(intervallo)=T*exp(-tConvoluzione(intervallo)/T).*(exp(1)-1); % z(t)=T*exp(-t/T)*(exp(1)-1)

% energia totale dell'impulso rettangolare: T
% energia segnale troncato
energiaRecttroncato = min(T,tempoMaxRect)-max(0,tempoMinRect); % energia dell'impulso rettangolare considerato
percentualeEnergiaRect = 100.0*energiaRecttroncato/T; % percentuale dell'energia dell'impulso rettangolare considerata

% energia dell'esponenziale monolatero: T/2
% energia segnale troncato
energiaExptroncato = T/2*(exp(-2*max(0,tempoMinExp)/T)-exp(-2*max(0,tempoMaxExp)/T)); % energia dell'esponenziale monolatero considerato
percentualeEnergiaExp = 100.0*energiaExptroncato/(T/2); % percentuale dell'energia dell'esponenziale monolatero considerata



% disegno dei risultati
figure;
% set(gcf,'defaultaxesfontsize',16)
% set(gcf,'defaultaxesfontname','Courier New')
plot(tConvoluzione, zTeorica, 'Color', 'b', 'LineWidth', 2, 'LineStyle', '--');
hold on;
plot(tConvoluzione, z, 'Color', 'r', 'LineWidth', 2);
grid on;
tmp=xlabel('Tempo (s)');
set(tmp,'FontSize',12);
tmp=ylabel('z(t) = rect(t/T) \otimes exp(-t/T)\cdotu(t)');
set(tmp,'FontSize',12);
tmp=legend('teorica', 'approssimata');
set(tmp,'FontSize',11);
titoloGrafico=sprintf('Convoluzione tra l''impulso rettangolare e l''esponenziale monolatero\n(T = %.1f s, E_{rect} = %.2f%%, E_{exp} = %.2f%%)', T, percentualeEnergiaRect, percentualeEnergiaExp);
tmp=title(titoloGrafico);
set(tmp,'FontSize',14);



%%%%%%%%%%%%%%%
% Trasformata di Fourier
%%%%%%%%%%%%%%%

% calcolo approssimato (con i campioni)
Z=deltaT*fft(z); % vettore con i valori della trasformata di Fourier approssimata
Z=[Z((length(Z)+1)/2+1:length(Z)) Z(1:(length(Z)+1)/2)]; % si scambia la prima met� (valori per frequenze positive)
                                                         % con la seconda met� del vettore (valori per frequenze negative) negative
frequenzaNormalizzata=-numeroCampioni/2:numeroCampioni/(length(Z)-1):numeroCampioni/2; % vettore dei valori di frequenza normalizzata a 1/T

% si troncano i vettori che rappresentano i valori di Z e f
maxfrequenzaNormalizzata=3.0;
Z=Z(abs(frequenzaNormalizzata)<=maxfrequenzaNormalizzata);
frequenzaNormalizzata=frequenzaNormalizzata(abs(frequenzaNormalizzata)<=maxfrequenzaNormalizzata);

% calcolo teorico
Zteorica_rect(frequenzaNormalizzata~=0)=sin(pi*frequenzaNormalizzata(frequenzaNormalizzata~=0))./(pi*frequenzaNormalizzata(frequenzaNormalizzata~=0));
Zteorica_rect(frequenzaNormalizzata==0)=1.0;
Zteorica=Zteorica_rect*T^2./(1+j*2*pi*frequenzaNormalizzata);


% disegno dei risultati
figure;
plot(frequenzaNormalizzata,abs(Zteorica),'b--', frequenzaNormalizzata,abs(Z),'r', 'LineWidth', 2);
grid on;
axis([-maxfrequenzaNormalizzata,maxfrequenzaNormalizzata, 0, 1.2]);
xlabel('frequenza normalizzata, f \cdot T ');
ylabel('Z(f) = X(f) \cdot Y(f)');
legend('teorica', 'approssimata');
titoloGrafico=sprintf('Spettro della convoluzione tra l''impulso rett. e l''espon. monolat.\n(T = %.1f s, E_{rect} = %.2f%%, E_{exp} = %.2f%%)', T, percentualeEnergiaRect, percentualeEnergiaExp);
tmp=title(titoloGrafico);
set(tmp,'FontSize',14);

