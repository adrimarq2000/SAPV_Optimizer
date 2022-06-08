for i= 1:30
    auxX=particle(i).HistoricPosX;
    auxY=particle(i).HistoricPosY;
    for j =1:20
        graficaIter(i,2*j-1)=auxX(j);
        graficaIter(i,2*j)=auxY(j);
    end
end

for i= 1:30
    graficaIndiv(3*i-2,:)=particle(i).HistoricPosX;
    graficaIndiv(3*i-1,:)=particle(i).HistoricPosY;
end
