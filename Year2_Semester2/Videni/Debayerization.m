img = double(imread('mandi.tif'));
[sizeX, sizeY] = size(img);

% Výsledek bude tensor sizeX x sizeY x 3, kde na každé pozici budou hodnoty
% R G B
output = zeros(sizeX,sizeY,3);

% Chci pro každou 3x3 část vytvořit 3x1 vektor se zprůměrovanými barvami,
% což půjde implementovat maticovým násobením vhodnou maticí sestavenou
% podle toho, v jakém místě bayerovy mřížky jsme - to jsou čtyři možnosti
% proto 4 matice

averagingMatrixR = [
    0    0    0    0    1    0    0    0    0;
    0    0.25 0    0.25 0    0.25 0    0.25 0;
    0.25 0    0.25 0    0    0    0.25 0    0.25
];

averagingMatrixG1 = [
    0    0.5  0    0    0    0    0    0.5  0;
    0.2  0    0.2  0    0.2  0    0.2  0    0.2;
    0    0    0    0.5  0    0.5  0    0    0 
];


averagingMatrixG2 = [
    0    0    0    0.5  0    0.5  0    0    0 ;
    0.2  0    0.2  0    0.2  0    0.2  0    0.2;
    0    0.5  0    0    0    0    0    0.5  0
];

averagingMatrixB = [
    0.25 0    0.25 0    0    0    0.25 0    0.25;
    0    0.25 0    0.25 0    0.25 0    0.25 0;
    0    0    0    0    1    0    0    0    0
];

% Nyní projdu celý obrázek vyjma jedno pixelu na okrajích, což je
% zjednodušení abych nemusel psát speciální případy pro všechny typy okraje

for i = 2:sizeX-1
    for j = 2:sizeY-1
        % Vybírám postupně podmatice okolo bodu i,j a přelévám je do 1D
        % vektoru, což se mi hodí k maticovému násobení s připravenými
        % průměrovacími maticemi
        selected_square = img(i-1:i+1, j-1:j+1);
        selected_square_in_row = reshape(selected_square,1, []);
        
        % Na základě pozice (Bayerova mřížka se opakuje s periodou 2 na
        % obou osách) násobím příslušnou průměrovací maticí
        if mod(i,2) == 0 && mod(j,2) ==0
            color_vec = selected_square_in_row * transpose(averagingMatrixR);
        elseif mod(i,2) == 0 && mod(j,2) == 1
            color_vec = selected_square_in_row * transpose(averagingMatrixG1);
        elseif mod(i,2) == 1 && mod(j,2) == 0
            color_vec = selected_square_in_row * transpose(averagingMatrixG2);
        elseif mod(i,2) == 1 && mod(j,2) == 1
            color_vec = selected_square_in_row * transpose(averagingMatrixB);
        end      
        
        for k = 1:3
            output(i,j,k) = color_vec(k);
        end
    end
end

% Své řešení mohu porovnat se zabudovanou funkcí demosaic:
builtin_solution = demosaic(imread('mandi.tif'),'rggb');
imshow(uint8(output));

% imshow(builtin_solution);
