///DESENHAR INPUTS

draw_set_color(c_gray);
draw_rectangle(0, 0, room_width, room_height, false);

draw_set_color(c_black);
draw_set_font(-1);
draw_text(50, 30, "LOG SELECTOR");

draw_set_color(selectInputReference ? selectedBorderColor : borderColor);
draw_rectangle(inputReferenceX, inputReferenceY, room_width - inputReferenceX, inputReferenceY + inputHeight, false);
draw_set_color(backgroundColor);
draw_rectangle(inputReferenceX + 2, inputReferenceY + 2, room_width - inputReferenceX- 2, inputReferenceY + inputHeight - 2, false);

draw_set_color(textColor);
draw_text(inputReferenceX + 5, inputReferenceY + 5, "Reference: " + inputReference);

if (selectInputReference) {
    var cursorX = inputReferenceX + 5 + string_width("Reference: " + inputReference);
    var cursorY = inputReferenceY + 5;
    draw_set_color(c_black);
    draw_line(cursorX, cursorY, cursorX, cursorY + 20);
}

var hoverBuscar = (mouse_x >= buttonBuscarX && mouse_x <= buttonBuscarX + buttonWidth && 
                   mouse_y >= buttonBuscarY && mouse_y <= buttonBuscarY + buttonHeight);
draw_set_color(hoverBuscar ? make_color_rgb(10, 70, 205) : make_color_rgb(50, 100, 255));
draw_rectangle(buttonBuscarX, buttonBuscarY, buttonBuscarX + buttonWidth, buttonBuscarY + buttonHeight, false);
draw_set_color(borderColor);
draw_rectangle(buttonBuscarX, buttonBuscarY, buttonBuscarX + buttonWidth, buttonBuscarY + buttonHeight, true);
draw_set_color(textColor);
draw_text(buttonBuscarX + 10, buttonBuscarY + 8, "Buscar");

var hoverLimpar = (mouse_x >= buttonLimparX && mouse_x <= buttonLimparX + buttonWidth && 
                   mouse_y >= buttonLimparY && mouse_y <= buttonLimparY + buttonHeight);
draw_set_color(hoverLimpar ? make_color_rgb(150, 150, 150) : make_color_rgb(200, 200, 200));
draw_rectangle(buttonLimparX, buttonLimparY, buttonLimparX + buttonWidth, buttonLimparY + buttonHeight, false);
draw_set_color(borderColor);
draw_rectangle(buttonLimparX, buttonLimparY, buttonLimparX + buttonWidth, buttonLimparY + buttonHeight, true);
draw_set_color(textColor);
draw_text(buttonLimparX + 10, buttonLimparY + 8, "Limpar");

// EXIBIR PROGRESSO DE BUSCA
if (global.Buscando) {
    var progressY = buttonBuscarY + buttonHeight + 30;
    var progressBarWidth = room_width - inputReferenceX - inputReferenceX; // Largura da barra considerando margens
    
    // Desenhar fundo da barra de progresso
    draw_set_color(c_white);
    draw_rectangle(inputReferenceX, progressY, inputReferenceX + progressBarWidth, progressY + 20, false);
    draw_set_color(c_black);
    draw_rectangle(inputReferenceX, progressY, inputReferenceX + progressBarWidth, progressY + 20, true);
    
    // Calcular largura da barra de progresso
    var progressWidth = 0;
    if (global.ProgressoTotal > 0) {
        progressWidth = ((progressBarWidth - 4) * global.ProgressoAtual) / global.ProgressoTotal;
    }
    
    // Desenhar barra de progresso
    if (progressWidth > 0) {
        draw_set_color(c_green);
        draw_rectangle(inputReferenceX + 2, progressY + 2, inputReferenceX + 2 + progressWidth, progressY + 18, false);
    }
    
    // Exibir contadores
    var counterY = progressY + 25;
	draw_set_color(c_black)
    draw_text(inputReferenceX + 5, counterY, "Arquivos: " + string(global.ProgressoAtual) + " / " + string(global.ProgressoTotal));
    
    // Exibir texto de progresso (arquivo atual) abaixo da barra
    var textY = progressY + 45;
    draw_set_color(c_black);
    draw_text(inputReferenceX + 5, textY, global.ProgressoTexto);
}
