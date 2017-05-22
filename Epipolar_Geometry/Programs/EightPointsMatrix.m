function matrix=EightPointsMatrix(X,Y,XP,YP)
matrix=[];
for t=1:8
    result=IndividualRowEquation(X(t), Y(t), XP(t), YP(t));
    matrix=[matrix;result];
end
end
