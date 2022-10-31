function Filtro_audio


%% Lettura campioni
filename='Music.wav';
fCampionamento = 44.1e3; % [Hz]: frequenza di campionamento (dipende dal file sorgente - CD: 44.1 kHz)
durata = 4; % [s]: durata del segnale audio (dipende dal file sorgente)

tempoCampionamento = 1/fCampionamento; % tempo di campionamento
numeroCampioni = durata * fCampionamento; % numero totale di campioni
%xstereo = wavread(filename, numeroCampioni); % canali sinistro + destro (segnale stereo)
[xstereo,fc]=audioread(filename,[1,numeroCampioni]); %nuova versione da R2016
x = (xstereo(:,1))'; % solo canale sinistro

%% Filtro passabanda ideale
B=3.0e3; % ampiezza di banda [Hz]   
f0=2.0e3; % frequenza centrale [Hz]
T=50/B; % durata risposta impulsiva [s]
tempoFiltro=0:tempoCampionamento:T;
g=2*B*sinc(B*(tempoFiltro-T/2)).*rectpuls((tempoFiltro-T/2)/T).*cos(2*pi*f0*(tempoFiltro-T/2));


%% Uscita filtrata
w=conv(g,x)*tempoCampionamento;
w=w(length(g):length(w));

tempo=0:tempoCampionamento:durata-tempoCampionamento;
tempoW=tempo(1:length(w))+T/2;

figure;
durataTransitorio=0.0250; % [s]
A=5; % amplificazione
set(gcf,'defaultaxesfontname','Courier New')
plot((tempo-durataTransitorio)*1e3, x, 'Color', 'cyan', 'LineWidth', 2.5);
hold on;
plot((tempoW-durataTransitorio)*1e3, A*w, 'Color', 'black', 'LineWidth', 1.5);
grid on;
tmp=xlabel('Tempo (ms)');
set(tmp,'FontSize',12);
tmp=ylabel('Segnali temporali');
set(tmp,'FontSize',12);
temp=legend('x(t)', 'A\cdot{w(t)}');
set(tmp,'FontSize',10);
axis([0 20 -1.2*max(abs(x)) 1.2*max(abs(x)) ]);


%% Calcolo della trasformata di Fourier dell'ingresso
lunghezzaFft=2^nextpow2(length(x));
X=fft(x,lunghezzaFft)*tempoCampionamento;
X=[X(lunghezzaFft/2+1:lunghezzaFft) X(1:lunghezzaFft/2)];
frequenza=fCampionamento*linspace(-0.5,0.5,lunghezzaFft);

%% Calcolo della trasformata di Fourier dell'uscita
lunghezzaFft=2^nextpow2(length(w));
W=fft(w,lunghezzaFft)*tempoCampionamento;
W=[W(lunghezzaFft/2+1:lunghezzaFft) W(1:lunghezzaFft/2)];
frequenza=fCampionamento*linspace(-0.5,0.5,lunghezzaFft);

figure;
set(gcf,'defaultaxesfontname','Courier New')
plot(frequenza/1e3,abs(X), 'Color', 'cyan', 'LineWidth', 1.5);
hold on;
plot(frequenza/1e3,abs(W), 'Color', 'black', 'LineWidth', 1.5);
grid on;
tmp=xlabel('Frequenza (kHz)');
set(tmp,'FontSize',12);
tmp=ylabel('Spettro di ampiezza');
set(tmp,'FontSize',12);
temp=legend('|X(f)|', '|W(f)|');
set(tmp,'FontSize',10);
axis([0 8 0 1.2*max(abs(W))]);

%wavwrite(w*0.99/max(abs(w)), fCampionamento, 'Music_filtro.wav');
audiowrite('Output_filtro.wav',[w.'*0.99/max(abs(w)),w.'*0.99/max(abs(w))],fCampionamento);

