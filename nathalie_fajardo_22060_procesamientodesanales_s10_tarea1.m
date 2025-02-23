%% Parte 4 Inciso a
[x1, fs] = audioread('beat.wav');
[x2, fs] = audioread('bass.wav'); 
%sound(x1,0.5*fs); a esta frecuencia la señal se escucha con ruido y no tan
%precisa como con la frecuencia original.
%sound(x1,0.75*fs); hay partes del sonido que se corta, no se logra
%escuchar todos los armónicos como en la señal original.
%sound(x1,1.5*fs); La señal se escuhca casi igual a la primera,
%probablemente un poco más rápida.
%sound(x1,2*fs); a esta frecuencia la señal logra escucharse claramente
%pero más rápida.

% Inciso B

%para que suenen igual se aplica un alfa que ayude a que la suma de ambas
%señales esté entre [-1,1]. a+b=1
a=0.5;
b=1-a;
xmix=a*x1+b*x2;

%sound(xmix,fs);

%Inciso C

%Para escuchar más la batería que los bajos únicamente se cambian los
%valores de a y b.
a=0.7;%a corresponde a los beats
b=1-a;
xmix1=a*x1+b*x2;

t=tiledlayout(2,2);
nexttile;
plot(x1);
title('BEAT');
legend('Left','Right');

nexttile;
plot(x2);
title('BASS');
legend('Left','Right');

nexttile;
xl=xmix(:,1);
plot(xl,'yellow');
title('Mixer Left');

nexttile;
xr=xmix(:,2);
plot(xr,'cyan');
title('Mixer Right');

%% Inciso d

%Procesamiento de señales S10
%Nathalie Fajardo, 22020

[x3, fs] = audioread('harmony.wav');
N = length(harmony);%Se toma el largo de harmony para ajustar la longitud 
% de beat y bass, esto con indexación del modulo (mod)
x1 = x1(mod(0:N-1, length(x1)) + 1, :); %esto hará cycling para las 
% señales que se ecnuentran fuera del rango
x2 = x2(mod(0:N-1, length(x2)) + 1, :);

a=0.3;
b=0.2;
c=0.5;

xmix2=a*x1+b*x2+c*x3;

%% Inciso e

%Procesamiento de señales S10
%Nathalie Fajardo, 22020

[x1, fs] = audioread('beat.wav');
[x2, fs] = audioread('bass.wav'); 
[x3, fs] = audioread('harmony.wav');

N = length(x3);%Se toma el largo de harmony para ajustar la longitud 
% de beat y bass, esto con indexaci[on del modulo (mod)
x1 = x1(mod(0:N-1, length(x1)) + 1, :); %esto hará cycling para las 
% señales que se ecnuentran fuera del rango
x2 = x2(mod(0:N-1, length(x2)) + 1, :);

%señal lineal
linear_fade= linspace(0,1,N)'; %se toma la transpuesta para que no ocurran
%errores de dimensiones, puesto que harmony es un vector de dos columnas,
%se necesita un vector columna.
x3=x3.*linear_fade; %se le aplica la señal lineal a harmony

a=0.1;
b=0.4;
c=0.5;
xmix3=a*x1+b*x2+c*x3;

t=tiledlayout(3,1);
nexttile;
plot(linear_fade,'red');
title('Señal lineal')
nexttile;
plot(x3,'green');
title('Harmony  con efecto "Fade-in"')
nexttile
plot(xmix3)
title('mixer')
sound(xmix3,fs);

%% Parte 5

load('ecg_data.mat')
N=length(ecg_noisy);

t=tiledlayout(4,1);
nexttile
plot(ecg);
title('ECG')
nexttile
plot(ecg_noisy);
title('ECG Noisy')
%frecuencia
f=(0:N-1)*(fs/N);

%Fourier
fft_ecgnoisy=fft(ecg_noisy);

%magnitud
mag_ecgnoisy=mag2db(abs(fft_ecgnoisy));

%Graficamos para observar en qué frecuencias hay ruido
nexttile
plot(f,mag_ecgnoisy);
xlabel('Frecuencia');
ylabel('Magnitud');
title('Ruido')
xlim([0 fs/2]);
hold on


%Luego de ver la imagen, los picos empiezan a aparecer a partir de 400 Hz y
%teminan en 40KHz.

noise_band = [40 40000];
freq_idx = f > noise_band(1) & f < noise_band(2);

%se limpia las frecuencias pico, que son parte del ruido
fft_ecgnoisy(freq_idx)=0;
ecg_noisy=ifft(fft_ecgnoisy);

%Aseguramos que sea la parte del dominio real
ecg_noisy = real(ecg_noisy);

nexttile
plot(ecg_noisy);
title('limpia');