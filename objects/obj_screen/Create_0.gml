///START CONFIGS

Globals();

jsonFilter = [];

inputPathLogs = "";
inputPathSave = "";
inputReference = "";

maxInputPathLogs = 255;
maxInputPathSave = 255;
maxInputReference = 255;

selectInputPathLogs = false;
selectInputPathSave = false;
selectInputReference = false;

// DRAW
inputWidth = 400;
inputHeight = 30;
inputSpacing = 50;
startY = 100;

inputPathLogsX = 50;
inputPathLogsY = startY;

inputPathSaveX = 50;
inputPathSaveY = startY + inputSpacing;

inputReferenceX = 50;
inputReferenceY = startY + (inputSpacing * 2);

// BOTÕES
buttonWidth = 100;
buttonHeight = 30;
buttonSpacing = 20;

buttonStartX = inputReferenceX + inputWidth + buttonSpacing;
buttonBuscarY = inputReferenceY + inputSpacing;
buttonLimparY = buttonBuscarY + inputSpacing;

buttonBuscarX = buttonStartX;
buttonLimparX = buttonStartX;

// JANELA DE RESULTADOS
resultsWindowX = 50;
resultsWindowY = buttonLimparY + buttonHeight + 30; // Abaixo dos botões
resultsWindowWidth = room_width - 100; // Largura total menos margens
resultsWindowHeight = room_height - resultsWindowY - 50; // Altura restante da tela
resultsPadding = 10;
lineHeight = 20;
scrollOffset = 0;
maxVisibleLines = floor((resultsWindowHeight - (resultsPadding * 2)) / lineHeight);

// SURFACE PARA SCROLL
resultsSurface = -1;
surfaceNeedsUpdate = true;

backgroundColor = c_white;
borderColor = c_black;
selectedBorderColor = c_blue;
textColor = c_black;
buttonColor = c_gray;
buttonHoverColor = c_gray;
resultsBackgroundColor = c_black; // Fundo preto
resultsBorderColor = c_white; // Borda branca
resultsTextColor = c_white; // Texto branco