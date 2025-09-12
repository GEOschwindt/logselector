///START CONFIGS

Globals();

inputReference = "";
maxInputReference = 255;
selectInputReference = false;

// DRAW
inputWidth = 400;
inputHeight = 30;
inputSpacing = 50;
startY = 100;

inputReferenceX = 50;
inputReferenceY = startY;

// BOTÕES
buttonWidth = 100;
buttonHeight = 30;
buttonSpacing = 20;

// Posicionar botões na borda direita da tela com espaçamento igual ao input
buttonMargin = 50; // Mesmo espaçamento do input na direita
buttonBuscarX = room_width - buttonMargin - buttonWidth;
buttonLimparX = buttonBuscarX - buttonWidth - buttonSpacing;

buttonBuscarY = inputReferenceY + inputSpacing;
buttonLimparY = inputReferenceY + inputSpacing;

backgroundColor = c_white;
borderColor = c_black;
selectedBorderColor = c_blue;
textColor = c_black;
buttonColor = c_gray;
buttonHoverColor = c_gray;