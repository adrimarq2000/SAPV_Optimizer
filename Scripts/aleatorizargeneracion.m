function [genrand,ON_OFF] = aleatorizargeneracion(generacion,TTF,TTR)
    %%Aleatorizar la generación de energía
    genrand = zeros(8760,1);
    diasmes= [30,31,30,31,31,30,31,30,31,31,28,31]; %considerando que los datos comienzan en abril
    ref=0;
    for mes = 1:12
        for d = 1:diasmes(mes)
            rnd(d)=rand;
        end
        [~,p]=sort(rnd, 'descend');
        rank = 1:length (rnd);
        rank(p) = rank;
        for d = 1:diasmes(mes)
            for h = 1:24
                horadata=24*(rank(d)-1)+h;
                horagen=(ref*24)+(24*(d-1))+h;
                genrand(horagen) = generacion(horadata,mes);
            end
        end
        ref=ref+diasmes(mes);
        clear rnd;
        clear rank;
    end
    %% Aleatorizar la disponibilidad de fotovoltaica
    pos= int8(100*rand);
    ttf0=TTF(pos);
    modo = 1;
    nf = 0;
    n = 1;
    ni = 1;
    ON_OFF(n)=1;
    n=n+1;
    while n<=8760
        if modo == 1
            if (ni<ttf0 || (ON_OFF(n-1)==0 && ni >=ttf0))
                ON_OFF(n)=1;
                ni = ni + 1;
                n = n + 1;
            else
                modo = 0;
                ttr0 = TTR(pos + nf);
                ni=0;
            end
        elseif modo == 0
            if ni < ttr0
                ON_OFF(n)=0;
                ni = ni + 1;
                n = n + 1;
            else
                modo = 1;
                nf = nf + 1;
                ttf0 = TTF(pos + nf);
                ni = 0;
            end
        end
    end
    ON_OFF = transpose(ON_OFF);
end

