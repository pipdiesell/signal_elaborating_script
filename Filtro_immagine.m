    function Filtro_immagine(sigma_h)

if nargin<1 % il numero degli input � insufficiente
    sprintf('Sintassi: Filtro_immagine(sigma_h)')
    return;
end

x=imread('Lena','tif'); % lettura dell�immagine
figure(1); imshow(x);
set(gcf,'defaultaxesfontname','Courier New')
tmp=title('Immagine originale');
set(tmp,'FontSize',12);

%% Filtraggio passa-basso
h1=fspecial('gaussian',3*sigma_h,sigma_h); % risposta impulsiva del filtro passa-basso https://it.mathworks.com/help/images/ref/fspecial.html
y1=imfilter(x,h1); % filtraggio passa-basso
figure(2); imshow(y1);
set(gcf,'defaultaxesfontname','Courier New')
tmp=title('Immagine elaborata con il filtro passa-basso');
set(tmp,'FontSize',12);
imwrite(y1,'Lena_lp.tif','tif');

%% Filtraggio passa-alto
z1=x-y1;% filtraggio passa-alto
imwrite(z1,'Lena_hp.tif','tif');
figure(3); imshow(z1);
set(gcf,'defaultaxesfontname','Courier New')
tmp=title('Immagine elaborata con il filtro passa-alto');
set(tmp,'FontSize',12);
%% Negativo e estrazione di contorno
quadratoBianco=255*ones(size(x),'uint8');
y2=quadratoBianco-2*z1;
figure(4); imshow(y2);
set(gcf,'defaultaxesfontname','Courier New')
tmp=title('Immagine elaborata con filtro negativo');
imwrite(y2,'Lena_neg.tif','tif');
