function [w] = SW( imageMatrix, Col, Row, size, scale)
width = scale * size; %width
width = width - 1; 
w = imageMatrix(:,Col:Col+width);  
w = w(Row:Row+size-1,:);
end


