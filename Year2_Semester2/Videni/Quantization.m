image = imread('onion.png');
nOfColors = 16;

% Vstupní bod - zde se volá hlavní funkce median_cut
pallete = median_cut(image,nOfColors);

% Zobrazení indexovaného obrázku s vytvořenou paletou
imshow(rgb2ind(image, pallete), pallete);

% Můj median cut funguje pouze s počty barev, které jsou mocninami dvojky,
% šlo by udělat i obecnější řešení, ale už tak jsem se s tímto v MatLabu
% docela zapotil.
function [reduced_pallette]=median_cut(img, nOfColors)   
    [sizeX, sizeY, sizeZ] = size(img);
    all_colors = reshape(img,[sizeX*sizeY,sizeZ]);
    
    % Full pallette obsahuje všechny unikátní barvy obrázku
    full_pallette = double(unique(all_colors, "rows")) ./ 256;
        
    if size(full_pallette,1) < nOfColors
        reduced_pallette = full_pallette;
    else
        % Obrázek rozdělím do kanálů R,G,B
        R = transpose(reshape(img(:,:,1), 1, []));
        G = transpose(reshape(img(:,:,2), 1, []));
        B = transpose(reshape(img(:,:,3), 1, [])); 
        
        % Zde by mi bylo přirozené použít nějakou dynamičtější datovou
        % strukturu, nic takového se mi nepodařilo najít, tak jsem na
        % základě rady spolužáka použil cell array
        nOfIterations = log2(nOfColors);
        quantization_sets = cell(1);
        quantization_sets{1} = [R, G, B];
        
        for i=1:nOfIterations
            new_sets = cell(2^i, 1);
            for j=1:numel(quantization_sets)
                
                R = quantization_sets{j,1}(:,1);
                G = quantization_sets{j,1}(:,2);
                B = quantization_sets{j,1}(:,3);
                
                % Šířky barevných kanálů - tedy jak široké jsou v prostoru
                % barev, což je informace potřebná k správnému rozdělení
                R_width = max(R) - min(R);
                G_width = max(G) - min(G);
                B_width = max(B) - min(B);
                
                left = int16.empty;
                right = int16.empty;
                
                % Potřebuji vybrat nejširší kanál a v něm rozhodit barvy
                % podle mediánu na menší (do arraye left) a na větší (do
                % arraye right)
                
                if (R_width > G_width && R_width > B_width)
                    R_median = median(R);
                    for k=1:numel(R)
                        selected_color = quantization_sets{j,1}(k,:);
                        if selected_color(1) > R_median
                            left = [left; selected_color];
                        else
                            right = [right; selected_color];
                        end
                    end
                elseif (G_width > R_width && G_width > B_width)
                    G_median = median(G);
                    for k=1:numel(G)
                        selected_color = quantization_sets{j,1}(k,:);
                        if selected_color(2) > G_median
                            left = [left; selected_color];
                        else
                            right = [right; selected_color];
                        end
                    end
                else
                    B_median = median(B);
                    for k=1:numel(B)
                        selected_color = quantization_sets{j,1}(k,:);
                        if selected_color(3) > B_median
                            left = [left; selected_color];
                        else
                            right = [right; selected_color];
                        end
                    end
                end
                % Nakonec jen přiřadím barvy rozdělené podle mediánu do
                % dvou nových oddílů kvantizace
                new_sets{2*j-1, 1} = left;
                new_sets{2*j, 1} = right;
            end       
            quantization_sets = new_sets;
        end
        
        % Ve chvíli kdy máme správně rozřazené barvy do kvantizačních
        % kastlíků, tak musíme každému kastlíku určit barvu, na kterou se
        % zobrazí funkcí Q(x)
        
        temp_pallette = zeros(nOfColors, 3);
        for i=1:numel(quantization_sets)
            R_mean = mean(quantization_sets{i,1}(:,1));
            G_mean = mean(quantization_sets{i,1}(:,2));
            B_mean = mean(quantization_sets{i,1}(:,3));
            temp_pallette(i,:) = [R_mean, G_mean, B_mean];
        end
        reduced_pallette = double(temp_pallette) ./ 256;
    end 
end