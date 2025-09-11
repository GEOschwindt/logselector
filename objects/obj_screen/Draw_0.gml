///DESENHAR INPUTS

draw_set_color(c_gray);
draw_rectangle(0, 0, room_width, room_height, false);

draw_set_color(c_black);
draw_set_font(-1);
draw_text(50, 30, "LOG SELECTOR");

draw_set_color(selectInputPathLogs ? selectedBorderColor : borderColor);
draw_rectangle(inputPathLogsX, inputPathLogsY, room_width - inputPathLogsX, inputPathLogsY + inputHeight, false);
draw_set_color(backgroundColor);
draw_rectangle(inputPathLogsX + 2, inputPathLogsY + 2, room_width - inputPathLogsX - 2, inputPathLogsY + inputHeight - 2, false);

draw_set_color(textColor);
draw_text(inputPathLogsX + 5, inputPathLogsY + 5, "Path Logs: " + inputPathLogs);

draw_set_color(selectInputPathSave ? selectedBorderColor : borderColor);
draw_rectangle(inputPathSaveX, inputPathSaveY, room_width - inputPathSaveX, inputPathSaveY + inputHeight, false);
draw_set_color(backgroundColor);
draw_rectangle(inputPathSaveX + 2, inputPathSaveY + 2, room_width - inputPathSaveX - 2, inputPathSaveY + inputHeight - 2, false);

draw_set_color(textColor);
draw_text(inputPathSaveX + 5, inputPathSaveY + 5, "Path Save: " + inputPathSave);

draw_set_color(selectInputReference ? selectedBorderColor : borderColor);
draw_rectangle(inputReferenceX, inputReferenceY, room_width - inputReferenceX, inputReferenceY + inputHeight, false);
draw_set_color(backgroundColor);
draw_rectangle(inputReferenceX + 2, inputReferenceY + 2, room_width - inputReferenceX- 2, inputReferenceY + inputHeight - 2, false);

draw_set_color(textColor);
draw_text(inputReferenceX + 5, inputReferenceY + 5, "Reference: " + inputReference);

if (selectInputPathLogs) {
    var cursorX = inputPathLogsX + 5 + string_width("Path Logs: " + inputPathLogs);
    var cursorY = inputPathLogsY + 5;
    draw_set_color(c_black);
    draw_line(cursorX, cursorY, cursorX, cursorY + 20);
}

if (selectInputPathSave) {
    var cursorX = inputPathSaveX + 5 + string_width("Path Save: " + inputPathSave);
    var cursorY = inputPathSaveY + 5;
    draw_set_color(c_black);
    draw_line(cursorX, cursorY, cursorX, cursorY + 20);
}

if (selectInputReference) {
    var cursorX = inputReferenceX + 5 + string_width("Reference: " + inputReference);
    var cursorY = inputReferenceY + 5;
    draw_set_color(c_black);
    draw_line(cursorX, cursorY, cursorX, cursorY + 20);
}

var hoverBuscar = (mouse_x >= buttonBuscarX && mouse_x <= buttonBuscarX + buttonWidth && 
                   mouse_y >= buttonBuscarY && mouse_y <= buttonBuscarY + buttonHeight);
draw_set_color(hoverBuscar ? buttonHoverColor : buttonColor);
draw_rectangle(buttonBuscarX, buttonBuscarY, buttonBuscarX + buttonWidth, buttonBuscarY + buttonHeight, false);
draw_set_color(borderColor);
draw_rectangle(buttonBuscarX, buttonBuscarY, buttonBuscarX + buttonWidth, buttonBuscarY + buttonHeight, true);
draw_set_color(textColor);
draw_text(buttonBuscarX + 10, buttonBuscarY + 8, "Buscar");

var hoverLimpar = (mouse_x >= buttonLimparX && mouse_x <= buttonLimparX + buttonWidth && 
                   mouse_y >= buttonLimparY && mouse_y <= buttonLimparY + buttonHeight);
draw_set_color(hoverLimpar ? buttonHoverColor : buttonColor);
draw_rectangle(buttonLimparX, buttonLimparY, buttonLimparX + buttonWidth, buttonLimparY + buttonHeight, false);
draw_set_color(borderColor);
draw_rectangle(buttonLimparX, buttonLimparY, buttonLimparX + buttonWidth, buttonLimparY + buttonHeight, true);
draw_set_color(textColor);
draw_text(buttonLimparX + 10, buttonLimparY + 8, "Limpar");

// DESENHAR JANELA DE RESULTADOS
if (array_length(jsonFilter) > 0) {
    // Criar ou atualizar surface se necessário
    if (surfaceNeedsUpdate || !surface_exists(resultsSurface)) {
        if (surface_exists(resultsSurface)) {
            surface_free(resultsSurface);
        }
        
        // Calcular altura total necessária para todos os resultados
        var totalHeight = 0;
        totalHeight += 25; // Título
        totalHeight += resultsPadding * 2; // Padding
        
        // Calcular altura de cada resultado
        for (var i = 0; i < array_length(jsonFilter); i++) {
            var jsonText = jsonFilter[i];
            var maxWidth = resultsWindowWidth - (resultsPadding * 2) - 40;
            
            if (string_width(jsonText) > maxWidth) {
                // Calcular quantas linhas serão necessárias
                var words = string_split(jsonText, " ");
                var currentLine = "";
                var lines = 1;
                
                for (var j = 0; j < array_length(words); j++) {
                    var testLine = currentLine + (currentLine == "" ? "" : " ") + words[j];
                    
                    if (string_width(testLine) > maxWidth && currentLine != "") {
                        currentLine = words[j];
                        lines++;
                    } else {
                        currentLine = testLine;
                    }
                }
                
                totalHeight += lines * lineHeight;
            } else {
                totalHeight += lineHeight;
            }
        }
        
        resultsSurface = surface_create(resultsWindowWidth - 20, totalHeight);
        surface_set_target(resultsSurface);
        
        // Limpar surface com cor de fundo preta
        draw_clear(resultsBackgroundColor);
        
        // Desenhar título na surface
        draw_set_color(resultsTextColor);
        draw_text(resultsPadding, resultsPadding, "Resultados encontrados: " + string(array_length(jsonFilter)));
        
        // Desenhar todos os resultados na surface
        var currentY = resultsPadding + 25;
        
        for (var i = 0; i < array_length(jsonFilter); i++) {
            draw_set_color(resultsTextColor);
            
            // Dividir o JSON em linhas se for muito longo
            var jsonText = jsonFilter[i];
            var maxWidth = resultsWindowWidth - (resultsPadding * 2) - 40;
            
            if (string_width(jsonText) > maxWidth) {
                // Quebrar texto em múltiplas linhas
                var words = string_split(jsonText, " ");
                var currentLine = "";
                var lineY = currentY;
                
                for (var j = 0; j < array_length(words); j++) {
                    var testLine = currentLine + (currentLine == "" ? "" : " ") + words[j];
                    
                    if (string_width(testLine) > maxWidth && currentLine != "") {
                        draw_text(resultsPadding + 10, lineY, currentLine);
                        currentLine = words[j];
                        lineY += lineHeight;
                    } else {
                        currentLine = testLine;
                    }
                }
                
                if (currentLine != "") {
                    draw_text(resultsPadding + 10, lineY, currentLine);
                }
                
                currentY = lineY + lineHeight;
            } else {
                draw_text(resultsPadding + 10, currentY, jsonText);
                currentY += lineHeight;
            }
        }
        
        surface_reset_target();
        surfaceNeedsUpdate = false;
    }
    
    // Desenhar borda da janela
    draw_set_color(resultsBorderColor);
    draw_rectangle(resultsWindowX, resultsWindowY, resultsWindowX + resultsWindowWidth, resultsWindowY + resultsWindowHeight, false);
    
    // Desenhar fundo da janela (preto)
    draw_set_color(resultsBackgroundColor);
    draw_rectangle(resultsWindowX + 1, resultsWindowY + 1, resultsWindowX + resultsWindowWidth - 1, resultsWindowY + resultsWindowHeight - 1, false);
    
    // Desenhar surface com scroll
    if (surface_exists(resultsSurface)) {
        var surfaceHeight = surface_get_height(resultsSurface);
        var visibleHeight = resultsWindowHeight - (resultsPadding * 2);
        
        // Calcular área de origem da surface (scroll)
        var sourceY = scrollOffset * lineHeight;
        var sourceHeight = min(visibleHeight, surfaceHeight - sourceY);
        
        // Desenhar parte visível da surface
        draw_surface_part(resultsSurface, 
                         0, sourceY, 
                         resultsWindowWidth - 20, sourceHeight, 
                         resultsWindowX + resultsPadding, resultsWindowY + resultsPadding);
    }
    
    // Desenhar barra de scroll se necessário
    if (array_length(jsonFilter) > maxVisibleLines) {
        var scrollBarWidth = 15;
        var scrollBarX = resultsWindowX + resultsWindowWidth - scrollBarWidth;
        var scrollBarHeight = resultsWindowHeight - (resultsPadding * 2);
        var scrollBarY = resultsWindowY + resultsPadding;
        
        // Fundo da barra de scroll
        draw_set_color(c_gray);
        draw_rectangle(scrollBarX, scrollBarY, scrollBarX + scrollBarWidth, scrollBarY + scrollBarHeight, false);
        
        // Indicador da posição do scroll
        var scrollRatio = scrollOffset / (array_length(jsonFilter) - maxVisibleLines);
        var indicatorHeight = max(20, scrollBarHeight * (maxVisibleLines / array_length(jsonFilter)));
        var indicatorY = scrollBarY + (scrollBarHeight - indicatorHeight) * scrollRatio;
        
        draw_set_color(c_gray);
        draw_rectangle(scrollBarX + 2, indicatorY, scrollBarX + scrollBarWidth - 2, indicatorY + indicatorHeight, false);
    }
}