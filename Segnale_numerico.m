function  esercizio1(  )
%   Calcolo della densit√† spettrale di potenza di un segnale
%   aleatorio x(t)=\sum_i a[i] g(t-i*Ts) con 
%   g(t) impulso (rect o triang)
%   Ts Tempo di simbolo
%   a(i) sequenza codificata di N simboli 

close all; % chiude tutti i grafici aperti in matlab
% Modifico i font per i grafici.
set(0,'DefaultAxesFontName', 'Times')
set(0,'DefaultAxesFontSize', 14)
set(0,'DefaultTextFontname', 'Times')
set(0,'DefaultTextFontSize', 14)

%%Parametri

N= 1000;          % Numero di bit della sequenza b[n]
M= 50;             % Numero di realizzazioni per fare la media
tipo_di_impulso=1; % 1 rect: 2 triang

Ns=128;             % Numero di campioni per tempo di simbolo (potenza di 2)
Ts=1;               % [s] Tempo di simbolo
Tc=Ts/Ns;           % [s] Tempo di campionamento (risoluzione segnale analogico) 

f=0.5;             % Frazione di campioni per la valutazione della funzione di autocorrelazione troncata

P0=0.5;            % Probabilit√† che il bit sia zero
P1= 1-P0;          % Probabilit√† che il bit sia uno

Tw=N*Ts;          % [s] finestra temporale per il calcolo di x_T(t)
Nw=ceil(Tw/Tc);    % Numero di campioni di x_T(t)

tempo=linspace(1,N*Ts,N*Ns); % Indice di tempo per graficare il segnale nel tempo
tempok=linspace(1-N*f,N*f,N); % Indice di tempo discreto per graficare la funzione di autocorrelazione

%% Selezione impulso
if(tipo_di_impulso==1) % Impulso rettangolare
    g= rectpulse([1],Ns);
elseif(tipo_di_impulso==2) % Impulso triangolare
    g= tripuls((-0.5:1/Ns:0.5-1/Ns));
end

%% CODICE

for m=1:M  %% Ciclo sulle realizzazioni
    
    b(m,:) = rand(1,N) < P1; %% Genera sequenza random di N bit b[n] con circa P1 occorrenze di 1
    P1_sim=sum(b(m,:))/N     %% verifica la probabilit√† di avere P1 occorrenze di 1
    
    
    %% Codifica lineare   
    for i=1:N
        if(b(m,i)==0)
            a(m,i)=-1;
        elseif(b(m,i)==1)
            a(m,i)=1;
        end
    end
    
     %% generazione del segnale aleatorio codificato
    for i=1:N
        x(m,1+(i-1)*Ns: i*Ns)=a(m,i)*g;   
    end
    Tw=min(N*Ts,Tw); % prendo il minimo tra la finestra temporale prescelta e la durata di x(t)
   
   
    %% Grafico un esempio del segnale nel tempo
    if m==1
        plot(tempo,x)
        axis([1,50 -1.5, 1.5])
        title('Esempio di andamento del segnale aleatorio nel tempo');
        xlabel(' Tempo t [s]')
        ylabel(' x(t)');
        grid on;
    end
    
    
    %% MISURA DENSITA SPETTRALE METODO 1:
    
    x(m,Nw:end)=0; %Troncamento del segnale a Tw=Nw*Tc: zero padding
    lunghezzaFFT= 2^nextpow2(length(x(m,:)));  %% calcola la potenza di 2 pi√π grande del numero di campioni
   
    Xw(m,:)=fft(x(m,:),lunghezzaFFT)*Tc;  %% calcola la trasformata di Fourier
    Xw(m,:)=[Xw(m,lunghezzaFFT/2+1:lunghezzaFFT) Xw(m,1:lunghezzaFFT/2)]; %% Riordino i valori per calcolarne il modulo
    
    Sx(m,:)=(abs(Xw(m,:)).^2);
    frequenza=(1/Tc)*linspace(-0.5,0.5,lunghezzaFFT);  % Setto l'indice della frequenza per il grafico
    %% Grafico di un esempio della densit√† spettrale di potenza (una realizzazione)
    if m==1   
        figure;
        plot(frequenza,Sx(m,:)/Tw)
        xlim([-5,5])
        title('Esempio di densit‡ spettale di potenza per una realizzazione |X_T(f)|^2/Tw');
        xlabel(' Frequenza f [Hz]')
        ylabel(' |X_T(f)|^2 /T_W');
        grid on;
       
    end
    
end

%% calcolo della densit√† spettrale di potenza su M realizzazioni (approssimazione Valore atteso)
ESx=mean(Sx,1)/Tw; % Faccio la media su M realizzazioni per  approssimare il valore atteso
figure
plot(frequenza,ESx);
xlim([-5,5])
str = sprintf('Densit‡ spettale di Potenza   E[|X_T(f)|^2]/Tw  con m=%d realizzazioni',M);
title(str);
%title('Densit√† spettale di Potenza per  E[|Xw|^2]/Tw s ')
xlabel(' Frequenza f [Hz]')
ylabel(' E[|X_T(f)|^2] /T_W');
grid on;
figure
semilogy(frequenza,ESx);
xlim([-5,5])
str = sprintf('Densit‡ spettale di Potenza   E[|X_T(f)|^2]/Tw  con m=%d realizzazioni',M);
title(str);
%title('Densit√† spettale di Potenza per  E[|Xw|^2]/Tw s ')
xlabel(' Frequenza f [Hz]')
ylabel(' E[|X_T(f)|^2] /T_W');
grid on;


  
%% CALCOLO DENSIT√Ä SPETTRALE DI POTENZA 2 metodo

m=1; % su una realizzazione

%% calcola funzione di autocorrelazione
Ra=xcorr(a(1,:),'biased')/M;
    for m=2:M
    Ra=Ra+xcorr(a(m,:),'biased')/M;  % 'biased' normalizza per il numero di campioni
end
Ra_x=(Ra(int32(N*f+1):int32(2*N- f*N))); % Tronco la funzione di autocorrelazione a 2*f*N campioni

%% grafico la funzione di autocorrelazione di a[n]
figure
plot(tempok,Ra_x);
xlim([-50,50]);
title('Funzione di Autocorrelazione R_a[k] della sequenza a[n] ')
xlabel(' Tempo discreto k ')
ylabel(' R_a[k]');
grid on;

%% calcolo la trasformata di Fourier
lunghezzaFFT= 2^nextpow2(length(Ra_x));
Sa=fft(Ra_x,lunghezzaFFT); % calcolo la densit‡†spettrale di potenza di Ra_x
mod_Sa_new=abs(Sa(:)); % serve dopo
Sa=[Sa(lunghezzaFFT/2+1:lunghezzaFFT) Sa(1:lunghezzaFFT/2)];
mod_Sa=abs(Sa(:)); % ne calcolo lo spettro
frequenza=(1/Ts)*linspace(-0.5,0.5,lunghezzaFFT);

figure
plot(frequenza,mod_Sa);
title('Densit‡ spettrale di Potenza S_a(f) ')
xlabel(' Frequenza f [Hz]')
ylabel(' S_a(f)');
grid on;


%% Calcolo la trasformata di Fourier di g(t) e la grafico

lunghezzaFFT2=lunghezzaFFT*Ns;
G=fft(g,lunghezzaFFT2)*Tc;
G=[G(lunghezzaFFT2/2+1:lunghezzaFFT2) G(1:lunghezzaFFT2/2)];

modG=abs(G(:));
frequenza=(1/Tc)*linspace(-0.5,0.5,lunghezzaFFT2);
figure
plot(frequenza,modG);
xlim([-5,5]);
title('Modulo della trasformata di fourier di g(t) ')
xlabel('frequenza f [Hz]')
ylabel(' |G(f)|');
grid on;

%% calcolo la densit√† spettrale di potenza
Sx_new=repmat(mod_Sa_new,Ns,1).*(modG.^2)/Ts;

figure
plot(frequenza,Sx_new);
xlim([-5,5]);
title('Densit‡ spettale di Potenza  S_a(f)|G(f)|^2/T ')
xlabel(' Frequenza f [Hz]')
ylabel(' S_x(f)');
grid on;





