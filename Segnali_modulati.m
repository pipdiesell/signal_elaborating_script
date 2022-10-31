function Segnali_modulati

Npunti=1000;
Durata=100; %durata della finestra temporale per la trasformata

tempo=0:(1/Npunti):Durata-1/Npunti;
x= 1*(sign(tempo)-sign(tempo-0.5))*0.5-(1-abs((tempo-0.75)/0.25)).*(sign(tempo-0.5)-sign(tempo-1))*0.5+0*(sign(tempo-1)+1)*0.5;

V0=10; % ampiezza portante 
f0=30; % frequenza normalizzata portante
KA=0.5;
KP=(2*pi*3.5);
KF=15;

sAM= V0*(1+KA*x).*cos(2*pi*f0*tempo);
sPM= V0*cos(2*pi*f0*tempo+KP*x);
for i=0:1:Npunti*Durata-1 
    y(i+1)=sum(x(1:i+1))*1/Npunti; 
end % integrale approssimato del segnale modulante
sFM= V0*cos(2*pi*f0*tempo+(2*pi*KF)*y);

figure;
plot(tempo,x);
tmp=xlabel('Tempo (normalizzato)');
set(tmp,'FontSize',12);
tmp=ylabel('x(t)');
set(tmp,'FontSize',12);
grid on;
axis([0 1 -1.5 1.5]);

figure;
plot(tempo,sAM);
tmp=xlabel('Tempo (normalizzato)');
set(tmp,'FontSize',12);
tmp=ylabel('s_{AM}(t)');
set(tmp,'FontSize',12);
grid on;
axis([0 1 -20 20]);

figure;
plot(tempo,sPM);
tmp=xlabel('Tempo (normalizzato)');
set(tmp,'FontSize',12);
tmp=ylabel('s_{PM}(t)');
set(tmp,'FontSize',12);
grid on;
axis([0 1 -20 20]);

figure;
plot(tempo,sFM);
tmp=xlabel('Tempo (normalizzato)');
set(tmp,'FontSize',12);
tmp=ylabel('s_{FM}(t)');
set(tmp,'FontSize',12);
grid on;
axis([0 1 -20 20]);

% trasformata di fourier x(t)
%lunghezzaFft=2^(nextpow2(length(x))+1);
lunghezzaFft=length(x);
X=fft(x,lunghezzaFft)*(1/Npunti);
X=[X(lunghezzaFft/2+1:lunghezzaFft) X(1:lunghezzaFft/2)];
frequenza=Npunti*linspace(-0.5,0.5-1/lunghezzaFft,lunghezzaFft);
figure;
plot(frequenza,abs(X));
tmp=xlabel('Frequenza (normalizzata)');
set(tmp,'FontSize',12);
tmp=ylabel('|X(f)|');
set(tmp,'FontSize',12);
grid on;
axis([-10 10 0 1.2*max(abs(X))]);

% trasformata di fourier sAM(t)
lunghezzaFft=length(sAM);
S=fft(sAM,lunghezzaFft)*(1/(Npunti));
S=[S(lunghezzaFft/2+1:lunghezzaFft) S(1:lunghezzaFft/2)];
frequenza=Npunti*linspace(-0.5,0.5-1/lunghezzaFft,lunghezzaFft);
figure;
plot(frequenza,abs(S));
tmp=xlabel('Frequenza (normalizzata)');
set(tmp,'FontSize',12);
tmp=ylabel('|S_{AM}(f)|');
set(tmp,'FontSize',12);
grid on;
axis([-50 50 0 5]);

% trasformata di fourier sPM(t)
lunghezzaFft=length(sPM);
S=fft(sPM,lunghezzaFft)*(1/Npunti);
S=[S(lunghezzaFft/2+1:lunghezzaFft) S(1:lunghezzaFft/2)];
frequenza=Npunti*linspace(-0.5,0.5-1/lunghezzaFft,lunghezzaFft);
figure;
plot(frequenza,abs(S));
tmp=xlabel('Frequenza (normalizzata)');
set(tmp,'FontSize',12);
tmp=ylabel('|S_{PM}(f)|');
set(tmp,'FontSize',12);
grid on;
axis([-60 60 0 5]);

% trasformata di fourier sFM(t)
lunghezzaFft=length(sFM);
S=fft(sFM,lunghezzaFft)*(1/Npunti);
S=[S(lunghezzaFft/2+1:lunghezzaFft) S(1:lunghezzaFft/2)];
frequenza=Npunti*linspace(-0.5,0.5-1/lunghezzaFft,lunghezzaFft);
figure;
plot(frequenza,abs(S));
tmp=xlabel('Frequenza (normalizzata)');
set(tmp,'FontSize',12);
tmp=ylabel('|S_{FM}(f)|');
set(tmp,'FontSize',12);
grid on;
axis([-60 60 0 5]);

