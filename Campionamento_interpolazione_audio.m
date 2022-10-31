function Campionamento_interpolazione_audio

fCampionamentoCD=44.1e3;  % frequenza di campionamento qualit� CD [Hz]

fCampionamento=fCampionamentoCD/(4.0);  % frequenza di campionamento scelta [Hz] 
% come sottomultiplo intero di fCampionamentoCD


numeroCampioniCD=6000;  % numero di campioni (qualit� CD) del segnale originale
campioniInizio=12350;
campioniFine=18349;
[campioniCD,fc]=audioread('Music.wav',[campioniInizio, campioniFine]); %nuova versione da R2016
campioniCD=campioniCD(:,1); % solo canale sinistro
%wavwrite(campioniCD, fCampionamentoCD, 'Music_riferimento.wav');
audiowrite('Music_riferimento.wav',[campioniCD.',campioniCD.'],fCampionamentoCD);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Segnale di riferimento (grafici con sovracampionamento) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fattoreSovracampionamento=4;

tempo=(0:numeroCampioniCD-1)'; % supporto temporale segnale campionato

tempoInterpolazione=linspace(0,numeroCampioniCD-1/fattoreSovracampionamento,...
    numeroCampioniCD*fattoreSovracampionamento)'; % supporto temporale segnale interpolato

campioniUscita=sinc(tempoInterpolazione(:,ones(size(tempo)))-...
    tempo(:,ones(size(tempoInterpolazione)))')*campioniCD; % segnale interpolato

tempoInterpolazione=tempoInterpolazione/fCampionamentoCD;
 % normalizzazione del tempo di interpolazione

%%%%%%%%%%%
%% tempo %%
%%%%%%%%%%%

figure(12);
set(gcf,'defaultaxesfontname','Courier New')
hold on;
plot(tempoInterpolazione*1e3, campioniUscita, 'Color', 'black', 'LineWidth', 1.5);
tmp=xlabel('Tempo (ms)');
set(tmp,'FontSize',12);
tmp=ylabel('x(t)');
set(tmp,'FontSize',12);
grid on;
axis([0 18 -.40 .40]);

%figure(14);
%set(gcf,'defaultaxesfontname','Courier New')
%hold on;
%plot(tempoInterpolazione*1e3, campioniUscita, 'Color', 'black', 'LineWidth', 1.5);
%tmp=xlabel('Tempo (ms)');
%set(tmp,'FontSize',12);
%tmp=ylabel('x(t)');
%set(tmp,'FontSize',12);
%grid on;
%hold on;
%axis([1 7 -.40 .40]);

figure(15);
set(gcf,'defaultaxesfontname','Courier New')
hold on;
plot(tempoInterpolazione*1e3, campioniUscita, 'Color', 'black', 'LineWidth', 1.5);
tmp=xlabel('Tempo (ms)');
set(tmp,'FontSize',12);
tmp=ylabel('Segnali temporali');
set(tmp,'FontSize',12);
grid on;
hold on;
axis([1 7 -.40 .40]);

figure(17);
set(gcf,'defaultaxesfontname','Courier New')
hold on;
plot(tempoInterpolazione*1e3, campioniUscita, 'Color', 'black', 'LineWidth', 1.5);
tmp=xlabel('Tempo (ms)');
set(tmp,'FontSize',12);
tmp=ylabel('Segnali temporali');
set(tmp,'FontSize',12);
grid on;
hold on;
axis([1 7 -.40 .40]);

figure(19);
set(gcf,'defaultaxesfontname','Courier New')
hold on;
plot(tempoInterpolazione*1e3, campioniUscita, 'Color', 'black', 'LineWidth', 1.5);
tmp=xlabel('Tempo (ms)');
set(tmp,'FontSize',12);
tmp=ylabel('Segnali temporali');
set(tmp,'FontSize',12);
grid on;
hold on;
axis([1 7 -.40 .40]);

%%%%%%%%%%%%%%
% frequenza %%
%%%%%%%%%%%%%%
lunghezzaFft=8192*fattoreSovracampionamento;
X=fft(campioniUscita',lunghezzaFft);
X=[X(lunghezzaFft/2+1:lunghezzaFft) ...
    X(1:lunghezzaFft/2)]; % simmetria rispetto all'origine
frequenza=fCampionamentoCD*fattoreSovracampionamento*...
    linspace(-0.5,0.5-1/lunghezzaFft,lunghezzaFft); % supporto frequenziale

figure(13);
set(gcf,'defaultaxesfontname','Courier New')
hold on;
%plot(frequenza/1e3, abs(X), 'Color', 'black', 'LineWidth', 1.5);
plot(frequenza/1e3, 20*log10(abs(X)/abs(X(lunghezzaFft/2+1))), 'Color', 'black', 'LineWidth', 1.5);
tmp=xlabel('Frequenza (kHz)');
set(tmp,'FontSize',12);
tmp=ylabel('|X(f)| (dB)');
set(tmp,'FontSize',12);
grid on;
axis([0 15 -40 20]);

figure(16);
set(gcf,'defaultaxesfontname','Courier New')
hold on;
%plot(frequenza/1e3, abs(X), 'Color', 'black', 'LineWidth', 1.5);
plot(frequenza/1e3, 20*log10(abs(X)/abs(X(lunghezzaFft/2+1))), 'Color', 'black', 'LineWidth', 1.5);
tmp=xlabel('Frequenza (kHz)');
set(tmp,'FontSize',12);
tmp=ylabel('Spettri di ampiezza (dB)');
set(tmp,'FontSize',12);
grid on;
hold on;
%axis([0 15 0 2.5e-3]);
axis([0 15 -40 20]);

figure(18);
set(gcf,'defaultaxesfontname','Courier New')
hold on;
%plot(frequenza/1e3, abs(X), 'Color', 'black', 'LineWidth', 1.5);
plot(frequenza/1e3, 20*log10(abs(X)/abs(X(lunghezzaFft/2+1))), 'Color', 'black', 'LineWidth', 1.5);
tmp=xlabel('Frequenza (kHz)');
set(tmp,'FontSize',12);
tmp=ylabel('Spettri di ampiezza (dB)');
set(tmp,'FontSize',12);
grid on;
hold on;
%axis([0 15 0 2.5e-3]);
axis([0 15 -40 20]);

figure(8);
set(gcf,'defaultaxesfontname','Courier New')
hold on;
%plot(frequenza/1e3, abs(X), 'Color', 'black', 'LineWidth', 1.5);
plot(frequenza/1e3, (abs(X)/abs(X(lunghezzaFft/2+1))), 'Color', 'black', 'LineWidth', 1.5);
tmp=xlabel('Frequenza (kHz)');
set(tmp,'FontSize',12);
tmp=ylabel('Spettri di ampiezza');
set(tmp,'FontSize',12);
grid on;
hold on;
%axis([0 15 0 2.5e-3]);
axis([0 15 -1 15]);


figure(20);
set(gcf,'defaultaxesfontname','Courier New')
hold on;
%plot(frequenza/1e3, abs(X), 'Color', 'black', 'LineWidth', 1.5);
plot(frequenza/1e3, 20*log10(abs(X)/abs(X(lunghezzaFft/2+1))), 'Color', 'black', 'LineWidth', 1.5);
tmp=xlabel('Frequenza (kHz)');
set(tmp,'FontSize',12);
tmp=ylabel('Spettri di ampiezza (dB)');
set(tmp,'FontSize',12);
grid on;
hold on;
%axis([0 15 0 2.5e-3]);
axis([0 15 -40 20]);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     SEGNALE CAMPIONATO e SUCCESSIVA INTERPOLAZIONE    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rapporto=fCampionamentoCD/fCampionamento;

tempo=(0:numeroCampioniCD/rapporto-1)'; % supporto temporale segnale campionato

x=reshape(campioniCD,rapporto,numeroCampioniCD/rapporto); 
x=(x(1,:))'; % selezione campioni

figure(14);
plot(tempo/fCampionamento*1e3, x, 'o', 'Color', 'cyan', 'LineWidth', 1.5);


fattoreSovracampionamento=fattoreSovracampionamento*rapporto; % nuovo fattore di sovracampionamento

tempoInterpolazione=linspace(0,numeroCampioniCD/rapporto-1/fattoreSovracampionamento,...
    numeroCampioniCD/rapporto*fattoreSovracampionamento)'; % supporto temporale segnale interpolato

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INTERPOLAZIONE CARDINALE SEGNALE CAMPIONATO %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xInterpolatoreCardinale=sinc(tempoInterpolazione(:,ones(size(tempo)))-...
    tempo(:,ones(size(tempoInterpolazione)))')*x;
 % segnale interpolato
tempoInterpolazione=tempoInterpolazione/fCampionamento;
 % normalizzazione del tempo di interpolazione

%wavwrite(xInterpolatoreCardinale, fCampionamento*fattoreSovracampionamento, 'Music_Int_card.wav');
audiowrite('Music_Int_card.wav',[xInterpolatoreCardinale.',xInterpolatoreCardinale.'],fCampionamento*fattoreSovracampionamento);

%%%%%%%%%%%
%% tempo %%
%%%%%%%%%%%
figure(15);
plot(tempoInterpolazione*1e3, xInterpolatoreCardinale, 'Color', 'cyan', 'LineWidth', 1.5);
plot(tempo/fCampionamento*1e3, x, 'o', 'Color', 'cyan', 'LineWidth', 1.5);
legend('x(t)','x_{IC}(t)');

%%%%%%%%%%%%%%%
%% frequenza %%
%%%%%%%%%%%%%%%
lunghezzaFft=8192*fattoreSovracampionamento/rapporto;
X=fft(xInterpolatoreCardinale',lunghezzaFft);
X=[X(lunghezzaFft/2+1:lunghezzaFft) ...
    X(1:lunghezzaFft/2)]; % simmetria rispetto all'origine
frequenza=fCampionamento*fattoreSovracampionamento*...
    linspace(-0.5,0.5-1/lunghezzaFft,lunghezzaFft); % supporto frequenziale

figure(16);
plot(frequenza/1e3, 20*log10(abs(X)/abs(X(lunghezzaFft/2+1))), 'Color', 'cyan', 'LineWidth', 1.5);
legend('|X(f)|','|X_{IC}(f)|');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INTERPOLAZIONE A MANTENIMENTO %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xInterpolatoreMantenimento=repmat(x',fattoreSovracampionamento,1);
xInterpolatoreMantenimento=...
    reshape(xInterpolatoreMantenimento,...
    size(xInterpolatoreMantenimento,1)*...
    size(xInterpolatoreMantenimento,2),1);

%wavwrite(xInterpolatoreMantenimento, fCampionamento*fattoreSovracampionamento, 'Music_Int_mant.wav');
audiowrite('Music_Int_mant.wav',[xInterpolatoreMantenimento.',xInterpolatoreMantenimento.'],fCampionamento*fattoreSovracampionamento);

%%%%%%%%%%%
%% tempo %%
%%%%%%%%%%%
figure(17);
plot((tempoInterpolazione+1/(fCampionamento*fattoreSovracampionamento))*1e3, ...
    xInterpolatoreMantenimento, 'Color', 'cyan', 'LineWidth', 1.5);
plot(tempo/fCampionamento*1e3, x, 'o', 'Color', 'cyan', 'LineWidth', 1.5);
legend('x(t)','x_{S&H}(t)');

%%%%%%%%%%%%%%%
%% frequenza %%
%%%%%%%%%%%%%%%
lunghezzaFft=8192*fattoreSovracampionamento/rapporto;
X=fft(xInterpolatoreMantenimento',lunghezzaFft);
X=[X(lunghezzaFft/2+1:lunghezzaFft) ...
    X(1:lunghezzaFft/2)]; % simmetria rispetto all'origine
frequenza=fCampionamento*fattoreSovracampionamento*...
    linspace(-0.5,0.5-1/lunghezzaFft,lunghezzaFft); % supporto frequenziale

figure(18);
plot(frequenza/1e3, 20*log10(abs(X)/abs(X(lunghezzaFft/2+1))), 'Color', 'cyan', 'LineWidth', 1.5);
legend('|X(f)|','|X_{S&H}(f)|');

figure(8);
plot(frequenza/1e3, (abs(X)/abs(X(lunghezzaFft/2+1))), 'Color', 'cyan', 'LineWidth', 1.5);
legend('|X(f)|','|X_{S&H}(f)|');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FILTRAGGIO PASSA-BASSO dopo INTERPOLATORE A MANT. %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
B=fCampionamento/2; % banda del filtro [Hz]
numeroCodeFiltro=10; % code della sinc (risposta impulsiva del filtro)
tempoFiltro=-numeroCodeFiltro/(2*B):1/(fCampionamento*fattoreSovracampionamento):numeroCodeFiltro/(2*B);
h=2*B*sinc(2*B*tempoFiltro)/(fCampionamento*fattoreSovracampionamento);
tmp=conv(xInterpolatoreMantenimento,h');
xInterpolatoreMantenimento=tmp((length(h)-1)/2+4:(length(h)-1)/2+4+length(xInterpolatoreMantenimento)-1);

%wavwrite(xInterpolatoreMantenimento, fCampionamento*fattoreSovracampionamento, 'Music_Int_mant_fil.wav');
audiowrite('Music_Int_mant_fil.wav',[xInterpolatoreMantenimento.',xInterpolatoreMantenimento.'],fCampionamento*fattoreSovracampionamento);

%%%%%%%%%%%
%% tempo %%
%%%%%%%%%%%
figure(19);
plot((tempoInterpolazione+1/(fCampionamento*fattoreSovracampionamento))*1e3, ...
    xInterpolatoreMantenimento, 'Color', 'cyan', 'LineWidth', 1.5);
plot(tempo/fCampionamento*1e3, x, 'o', 'Color', 'cyan', 'LineWidth', 1.5);
legend('x(t)','x_{S&H+LPF}(t)');

%%%%%%%%%%%%%%%
%% frequenza %%
%%%%%%%%%%%%%%%
lunghezzaFft=8192*fattoreSovracampionamento/rapporto;
X=fft(xInterpolatoreMantenimento',lunghezzaFft);
X=[X(lunghezzaFft/2+1:lunghezzaFft) ...
    X(1:lunghezzaFft/2)]; % simmetria rispetto all'origine
frequenza=fCampionamento*fattoreSovracampionamento*...
    linspace(-0.5,0.5-1/lunghezzaFft,lunghezzaFft); % supporto frequenziale

figure(20);
plot(frequenza/1e3, 20*log10(abs(X)/abs(X(lunghezzaFft/2+1))), 'Color', 'cyan', 'LineWidth', 1.5);
legend('|X(f)|','|X_{S&H+LPF}(f)|');





